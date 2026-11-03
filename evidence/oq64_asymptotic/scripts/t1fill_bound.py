#!/usr/bin/env python3
"""Worst-case-bound check of the T1-fill template (unbalanced windows, 2 <= j <= l-2).
w = SumR' + SumD_W + q*(SumS1 + (e-1)u) + Sum z_i + r + d + e*d_b + (e-1)u  must be <= N."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def wbound(l,j,e,caseI):
    q=l-j
    sumS1=l*j+l*(l+1)//2
    sumD=j*(4*l-j+1)//2
    u=1 if caseI else j+2
    sumz=sum(j+i+2 for i in range(1,q))      # c=q-1 smallest of S1 minus {r,r'} : <= m_{i+2} <= j+i+2
    r=j+3; d=l+j; db=2*l
    return sumS1+sumD+q*(sumS1+(e-1)*u)+sumz+r+d+e*db+(e-1)*u
def ok(l,e):
    N=F(l+e,l)
    return all(wbound(l,j,e,c)<=N for j in range(2,l-1) for c in (True,False))
def least(l):
    e=1
    while not ok(l,e): e+=1
    # monotone? check a window above
    assert all(ok(l,e2) for e2 in range(e,e+3*l))
    return e
def V3(l,e,j):
    m=l*(l+1)//2+l*j+e*(j+1)-1
    return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e
def eL(l):
    es=[e for e in range(1,l+1) if max(V3(l,e,j) for j in range(1,l))>F(l+e,l)]
    return max(es) if es else 0
for l in [int(x) for x in sys.argv[1:]]:
    eu=least(l); el=eL(l)
    print(f"l={l}: T1-fill closes j>=2 for e>={eu} (K<= {l+eu} modulo j<=1/balanced);  3-block good up to e={el} (K>= {l+el+1});  gap={eu-el-1}; eu/l={eu/l:.3f}",flush=True)
