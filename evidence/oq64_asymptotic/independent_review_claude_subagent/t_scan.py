import sys, math
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F
from t1fill import wbound
a=(math.sqrt(2)-1)/2
def V3(l,e,j):
    m=l*(l+1)//2+l*j+e*(j+1)-1
    return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e
def wb_fast(l,j,e,caseI):
    q=l-j; sS1=l*j+l*(l+1)//2; sDW=j*(4*l-j+1)//2; u=1 if caseI else j+2
    sz=(q-1)*(j+2)+q*(q-1)//2
    return sS1+sDW+q*(sS1+(e-1)*u)+sz+(j+3)+(l+j)+2*l*e+(e-1)*u
# sanity: fast == text formula
for l in range(6,40):
    for j in range(2,l-1):
        for e in (1,5,17):
            for cI in (True,False): assert wb_fast(l,j,e,cI)==wbound(l,j,e,cI)
bad=[]
ls=list(range(50,3001))+list(range(3001,40001,997))
for l in ls:
    e0=math.ceil(a*l+4); N=F(l+e0,l)
    if not all(wb_fast(l,j,e0,cI)<=N for j in range(2,l-1) for cI in (True,False)): bad.append(('U',l))
    e1=math.floor(a*l-4)
    if not any(V3(l,e1,j)-1>=F(l+e1,l) for j in range(1,l)): bad.append(('L',l))
print('scanned',len(ls),'values of l in [50,40000]; failures:',bad[:20])
