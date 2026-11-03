if not __debug__: raise SystemExit("refusing to run under python -O")
import sys
sys.argv=[sys.argv[0]]
exec(open('goodcheck.py').read().split("if __name__")[0])
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
for l,k in [(5,6),(6,7),(6,8),(7,9),(20,21)]:
    D=l*(l-1)//2; s=k+D; t=k*s+D; f=F(k,l)
    col=[None]+['R' if (x<s or x>=t) else 'B' for x in range(1,f)]
    g=is_good(col,k,l)[0]; ext=[is_good(col+[c],k,l)[0] for c in 'RB']
    print(f"Gaiser 3-segment l={l} k={k}: F={f}, good on [1,F-1]={g}, extendable to F: {ext}")
