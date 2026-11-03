if not __debug__: raise SystemExit("refusing to run under python -O")
import sys
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def V3(l,e,j):
    m=l*(l+1)//2+l*j+e*(j+1)-1           # largest m with min blue k-sum > m
    return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e, m
def V4(l,e,j):
    m=e+(l-1)*j+l*(l+1)//2-1
    return j*(j+3)//2+(l-j)*m+(l-j)*(l-j+1)//2+2*e, m
for l in [int(x) for x in sys.argv[1:]]:
    out=[]
    for e in range(1,l+1):
        k=l+e; f=F(k,l)
        b3=max((V3(l,e,j)[0],j) for j in range(1,l))
        b4=max((V4(l,e,j)[0],j) for j in range(1,l))
        out.append((e,f,b3,b4))
    # largest e with best V > F (i.e. S2 > F there)
    e3=[e for e,f,b3,b4 in out if b3[0]>f]; e4=[e for e,f,b3,b4 in out if b4[0]>f]
    print(l,'3-block: e with V3>F:',e3[:3],'..',e3[-3:] if e3 else None,' 4-block:',e4[-3:] if e4 else None)
    print('   e=1: F',out[0][1],'V3',out[0][2],'V4',out[0][3])
