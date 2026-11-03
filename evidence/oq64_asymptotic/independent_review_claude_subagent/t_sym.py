import sympy as sp
l,e,j,u,x,eps,c=sp.symbols('l e j u x epsilon c',real=True)
k=l+e; D=l*(l-1)/2
N=sp.expand(k**2+(D+1)*k+l*(l-2))
# ---- lower bound: G = V3 - F
m=l*(l+1)/2+l*j+e*(j+1)-1
V3=j*(j+1)/2+(l-j)*(m+1)+(l-j)*(l-j-1)/2+e
G=sp.expand(V3-N)
Gj=sp.Poly(G,j); a2,a1,a0=[Gj.coeff_monomial(j**i) for i in (2,1,0)]
print('G j^2 coeff:',sp.factor(a2))
cub=sp.expand(G.subs({j:x*l,e:eps*l}))
cub3=sp.Poly(cub,l).coeff_monomial(l**3)
print('cubic coefficient of G (j=xl,e=eps l):',sp.factor(cub3))
target=-(eps*(2*x**2-2*x+1)+2*x**2-x)/2
print('matches text:',sp.simplify(cub3-target)==0)
f=(x-2*x**2)/(2*x**2-2*x+1)
crit=sp.solve(sp.diff(f,x),x); print('critical x:',crit,[sp.nsimplify(sp.simplify(f.subs(x,cc))) for cc in crit])
astar=(sp.sqrt(2)-1)/2
print('a* value check:',[sp.simplify(f.subs(x,cc)-astar) for cc in crit])
# dG/de
dGe=sp.expand(sp.diff(G,e)); print('dG/de =',sp.factor(dGe))
# max over j of dG/de
jstar=sp.solve(sp.diff(dGe,j),j)[0]; print('dG/de max over j =',sp.expand(dGe.subs(j,jstar)))
# H at e1 = a* l - 4
A=-a2
H=sp.expand(4*A*a0+a1**2-A**2-4*A)
def coeffs_nonneg(expr,var):
    p=sp.Poly(sp.expand(expr),var); res=[]
    for (d,),cf in p.terms():
        cfs=sp.nsimplify(sp.expand(cf)); res.append((d,cfs,float(cfs)))
    return res
for (CL,L1) in [(4,50),(4,49),(4,45),(3,50),(3.5,50)]:
    CL=sp.nsimplify(CL)
    cs=coeffs_nonneg(H.subs(e,astar*l-CL).subs(l,L1+u),u)
    neg=[(d,v) for d,cf,v in cs if v<0]
    print(f'LOWER H at e1=a*l-{CL}, l={L1}+u: negative coeffs:',neg)
# vertex in [1,l-1]
jv=-a1/(2*a2)
for L in [50,100,1000,10**5]:
    vv=jv.subs(e,astar*l-4).subs(l,L); print('vertex at l=',L,float(vv),'l-1=',L-1)
# ---- upper bound: w bound from the text
def wb(case):
    q=l-j
    S1=l*j+l*(l+1)/2
    DW=sp.summation(2*l-j+sp.Symbol('i'),(sp.Symbol('i'),1,j))
    uu=1 if case=='I' else j+2
    zz=sp.summation(j+sp.Symbol('i')+2,(sp.Symbol('i'),1,q-1))
    return S1+DW+q*(S1+(e-1)*uu)+zz+(j+3)+(l+j)+e*2*l+(e-1)*uu
for case in ('I','II'):
    P=sp.expand(N-wb(case)); Pj=sp.Poly(P,j); al,be,ga=[Pj.coeff_monomial(j**i) for i in (2,1,0)]
    print('case',case,'P j^2 coeff:',sp.factor(al))
    Q=sp.expand(4*al*ga-be**2)
    for CU,L1 in [(4,50),(4,40),(3,50),(sp.Rational(7,2),50)]:
        cs=coeffs_nonneg(Q.subs(e,astar*l+CU).subs(l,L1+u),u)
        neg=[(d,round(v,3)) for d,cf,v in cs if v<0]
        print(f'  UPPER case {case}: Q at e0=a*l+{CU}, l={L1}+u: negative coeffs:',neg)
    disc=sp.expand((be**2-4*al*ga).subs(e,astar*l+c))
    pl=sp.Poly(disc,l)
    print('  disc leading coeffs (l^deg):',[(d,sp.nsimplify(sp.expand(pl.coeff_monomial(l**d)))) for d in range(pl.degree(),pl.degree()-2,-1)])
    dPe=sp.expand(sp.diff(P,e)); js=sp.solve(sp.diff(dPe,j),j)
    print('  dP/de =',sp.factor(dPe),'; min over j:',[sp.expand(dPe.subs(j,s_)) for s_ in js])
