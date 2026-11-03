import sys
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
import sympy as sp
from good import *
from t_j1 import chain
# (a) j=1 symbolic, my own polynomial forms of the worst-case conditions
l,e,u,s=sp.symbols('l e u s')
N=(l+e)**2+(l*(l-1)/2+1)*(l+e)+l*(l-2); qq=l-1
conds={}
# case II
sS=l*(l+3)/2; top=sS+(l+1)*e; cnt=(l-1)*e+1; A=sS+2*e; V0=(1+e)+qq*A+qq*(qq-1)/2; P=(l-1)*(l+2)/2+2*e
conds['II_top']=N-top; conds['II_cnt']=cnt-qq; conds['II_width']=qq*(cnt-qq)-P; conds['II_end']=N-(V0+P)
# case I uniform worst case: sS<=(l+1)(l+2)/2-2, b0<=2l, I1 count=(e-1)(l-1)-1, sum T<=(l-1)(l+2)/2
sS=(l+1)*(l+2)/2-2; top=sS+(l+1)*e; cnt=(e-1)*(l-1)-1; A=sS+e+2; V0=2*l*(e+1)+qq*A+qq*(qq-1)/2; P=(l-1)*(l+2)/2+e
conds['I_top']=N-top; conds['I_cnt']=cnt-qq; conds['I_width']=qq*(cnt-qq)-P; conds['I_end']=N-(V0+P)
for (L1,E1) in [(7,3),(6,4),(6,3)]:
    bad=[]
    for nm,G in conds.items():
        p=sp.Poly(sp.expand(G.subs({l:L1+u,e:E1+s})),u,s)
        if any(c<0 for c in p.coeffs()): bad.append(nm)
    print(f'j=1 symbolic (l>={L1}, e>={E1}): conditions with a negative coefficient: {bad}')
# (b) j=1 consistency against good colourings of ANY length (chain must not close below V)
inc=0;tot=0
for l in range(6,41):
    for e in range(1,25):
        for kind in '34':
            col,V,m=threeblock(l,e,1) if kind=='3' else fourblock(l,e,1)
            r=chain(l,e,col[:2*l+1],10**18,chi=col); tot+=1
            if r and r[0] in ('CHI',): inc+=1; print('CHI',kind,l,e,r)
            if r and r[0]=='CLASH' and r[1]<V: inc+=1; print('j1 closes below V',kind,l,e,r,V)
print('j=1 vs good colourings of any length:',tot,'cases, inconsistencies',inc)
# (c) 'not extendable' side claim for three-block
ne=[]
for (L,E) in [(4,1),(4,2),(5,1),(5,3),(6,1),(6,2),(7,2),(8,1)]:
    for j in range(1,L):
        col,V3,m=threeblock(L,E,j)
        ext=[c for c in 'RB' if is_good(col+[c],L+E,L)]
        if ext: ne.append((L,E,j,ext))
print('three-block extendable cases among the listed ones:',ne)
# (d) four-block colouring goodness (used as a test family)
nb=0
for L in range(3,10):
    for E in range(0,4):
        for j in range(1,L):
            col,V,m=fourblock(L,E,j)
            if m<j+2: continue
            if not is_good(col,L+E,L): nb+=1
print('four-block colourings not good (l<=9,e<=3):',nb)
# (e) diagonal sanity: max_j V3(k,0,j) vs claimed exact WS values
ws={8:365,9:505,10:676,11:881,12:1123,13:1405,14:1730}
for k,v in ws.items():
    mx=max(threeblock(k,0,j)[1] for j in range(1,k))
    print(f'k={k}: max_j V3(k,0,j)={mx}  claimed WS_k(2)={v}  ok(<=)={mx<=v}')
k=20; col,V,m=threeblock(20,0,4); print('k=20,j=4: V3=',V,'Ahmed bound',(k**3+4*k**2-5*k+2)//2)
