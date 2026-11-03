import sympy as sp, sys
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F
l,e,j,eps=sp.symbols('l e j epsilon',real=True)
k=l+e; N=sp.expand(k**2+(l*(l-1)/2+1)*k+l*(l-2))
q=l-j; S1=l*j+l*(l+1)/2; DW=j*(4*l-j+1)/2; zz=(q-1)*(j+2)+q*(q-1)/2
for case,uu in (('I',1),('II',j+2)):
    wb=S1+DW+q*(S1+(e-1)*uu)+zz+(j+3)+(l+j)+e*2*l+(e-1)*uu
    P=sp.Poly(sp.expand(N-wb),j); al,be,ga=[P.coeff_monomial(j**i) for i in (2,1,0)]
    disc=sp.expand((be**2-4*al*ga).subs(e,eps*l))
    pl=sp.Poly(disc,l); d=pl.degree(); lead=sp.factor(pl.coeff_monomial(l**d))
    print('case',case,'disc leading l^%d coeff at e=eps*l:'%d,lead,' roots in eps:',sp.solve(lead,eps))
# parity window, k even: one-step contradiction
bad=0
for L in range(3,200):
    for E in range(1,150):
        if (L+E)%2: continue
        V=L*(L+1)+2*E; sig=L+2*E
        if not (E<=sig<=E*(2*L-1) and (sig-E)%2==0 and V<=F(L+E,L)): bad+=1
print('parity k even one-step check failures:',bad)
