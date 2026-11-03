#!/usr/bin/env python3
"""Finite part, l = 6..49: exact least e (worst-case bounds) for T1-fill (2<=j<=l-2) and the j=1 chain;
largest e for which a three-block colouring of [1,F] is good.  Upper bound K(l) <= l + max(eU, eJ1)."""
import sys, math
if not __debug__: raise SystemExit("refusing to run under python -O")
sys.argv=[sys.argv[0]]
exec(open('t1fill_bound.py').read().split("for l in [int(x)")[0])
src=open('j1_chain.py').read().split("worst=0")[0]; ns={}; exec(src,ns); okj1=ns['ok']
a=(math.sqrt(2)-1)/2
mxU=-99; mnL=99
for l in range(6,50):
    eU=1
    while not ok(l,eU): eU+=1
    assert all(ok(l,x) for x in range(eU,eU+4*l))
    eJ=2
    while not okj1(l,eJ): eJ+=1
    assert all(okj1(l,x) for x in range(eJ,eJ+4*l))
    el=max([e for e in range(1,l) if any(V3(l,e,j)-1>=F(l+e,l) for j in range(1,l))] or [0])
    up=l+max(eU,eJ); lo=l+el+1
    mxU=max(mxU,up-(1+math.sqrt(2))/2*l); 
    if el>0: mnL=min(mnL,lo-(1+math.sqrt(2))/2*l)
    print(f"l={l:2d} eU(T1-fill)={eU:2d} eJ1={eJ} => K<={up:3d} ;  3-block good up to e={el} => K>={lo:3d}   [(1+r2)/2*l={(1+math.sqrt(2))/2*l:6.2f}]")
print('max K_upper - (1+sqrt2)/2*l over l=6..49:',round(mxU,3),'  min K_lower - (1+sqrt2)/2*l (where e_L>=1):',round(mnL,3))
