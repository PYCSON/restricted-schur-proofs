import sys, math
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F
from t1fill import wbound
c=(1+math.sqrt(2))/2; a=(math.sqrt(2)-1)/2
def V3(l,e,j):
    m=l*(l+1)//2+l*j+e*(j+1)-1
    return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e
def okU(l,e): return all(wbound(l,j,e,cI)<=F(l+e,l) for j in range(2,l-1) for cI in (True,False))
def okJ1(l,e):
    # my own derivation of the j=1 chain worst-case conditions
    if e<2: return False
    N=F(l+e,l); qq=l-1
    # case II: D_W={1}; S=[2,l+1]
    sS=sum(range(2,l+2)); top=sS+(l+1)*e; cnt=(l-1)*e+1; A=sS+2*e
    V0=(1+e)+qq*A+qq*(qq-1)//2; width=qq*(cnt-qq); P=sum(range(2,l+1))+2*e
    c2= top<=N and cnt>=qq and P<=width and V0+P<=N
    # case I: worst over b0; S = [1,l] (b0>l) or [1,l+1]\{b0}; use I1 = sS+[e+2, e+(e-1)(l-1)]
    ok1=True
    for b0 in range(2,2*l+1):
        if b0>l: sS=l*(l+1)//2
        else: sS=(l+1)*(l+2)//2-b0
        lo=sS+e+2; hi=sS+e+(e-1)*(l-1); cnt=hi-lo+1
        top=sS+e*(l+1)
        V0=b0*(e+1)+qq*lo+qq*(qq-1)//2; width=qq*(cnt-qq)
        T=sorted([x for x in range(1,2*l+1) if x!=b0])[:l-1]; P=sum(T)+e
        ok1 &= top<=N and cnt>=qq and P<=width and V0+P<=N
    return c2 and ok1
def least(fn,l,start=1):
    e=start
    while not fn(l,e): e+=1
    return e
mx=-99; rows=[]
for l in range(6,50):
    eu=least(okU,l); ej=least(okJ1,l,2)
    # monotone check far beyond
    assert all(okU(l,x) for x in range(eu,eu+6*l)), l
    assert all(okJ1(l,x) for x in range(ej,ej+6*l)), l
    el=max([e for e in range(1,3*l) if any(V3(l,e,j)-1>=F(l+e,l) for j in range(1,l))] or [0])
    # check el is truly the max (no larger e good)
    up=l+max(eu,ej); lo=l+el+1
    mx=max(mx,up-c*l)
    flag=''
    if l>=19 and not lo> c*l-4: flag+=' LOWER-CLAIM-FAILS'
    if not up<=c*l+9: flag+=' UPPER-CLAIM-FAILS'
    rows.append((l,eu,ej,el,lo,up))
    print(f'l={l:2d} eU={eu:2d} eJ1={ej} eL={el:2d}  K in [{lo},{up}]  c*l={c*l:6.2f} up-c*l={up-c*l:5.2f}{flag}')
print('max up - c*l', round(mx,3))
