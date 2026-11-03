#!/usr/bin/env python3
"""Consistency test for T1-fill: for windows of KNOWN good colourings (three-block and R-19 four-block)
at every e where the colouring of [1,F] is good, the minimum of w over ALL T1-fill parameter choices
(y, r', d in S1 = l smallest of M, b in D) must exceed N.  Exact minimisation (no heuristics).
Also reports, for the three-block windows, the first e at which T1-fill does refute them."""
import sys
if not __debug__: raise SystemExit("refusing to run under python -O")
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def min_w(l,e,col):
    W=range(1,2*l+1)
    R=[x for x in W if col[x]=='R']; B=[x for x in W if col[x]=='B']
    if len(R)>=l+2: Mw,Dw=R,B
    elif len(B)>=l+2: Mw,Dw=B,R
    else: return None
    j=len(Dw); q=l-j
    if not 2<=j<=l-2: return None
    S1=Mw[:l]; S1set=set(S1); Dset=set(Dw); sS=sum(S1); sD=sum(Dw)
    m1,m2=S1[0],S1[1]
    zsum={}; rval={}
    for rp in S1:
        r=m1 if rp!=m1 else m2; rval[rp]=r
        zsum[rp]=sum([x for x in S1 if x not in (r,rp)][:q-1])
    dbv={b:min(x for x in Dw if x!=b) for b in Dw}
    best=None
    for y in S1:
        u=m1 if y!=m1 else m2
        base=sS-y+sD+q*(sS+(e-1)*u)+(e-1)*u
        for rp in S1:
            t=base+zsum[rp]+rval[rp]
            for d in S1:
                if d==y or d==rp: continue
                b=y+rp-d
                if b in Dset:
                    w=t+d+e*dbv[b]
                    if best is None or w<best: best=w
    return best
def V3(l,e,j):
    m=l*(l+1)//2+l*j+e*(j+1)-1
    return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e
def V4(l,e,j):
    m=e+(l-1)*j+l*(l+1)//2-1
    return j*(j+3)//2+(l-j)*m+(l-j)*(l-j+1)//2+2*e
incons=0; tested=0
for l in list(range(19,61))+[80,100,150]:
    for e in range(1,l):
        N=F(l+e,l); any_good=False
        for j in range(2,l-1):
            for kind in ('3','4'):
                V=V3(l,e,j) if kind=='3' else V4(l,e,j)
                if V-1<N: continue
                any_good=True
                col=[None]+(['R' if x<=j else 'B' for x in range(1,2*l+1)] if kind=='3' else ['R' if (x==1 or x>=j+2) else 'B' for x in range(1,2*l+1)])
                mw=min_w(l,e,col); tested+=1
                if mw is not None and mw<=N:
                    incons+=1; print('INCONSISTENT',kind,l,e,j,mw,N,flush=True)
        if not any_good: break
    # first e where T1-fill refutes all 3-block windows
    eT=None
    for e in range(1,l):
        N=F(l+e,l)
        if all((lambda mw: mw is not None and mw<=N)(min_w(l,e,[None]+['R' if x<=j else 'B' for x in range(1,2*l+1)])) for j in range(2,l-1)):
            eT=e; break
    eL=max([e for e in range(1,l) if any(V3(l,e,j)-1>=F(l+e,l) for j in range(1,l))] or [0])
    print(f'l={l}: good 3-block up to e={eL}; T1-fill (exact min over parameters) refutes every 3-block window from e={eT}',flush=True)
print('tested good windows:',tested,' inconsistencies:',incons)
