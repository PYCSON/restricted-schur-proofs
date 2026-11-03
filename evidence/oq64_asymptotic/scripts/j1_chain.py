#!/usr/bin/env python3
"""j = 1 windows (minority colour D has exactly one element of W=[1,2l]) via the 3-step chain with
q' = l-1 (all other places of Step 2 are interval values).  Worst-case bounds, exact integers.
Case I : D_W={b0}, M red, S = [1,l] (b0>l) or [1,l+1] minus {b0} (b0<=l); eS ⊇ [e+2, e+(e-1)(l-1)] (Lemma G, e>=2).
Case II: D_W={1},  M blue = [2,2l], S = [2,l+1];      eS = [2e,(l+1)e]."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def ok(l,e):
    if e<2: return False
    N=F(l+e,l); qq=l-1
    # case I
    sS=(l+1)*(l+2)//2-2; smax=l+1; A=sS+e+2; L=(e-1)*(l-1)-2; b0=2*l
    P=(l-1)*(l+2)//2+e
    V0=b0*(e+1)+qq*A+qq*(qq-1)//2
    cI = sS+e*smax<=N and L+1>=qq and P<=qq*(L+1-qq) and V0+P<=N
    # case II
    sS=l*(l+3)//2; smax=l+1; A=sS+2*e; L=(l-1)*e
    P=(l-1)*(l+2)//2+2*e
    V0=(e+1)+qq*A+qq*(qq-1)//2
    cII = sS+e*smax<=N and L+1>=qq and P<=qq*(L+1-qq) and V0+P<=N
    return cI and cII
worst=0
for l in range(6,int(sys.argv[1])+1):
    e=2
    while not ok(l,e): e+=1
    assert all(ok(l,x) for x in range(e,e+4*l)), l
    worst=max(worst,e)
    if l<=12 or l%500==0: print(l,'j=1 chain closes for all e >=',e)
print('max over l of least e:',worst)
