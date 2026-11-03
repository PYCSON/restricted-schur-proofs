#!/usr/bin/env python3
"""Fact 1 (constructive check of the written proof).  For an interval [a,b] with n=b-a+1 >= l+2 and
k=l+e (e>=1), every integer in [ka+D, kb-D] (D=l(l-1)/2) is a k-term sum with exactly l distinct values
from [a,b].  The proof's explicit multisets are generated and checked one by one:
  blocks S_c=[c,c+l-1] with e extras moved one unit at a time inside the block;
  for e=1 the value Sig_c + c + l between blocks c and c+1 is produced by
     S=[c,c+l-2] U {c+l+1}, extra c+l-2   (if c+l+1<=b)   or
     S={c-1} U [c+2,c+l],   extra c+2     (if c=b-l, then c-1>=a since n>=l+2)."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
def check(l,e,a,b):
    k=l+e; D=l*(l-1)//2; got=set()
    def add(S,extras):
        assert len(set(S))==l and all(a<=x<=b for x in S) and all(x in S for x in extras) and len(extras)==e
        got.add(sum(S)+sum(extras))
    for c in range(a,b-l+2):
        S=list(range(c,c+l))
        # extras: e copies, all start at c; move them up one at a time (each move +1)
        ext=[c]*e; add(S,ext)
        for i in range(e):                      # move copy i from c to c+l-1 step by step
            for _ in range(l-1):
                ext[i]+=1; add(S,ext)
        if e==1 and c+1<=b-l+1:                 # gap value Sig_c + c + l
            if c+l+1<=b: add(list(range(c,c+l-1))+[c+l+1],[c+l-2])
            else:
                assert c-1>=a
                add([c-1]+list(range(c+2,c+l+1)),[c+2])
    need=set(range(k*a+D,k*b-D+1))
    return need<=got
bad=0; cnt=0
for l in range(3,31):
    for e in range(1,6):
        for a in range(1,6):
            for n in range(l+2,l+12):
                cnt+=1
                if not check(l,e,a,a+n-1): bad+=1; print('FAIL',l,e,a,n)
print(cnt,'cases, failures:',bad)
