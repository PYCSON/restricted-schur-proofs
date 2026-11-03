#!/usr/bin/env python3
"""Exact (sympy, sqrt(2) kept symbolic) all-l proofs for the asymptotic constant a* = (sqrt2-1)/2.
UPPER (T1-fill worst-case bound, cases I/II): P(j) = N - w_bound is a convex quadratic in j; it is >= 0 for
  every real j iff Q = 4*al*ga - be^2 >= 0.  We show Q(l, e0) >= 0 at e0 = a* l + CU for all real l >= L1 by
  checking that every coefficient of Q(L1+u, e0) in u is >= 0; P is increasing in e for l >= 9 (proved in note).
LOWER (three-block): G(j) = V3 - F is a concave quadratic in j (al' = 1-e-l < 0).  Some integer j has G >= 1 if
  4A ga' + be'^2 - A^2 - 4A >= 0 (A = -al').  Shown at e1 = a* l - CL for all real l >= L1; G decreasing in e."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
import sympy as sp
CU=sp.Rational(sys.argv[1]); CL=sp.Rational(sys.argv[2]); L1=int(sys.argv[3])
l,e,j,u=sp.symbols('l e j u',real=True)
a=(sp.sqrt(2)-1)/2
k=l+e; N=k**2+((l+1)*(l-2)/2+2)*k+l*(l-2)
def wb(case):
    q=l-j; S1=l*j+l*(l+1)/2; D=j*(4*l-j+1)/2; uu=1 if case=='I' else j+2
    z=(q-1)*(j+2)+q*(q-1)/2
    return S1+D+q*(S1+(e-1)*uu)+z+(j+3)+(l+j)+e*2*l+(e-1)*uu
def allpos(expr):
    p=sp.Poly(sp.expand(expr),u); bad=[]
    for (d,),cf in p.terms():
        cf=sp.nsimplify(sp.expand(cf))
        if not (cf>=0): bad.append((d,cf,float(cf)))   # exact sign of a+b*sqrt2
    return bad
ok=True
for case in ('I','II'):
    P=sp.expand(N-wb(case)); Pj=sp.Poly(P,j); al,be,ga=[Pj.coeff_monomial(j**i) for i in (2,1,0)]
    assert sp.simplify(al-(l+1 if case=='I' else l+e))==0
    Q=4*al*ga-be**2
    bad=allpos(Q.subs(e,a*l+CU).subs(l,L1+u))
    print(f'UPPER case {case}: e0 = a*l + {CU}, l >= {L1}:', 'PASS' if not bad else f'FAIL {bad}')
    ok&=not bad
q=l-j; m1=l*(l+1)/2+l*j+e*(j+1)
G=sp.expand(j*(j+1)/2+q*m1+q*(q-1)/2+e-N)
Gj=sp.Poly(G,j); al2,be2,ga2=[Gj.coeff_monomial(j**i) for i in (2,1,0)]
assert sp.simplify(al2-(1-e-l))==0
A=-al2
H=4*A*ga2+be2**2-A**2-4*A
bad=allpos(H.subs(e,a*l-CL).subs(l,L1+u))
print(f'LOWER: e1 = a*l - {CL}, l >= {L1}:', 'PASS' if not bad else f'FAIL {bad}')
ok&=not bad
# vertex of G must lie in [1, l-1] (so the rounded integer j is admissible)
jv=-be2/(2*al2)
for nm,ex in (('jv-1',jv-1),('l-1-jv',l-1-jv)):
    num,den=sp.fraction(sp.together(ex.subs(e,a*l-CL).subs(l,L1+u)))
    if allpos(-den)==[]: num,den=-num,-den      # denominator negative on the region: flip both
    b1=allpos(num); b2=allpos(den)
    print('  vertex check',nm,'PASS' if not b1 and not b2 else ('FAIL',b1,b2)); ok&=not b1 and not b2
print('=>','ALL PASS' if ok else 'NOT ALL')
