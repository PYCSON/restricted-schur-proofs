#!/usr/bin/env python3
"""Independent algebraic audit of R37/R38. No imported producer source."""
if not __debug__: raise SystemExit('REFUSE optimized Python')
import sympy as s, json
l,e,j,u=s.symbols('l e j u', real=True)
a=(s.sqrt(2)-1)/2
k=l+e
F=s.expand(k*k+((l+1)*(l-2)/2+2)*k+l*(l-2))
D=l*(l-1)/2
q=l-j
mm=l*(l+1)/2+l*j+e*(j+1)-1
V3=s.expand(j*(j+1)/2+q*(mm+1)+q*(q-1)/2+e)
G=s.expand(V3-F)
assert s.expand(G).coeff(j,2)==1-e-l
# q-width sum upper for two cases
results={}
for case in ('I','II'):
    S=l*(l+1)/2+l*j
    DB=j*(4*l-j+1)/2
    U=1 if case=='I' else j+2
    Z=(q-1)*(j+2)+q*(q-1)/2
    W=s.expand(S+DB+q*(S+(e-1)*U)+Z+(j+3)+(l+j)+e*2*l+(e-1)*U)
    P=s.expand(F-W)
    aa=s.Poly(P,j).coeff_monomial(j*j)
    bb=s.Poly(P,j).coeff_monomial(j)
    cc=s.Poly(P,j).coeff_monomial(1)
    assert s.simplify(aa- (l+1 if case=='I' else l+e))==0
    Q=s.simplify(4*aa*cc-bb*bb)
    Q_at=s.expand(Q.subs(e,a*l+4).subs(l,50+u))
    poly=s.Poly(Q_at,u)
    for deg,co in poly.terms(): assert bool(s.simplify(co)>=0), (case,deg,co)
    # monotonic in e across [2,l-2]
    der=s.diff(P,e)
    print('CASE',case,'P coefficient j²:',aa,'derivative in e:',s.factor(der),'quartic discriminant coefficients:',[(str(t[0][0]),str(s.simplify(t[1]))) for t in poly.terms()])
    results['upper_'+case]={'P':str(P),'Q_expansion_at_ell50':str(Q_at),'derivative':str(der)}
AA= -s.Poly(G,j).coeff_monomial(j*j)
BB= s.Poly(G,j).coeff_monomial(j)
CC= s.Poly(G,j).coeff_monomial(1)
HH=s.simplify(4*AA*CC+BB**2-AA**2-4*AA)
HH_at=s.expand(HH.subs(e,a*l-4).subs(l,50+u)); pp=s.Poly(HH_at,u)
for mon,co in pp.terms(): assert bool(s.simplify(co)>=0), (mon,co)
vertex=s.factor(BB/(2*AA))
print('LOWER G(j)=',s.collect(G,j))
print('LOWER H translated=',[(m[0],str(s.simplify(c))) for m,c in pp.terms()])
print('vertex=',vertex)
# derivative claimed precise form
print('dG/de=',s.factor(s.diff(G,e)))
print('F ell19 e1',F.subs({l:19,e:1}), 'V3 j5', V3.subs({l:19,e:1,j:5}))
print('F ell20 e1',F.subs({l:20,e:1}), 'V3 j5', V3.subs({l:20,e:1,j:5}))
# for real ell>=50 check vertex in interval via numerator expression sign numeric + exact coefficient
for tag,z in [('vertex_ge_1',vertex-1),('vertex_le_l-1',l-1-vertex)]:
    rat=s.together(z.subs(e,a*l-4).subs(l,50+u)); num,den=map(s.expand,s.fraction(rat))
    if den.subs(u,0).evalf()<0: num,den=-num,-den
    for exp in (num,den):
        coeffs=s.Poly(exp,u).all_coeffs()
        assert all(c.evalf(30)>0 for c in coeffs),(tag,coeffs)
    print(tag,'PASS')
# e monotonic in lower construction: <= 0 for integer 1<=j<=l-1, e>=1, check by factor / pos
assert all(s.diff(G,e).subs({l:L,j:J,e:E})<0 for L in range(12,40) for J in range(1,L) for E in (1,L,2*L))
# negative controls cU3 at ell=50 or higher when Q negative
neg=[]
for L in (50,100,500,1000,5000):
 for case in ('I','II'):
  S=l*(l+1)/2+l*j; DB=j*(4*l-j+1)/2; U=1 if case=='I' else j+2; Z=(q-1)*(j+2)+q*(q-1)/2
  W=s.expand(S+DB+q*(S+(e-1)*U)+Z+(j+3)+(l+j)+e*2*l+(e-1)*U)
  P=s.expand(F-W)
  aq=s.Poly(P,j).coeff_monomial(j*j); bq=s.Poly(P,j).coeff_monomial(j); cq=s.Poly(P,j).coeff_monomial(1)
  chk=(4*aq*cq-bq*bq).subs({l:L,e:a*L+3}).evalf(25)
  if chk<0:neg.append((L,case,str(chk)))
assert neg
print('NEGATIVE cU=3:',neg)
results['lower']={'G':str(G),'H_at50':str(HH_at),'vertex':str(vertex),'derivative':str(s.diff(G,e))}
results['negative_control']=neg
with open('/mnt/data/rsn_r6_review/output/symbolic.json','w') as f:json.dump(results,f,indent=2)
print('SYMBOLIC PASS')
