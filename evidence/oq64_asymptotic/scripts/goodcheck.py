#!/usr/bin/env python3
"""Independent brute-force check that a 2-colouring of [1,n] is good: no monochromatic
x1+...+xk = y with exactly l distinct summand values (y then differs from all of them).
Bitset DP over (distinct count c, total count t)."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
def mono_sums(vals,k,l,n):
    mask=(1<<(n+1))-1
    dp=[[0]*(k+1) for _ in range(l+1)]; dp[0][0]=1
    for v in vals:
        for c in range(l-1,-1,-1):
            for t in range(k-1,c-1,-1):
                cur=dp[c][t]
                if not cur: continue
                for mu in range(1,k-t+1):
                    if c+1==l and t+mu!=k: continue      # final layer only needs t=k
                    sh=(cur<<(mu*v))&mask
                    if not sh: break
                    dp[c+1][t+mu]|=sh
    return dp[l][k]
def is_good(col,k,l):
    n=len(col)-1
    for c in 'RB':
        vals=[x for x in range(1,n+1) if col[x]==c]
        s=mono_sums(vals,k,l,n)
        hits=[y for y in vals if (s>>y)&1]
        if hits: return False,(c,hits[:5])
    return True,None
if __name__=='__main__':
    def V3(l,e,j):
        m=l*(l+1)//2+l*j+e*(j+1)-1
        return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e, m
    for l,e in [(4,1),(4,2),(5,1),(5,3),(6,1),(6,2),(7,2),(8,1)]:
        k=l+e
        for j in range(1,l):
            V,m=V3(l,e,j)
            col=[None]+['R' if (x<=j or x>m) else 'B' for x in range(1,V)]
            g,_=is_good(col,k,l)
            colV=col+['R']; colV2=col+['B']
            t1,_=is_good(colV,k,l); t2,_=is_good(colV2,k,l)
            print(f"l={l} e={e} j={j} V3={V}: [1,V3-1] good={g}; extending to V3 good? R:{t1} B:{t2}",flush=True)
