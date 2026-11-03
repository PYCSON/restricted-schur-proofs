"""Explicit j=1 chains (section 4) on every j=1 window, exact values, every hyperedge verified."""
import sys
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F, threeblock, fourblock

_cache={}
def efold_rep(S, e, target):
    """multiset of e elements of S summing to target (DP), or None"""
    S=sorted(S); key=(tuple(S),e)
    if key in _cache: return _cache[key].get(target)
    reach={0:[]}
    for _ in range(e):
        nr={}
        for s,ms in reach.items():
            for x in S:
                if s+x not in nr: nr[s+x]=ms+[x]
        reach=nr
    _cache[key]=reach
    return reach.get(target)

def subset_with_sum(lo, hi, cnt, target):
    """cnt distinct integers in [lo,hi] with given sum, or None"""
    base=list(range(lo,lo+cnt))
    if hi-lo+1<cnt: return None
    s=sum(base); need=target-s
    if need<0: return None
    # shift top elements up as far as possible, greedily
    for i in range(cnt-1,-1,-1):
        room=(hi-(cnt-1-i))-base[i]
        mv=min(room,need); base[i]+=mv; need-=mv
    return base if need==0 else None

def chain(l, e, col, N, chi=None):
    k=l+e
    W=range(1,2*l+1)
    R=[x for x in W if col[x]=='R']; B=[x for x in W if col[x]=='B']
    if len(B)==1: Mc,Dc,b0='R','B',B[0]
    elif len(R)==1: Mc,Dc,b0='B','R',R[0]; assert b0==1
    else: raise ValueError
    forced={}
    def colour(x):
        return col[x] if x<=2*l else forced[x]
    def edge(ms,c):
        assert len(ms)==k and len(set(ms))==l, ('edge shape',len(ms),len(set(ms)))
        for v in set(ms): assert colour(v)==c, ('colour',v,colour(v),c)
        return sum(ms)
    def force(x,c,tag):
        if x>N: return ('>N',tag,x)
        if x<=2*l:
            return ('window', tag, x) if col[x]!=c else None
        if x in forced and forced[x]!=c: return ('CLASH',x)
        forced[x]=c
        if chi is not None and x<len(chi) and chi[x]!=c: return ('CHI',tag,x)
        return None
    if Mc=='B':   # case II
        S=list(range(2,l+2)); lo=sum(S)+2*e; hi=sum(S)+(l+1)*e
        T=list(range(2,l+1)); textra=2
    else:
        if b0>l: S=list(range(1,l+1)); lo=sum(S)+e; hi=sum(S)+e*l
        else:
            S=[x for x in range(1,l+2) if x!=b0]
            lo=sum(S)+e+2; hi=sum(S)+e+(e-1)*(l-1)
        T=sorted(x for x in W if col[x]==Mc)[:l-1]; textra=1
        assert 1 in T
    assert all(col[x]==Mc for x in S) and len(S)==l
    if hi-lo+1<l-1: return ('I1 too short',hi-lo+1)
    # step 1: every v in [lo,hi] as explicit k-sum of S
    for v in range(lo,hi+1):
        rep=efold_rep(S,e,v-sum(S))
        if rep is None: return ('step1 gap',v)
        s=edge(S+rep,Mc); assert s==v
        res=force(v,Dc,'I1')
        if res: return res
    # step 2: {b0} ∪ (l-1 values of I1), b0 extra e times
    X=list(range(lo,lo+l-1)); x0=edge([b0]+X+[b0]*e,Dc)
    res=force(x0,Mc,'x0')
    if res: return res
    P=sum(T)+textra*e
    Y=subset_with_sum(lo,hi,l-1,x0+P-b0*(e+1))
    if Y is None: return ('step2 range too short',P)
    y0=edge([b0]+Y+[b0]*e,Dc); assert y0==x0+P
    res=force(y0,Mc,'y0')
    if res: return res
    # step 3: T ∪ {x0}, textra extra e times
    assert textra in T
    z=edge(T+[x0]+[textra]*e,Mc); assert z==y0
    res=force(z,Dc,'z')
    return res   # expect ('CLASH', y0)

if __name__=='__main__':
    # (1) every j=1 window, l=6..40, e=eJ1..eJ1+? : chain must close with CLASH
    tot=0; fails=[]
    for l in range(6,41):
        wins=[]
        wins.append([None,'R']+['B']*(2*l-1))               # case II
        for b0 in range(2,2*l+1):
            wins.append([None]+['B' if x==b0 else 'R' for x in range(1,2*l+1)])
        emin=3 if l>=7 else 4
        for e in list(range(emin,emin+5))+[20]:
            N=F(l+e,l)
            for col in wins:
                r=chain(l,e,col,N); tot+=1
                if not (r and r[0]=='CLASH'): fails.append((l,e,''.join(col[1:]),r))
    print('j=1 windows tested',tot,'failures',len(fails),fails[:5])
    # (2) e=2 and l=6,e=3: claimed NOT covered; report what happens
    for (l,e) in [(6,2),(6,3),(7,2),(10,2),(30,2)]:
        N=F(l+e,l); out=[]
        for b0 in [1]+list(range(2,2*l+1)):
            col=[None,'R']+['B']*(2*l-1) if b0==1 else [None]+['B' if x==b0 else 'R' for x in range(1,2*l+1)]
            out.append(chain(l,e,col,N))
        print(f'l={l} e={e}: closes on {sum(1 for o in out if o and o[0]=="CLASH")}/{len(out)} j=1 windows')
    # (3) consistency: j=1 windows of KNOWN good colourings (three-block j=1 -> case II; four-block j=1 -> case I b0=2)
    for l in range(6,61):
        for e in range(1,l):
            N=F(l+e,l)
            for kind in '34':
                col,V,m=threeblock(l,e,1) if kind=='3' else fourblock(l,e,1)
                if V-1<N: continue
                win=col[:2*l+1]
                r=chain(l,e,win,10**18,chi=col)
                # with N=inf, chain values; contradiction must not occur below V
                if r and r[0]=='CLASH' and r[1]<V: print('INCONSISTENT j=1',kind,l,e,r,V)
                if r and r[0]=='CHI': print('CHI mismatch j=1',kind,l,e,r)
    print('j=1 consistency done')
