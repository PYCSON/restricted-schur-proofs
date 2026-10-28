#!/usr/bin/env python3
"""Combine: W_j certificates for e=1..5 (k=l+1..l+5, files in wj_certs*), R-23 for every e where its two
conditions hold (checked e by e), and R-22 (Gaiser explicit, all colourings) for k>=K1. Which W_j windows,
11<=l<=23, are then excluded for EVERY k>=l+1?  CERT_E = set of e with a certificate for that (l,j)."""
import sys
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def r23(l,j,e):
    q=l-j;k=l+e;A=e+1+(l-1)*(2*j+l+2)//2;L=(l-1)*q
    V=j*(j+3)//2+q*A+q*(q-1)//2+2*e;P=e+1+(l-2)*(2*j+l+1)//2;H=q*((l-2)*q+1)
    assert A+L<=F(k,l)
    return P<=H and V+P<=F(k,l)
cert=eval(sys.argv[1]) if len(sys.argv)>1 else {}
full=0; gaps={}
for l in range(11,24):
    K1=(3*l*l-3*l+2)//2
    for j in range(1,l):
        ce=cert.get((l,j),set())
        miss=[e for e in range(1,K1-l) if e not in ce and not r23(l,j,e)]
        if not miss: full+=1
        else: gaps[(l,j)]=(miss[0],miss[-1],len(miss))
print('windows excluded for every k>=l+1:',full,'of 208')
for (l,j),(a,b,n) in sorted(gaps.items()): print(f'  l={l} j={j}: uncovered e in [{a},{b}] ({n} values)')
