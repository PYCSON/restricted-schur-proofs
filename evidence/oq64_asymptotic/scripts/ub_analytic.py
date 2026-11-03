if not __debug__: raise SystemExit("refusing to run under python -O")
import sympy as sp
l,e,j,c,s,u=sp.symbols('l e j c s u',real=True)
k=l+e
N=k**2+((l+1)*(l-2)/2+2)*k+l*(l-2)
def wb(case):
    q=l-j
    S1=l*j+l*(l+1)/2; D=j*(4*l-j+1)/2
    uu=1 if case=='I' else j+2
    z=(q-1)*(j+2)+q*(q-1)/2
    return S1+D+q*(S1+(e-1)*uu)+z+(j+3)+(l+j)+e*2*l+(e-1)*uu
astar=(sp.sqrt(2)-1)/2
for case in ('I','II'):
    P=sp.expand(N-wb(case))
    Pj=sp.Poly(P,j); al,be,ga=[Pj.coeff_monomial(j**i) for i in (2,1,0)]
    print('case',case,'j^2 coeff:',sp.factor(al))
    disc=sp.expand(be**2-4*al*ga)     # need disc <= 0  (al>0) for P>=0 for all real j
    # substitute e = a* l + c and expand in l
    dsub=sp.expand(disc.subs(e,astar*l+c))
    pl=sp.Poly(dsub,l)
    for d in range(pl.degree(),-1,-1):
        co=sp.simplify(pl.coeff_monomial(l**d))
        print('  l^%d:'%d, sp.nsimplify(co) if d>=pl.degree()-1 else sp.expand(co))
