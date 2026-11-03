#!/usr/bin/env python3
"""T1-fill template on an actual window, with explicit hyperedges verified by exact arithmetic.
Window: colour list col[1..2l] ('R'/'B'), col[1]='R'.  M = majority colour (>= l+2 in W),
D = minority with 2 <= j <= l-2.  Returns the least w over the parameter choices tried, and if
w <= N an explicit refutation (all hyperedges re-checked)."""
import sys, random
if not __debug__: raise SystemExit("refusing to run under python -O")
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def other(c): return 'B' if c=='R' else 'R'
def best_w(l,e,col):
    W=range(1,2*l+1)
    R=[x for x in W if col[x]=='R']; B=[x for x in W if col[x]=='B']
    Mc='R' if len(R)>=l+2 else ('B' if len(B)>=l+2 else None)
    if Mc is None: return None
    Mw=R if Mc=='R' else B; Dw=B if Mc=='R' else R; j=len(Dw); q=l-j
    if not (2<=j<=l-2): return None
    S1=Mw[:l]; S1set=set(S1); Dset=set(Dw)
    best=None
    for y in S1:
        for rp in S1:
            for d in S1:
                if d==y or d==rp: continue
                b=y+rp-d
                if b not in Dset: continue
                Rp=[x for x in S1 if x!=y]; u=min(Rp)
                r=min(x for x in S1 if x!=rp)
                zs=[x for x in S1 if x not in (r,rp)][:q-1]
                B3w=[x for x in Dw if x!=b]; db=min(B3w)
                k=l+e
                Sig0=sum(S1)+(e-1)*u
                w=sum(Rp)+sum(Dw)+q*Sig0+sum(zs)+r+d+e*db+(e-1)*u
                cand=(w,dict(y=y,rp=rp,d=d,b=b,u=u,r=r,zs=zs,db=db,S1=S1,Rp=Rp,B3w=B3w,Mc=Mc))
                if best is None or cand[0]<best[0]: best=cand
    return best
def verify(l,e,col,par,chi=None):
    """Build and check every hyperedge.  colour(x): window colour if x<=2l, else forced colour.
    If chi (a full colouring) is given, also report whether chi agrees with each forced colour."""
    k=l+e; N=F(k,l); Mc=par['Mc']; Dc=other(Mc)
    forced={}
    def colour(x):
        if x<=2*l: return col[x]
        return forced[x]
    def edge(multiset,expect_colour):
        vals=set(multiset)
        assert len(multiset)==k, "k summands"
        assert len(vals)==l, "exactly l distinct"
        for v in vals: assert colour(v)==expect_colour, ("summand colour",v)
        s=sum(multiset); assert s>max(vals) and s<=N, ("sum range",s,N)
        return s
    def force(x,c):
        if x<=2*l:
            assert col[x]==c, ("window clash",x)      # would itself be a contradiction
        if x in forced and forced[x]!=c: return ('CLASH',x)
        forced[x]=c
        if chi is not None and x<len(chi) and chi[x]!=c: return ('CHI-DISAGREES',x)
        return None
    S1=par['S1']; u=par['u']; r=par['r']; rp=par['rp']; y=par['y']; d=par['d']; b=par['b']
    base=list(S1)+[u]*(e-1)
    L1=edge(base+[r],Mc); L2=edge(base+[rp],Mc)
    Zs=[edge(base+[z],Mc) for z in par['zs']]
    for x in [L1,L2]+Zs:
        res=force(x,Dc)
        if res: return res
    B3=par['B3w']+Zs; db=par['db']; assert db in B3
    Mv=edge(B3+[b,L1]+[db]*e,Dc); res=force(Mv,Mc)
    if res: return res
    Rp=par['Rp']; assert u in Rp and d in Rp
    w=edge(Rp+[Mv]+[u]*(e-1)+[d],Mc)
    wp=edge(B3+[L1,L2]+[db]*e,Dc)
    assert w==wp, ("identity",w,wp)
    r1=force(w,Dc)
    if r1: return r1
    r2=force(wp,Mc)
    return r2   # expected ('CLASH', w)
if __name__=='__main__':
    l=int(sys.argv[1]); e=int(sys.argv[2]); trials=int(sys.argv[3]); random.seed(int(sys.argv[4]) if len(sys.argv)>4 else 1)
    k=l+e; N=F(k,l); closed=0; tot=0
    while tot<trials:
        col=[None,'R']+[random.choice('RB') for _ in range(2*l-1)]
        bw=best_w(l,e,col)
        if bw is None: continue
        tot+=1
        if bw[0]<=N:
            res=verify(l,e,col,bw[1]); assert res and res[0]=='CLASH', res; closed+=1
    print(f"l={l} e={e} random unbalanced windows (2<=j<=l-2): {closed}/{tot} refuted by T1-fill with verified hyperedges")
