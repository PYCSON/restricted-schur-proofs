#!/usr/bin/env python3
"""Relaxed version (Gaiser S_2(k; l~)): forbid monochromatic solutions with AT LEAST l distinct summand
values (c(S) >= l+1 counting the sum).  Bitset DP with the distinct count capped at l."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def mono_sums(vals,k,l,n):
    mask=(1<<(n+1))-1
    dp=[[0]*(k+1) for _ in range(l+1)]; dp[0][0]=1
    for v in vals:
        new=[row[:] for row in dp]
        for c in range(l+1):
            for t in range(c if c<l else l, k):
                cur=dp[c][t]
                if not cur: continue
                c2=min(c+1,l)
                for mu in range(1,k-t+1):
                    sh=(cur<<(mu*v))&mask
                    if not sh: break
                    new[c2][t+mu]|=sh
        dp=new
    return dp[l][k]
def is_good(col,k,l):
    n=len(col)-1
    for c in 'RB':
        vals=[x for x in range(1,n+1) if col[x]==c]
        s=mono_sums(vals,k,l,n)
        if any((s>>y)&1 for y in vals): return False
    return True
if __name__=='__main__':
    def V3(l,e,j):
        m=l*(l+1)//2+l*j+e*(j+1)-1
        return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e, m
    for l,e in [(4,1),(5,2),(6,1),(6,2),(7,1)]:
        k=l+e
        for j in range(1,l):
            V,m=V3(l,e,j); col=[None]+['R' if (x<=j or x>m) else 'B' for x in range(1,V)]
            print('relaxed 3-block',l,e,j,'good:',is_good(col,k,l),'extendable:',[is_good(col+[c],k,l) for c in 'RB'],flush=True)
        D=l*(l-1)//2; s=k+D; t=k*s+D; f=F(k,l)
        col=[None]+['R' if (x<s or x>=t) else 'B' for x in range(1,f)]
        print('relaxed Gaiser 3-seg',l,e,'good on [1,F-1]:',is_good(col,k,l),flush=True)
    for l,e,j in [(19,1,5),(20,1,5)]:
        k=l+e; V,m=V3(l,e,j); col=[None]+['R' if (x<=j or x>m) else 'B' for x in range(1,V)]
        print('relaxed 3-block',l,e,j,'V3',V,'F',F(k,l),'good:',is_good(col,k,l),flush=True)
