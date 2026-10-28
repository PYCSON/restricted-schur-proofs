#!/usr/bin/env python3
"""Z1: for which W_j windows (l=11..23) does the R-23 two-stage lemma hold for EVERY e with l+e < K1(l)?
Brute force over e (no monotonicity assumption). K1=(3l^2-3l+2)/2 is the explicit Gaiser threshold (CLAIMS R-22)."""
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def cond(l,j,e):
    q=l-j;k=l+e;A=e+1+(l-1)*(2*j+l+2)//2;L=(l-1)*q
    V=j*(j+3)//2+q*A+q*(q-1)//2+2*e;P=e+1+(l-2)*(2*j+l+1)//2;H=q*((l-2)*q+1)
    assert A+L<=F(k,l)
    return P<=H and V+P<=F(k,l)
tot=allok=0
for l in range(11,24):
    K1=(3*l*l-3*l+2)//2
    full=[];part=[]
    for j in range(1,l):
        if not cond(l,j,1): continue
        tot+=1
        bad=next((e for e in range(1,K1-l) if not cond(l,j,e)),None)
        if bad is None: allok+=1; full.append(j)
        else: part.append((j,bad))
    print(f"l={l} K1={K1}: all k in [l+1,K1-1] covered for j={full}; partial (j, first failing e)={part}")
print(f"R-23 windows at e=1: {tot}; covered for every k>=l+1 (with R-22 for k>=K1): {allok}")
