if not __debug__: raise SystemExit("refusing to run under python -O")
import sys
sys.argv=[sys.argv[0]]
exec(open('goodcheck.py').read().split("if __name__")[0])
def V3(l,e,j):
    m=l*(l+1)//2+l*j+e*(j+1)-1
    return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e, m
for k in (8,12,20):
    l=k; best=max(range(1,l),key=lambda j:V3(l,0,j)[0]); V,m=V3(l,0,best)
    col=[None]+['R' if (x<=best or x>m) else 'B' for x in range(1,V)]
    ext=[is_good(col+[c],k,l)[0] for c in 'RB']
    print(f'diagonal k=l={k}: j={best} V3={V} Ahmed={(k**3+4*k*k-5*k+2)//2}  [1,V3-1] good={is_good(col,k,l)[0]} extendable={ext}',flush=True)
