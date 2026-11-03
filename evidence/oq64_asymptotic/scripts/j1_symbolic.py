#!/usr/bin/env python3
"""Symbolic all-l version of j1_chain.py: every condition, as a polynomial in u=l-L1>=0 and s=e-E1>=0,
has only nonnegative coefficients (sufficient for >= 0 on the whole region)."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
import sympy as sp
L1=int(sys.argv[1]); E1=int(sys.argv[2])
l,e,u,s=sp.symbols('l e u s')
N=(l+e)**2+((l+1)*(l-2)/2+2)*(l+e)+l*(l-2); qq=l-1
conds={}
sS=(l+1)*(l+2)/2-2; smax=l+1; A=sS+e+2; L=(e-1)*(l-1)-2; b0=2*l; P=(l-1)*(l+2)/2+e
V0=b0*(e+1)+qq*A+qq*(qq-1)/2
conds.update({'I_C2':N-(sS+e*smax),'I_Lq':L+1-qq,'I_C3':qq*(L+1-qq)-P,'I_C4':N-(V0+P)})
sS=l*(l+3)/2; A=sS+2*e; L=(l-1)*e; P=(l-1)*(l+2)/2+2*e
V0=(e+1)+qq*A+qq*(qq-1)/2
conds.update({'II_C2':N-(sS+e*smax),'II_Lq':L+1-qq,'II_C3':qq*(L+1-qq)-P,'II_C4':N-(V0+P)})
ok=True
for nm,G in conds.items():
    p=sp.Poly(sp.expand(G.subs({l:L1+u,e:E1+s})),u,s)
    neg=[c for c in p.coeffs() if c<0]
    print(nm,'PASS' if not neg else f'FAIL {neg}'); ok&=not neg
print('l >=',L1,'e >=',E1,'=>','ALL PASS' if ok else 'NOT ALL')
