#!/usr/bin/env python3
"""Coverage of W_j windows for every k>=l+1 using
 (i) certificates for the listed (l,j,e)  (argv[1]: dict {(l,j): set of e}),
 (ii) R-23' (R-23 with the e extra blue copies spread over the small blues [2,j+1]):
      P_e <= H + e(j-1)  and  V_e + P_e <= F(l+e,l)   [R-23 is the special case without e(j-1)],
 (iii) R-22 for k >= K1 = (3l^2-3l+2)/2,
 (iv) balanced windows j=l-1 (T1, THEORY_CASE1 Lemmas 1-2, all e).
Every e is checked individually (no monotonicity assumed)."""
import sys
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def r23p(l,j,e):
    q=l-j;k=l+e;A=e+1+(l-1)*(2*j+l+2)//2;L=(l-1)*q
    V=j*(j+3)//2+q*A+q*(q-1)//2+2*e;P=e+1+(l-2)*(2*j+l+1)//2;H=q*((l-2)*q+1)
    assert A+L<=F(k,l) and L+1>=q
    return P<=H+e*(j-1) and V+P<=F(k,l)
cert=eval(sys.argv[1]) if len(sys.argv)>1 else {}
full=0; gaps={}
for l in range(11,24):
    K1=(3*l*l-3*l+2)//2
    for j in range(1,l):
        if j==l-1: full+=1; continue
        ce=cert.get((l,j),set())
        miss=[e for e in range(1,K1-l) if e not in ce and not r23p(l,j,e)]
        if not miss: full+=1
        else: gaps[(l,j)]=miss
print('windows excluded for every k>=l+1:',full,'of 208')
for (l,j),m in sorted(gaps.items()): print(f'  l={l} j={j}: uncovered e = {m}')
