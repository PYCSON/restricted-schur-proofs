"""THEORY_CASE1 Lemma 1/2 (balanced windows) and section 7a (parity window, k odd) -- independent checks."""
import sys, itertools, random
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F
from t1fill import build
random.seed(5)
def T1_instances(l,col,C):
    Cp='B' if C=='R' else 'R'
    W=range(1,2*l+1)
    Cw=[x for x in W if col[x]==C]; Pw=[x for x in W if col[x]==Cp]
    if len(Cw)<l or len(Pw)<l-1: return
    Pset=set(Pw)
    for S1 in itertools.combinations(Cw,l):
        for y in S1:
            for rp in S1:
                for d in S1:
                    if d in (y,rp): continue
                    b=y+rp-d
                    if b not in Pset: continue
                    for B3 in itertools.combinations([x for x in Pw if x!=b],l-2):
                        yield list(S1),y,rp,d,b,list(B3)
def worst_w(l,e,col):
    """max over all T1/T1' instances (u=min R', d_b=min B3, any r) of w; also count instances; verify few explicitly"""
    N=F(l+e,l); mx=None; cnt=0
    for C in 'RB':
        for S1,y,rp,d,b,B3 in T1_instances(l,col,C):
            Rp=[x for x in S1 if x!=y]; u=min(Rp); db=min(B3)
            for r in S1:
                if r==rp: continue
                w=sum(Rp)+sum(B3)+b+sum(S1)+2*(e-1)*u+r+d+e*db
                cnt+=1
                if mx is None or w>mx: mx=w; arg=(C,S1,y,rp,d,b,B3,u,r,db)
    if cnt:
        C,S1,y,rp,d,b,B3,u,r,db=arg
        o=build(l,e,col,S1,y,rp,d,u,r,[],db,C,B3+[b],N=N)
        assert o['res'][1] and o['res'][1][0]=='CLASH', o
    return mx,cnt
for l in (6,7):
    nwin=0; maxexcess=-10**9
    for bits in itertools.product('RB',repeat=2*l-1):
        col=[None,'R']+list(bits)
        nr=sum(1 for x in range(1,2*l+1) if col[x]=='R')
        if nr not in (l-1,l,l+1): continue
        if all(col[x]==('R' if x%2 else 'B') for x in range(1,2*l+1)): continue
        nwin+=1
        for e in (1,2,3,6):
            N=F(l+e,l); mx,cnt=worst_w(l,e,col)
            assert cnt>0,('no T1 or T1prime',''.join(col[1:]))
            bound=(7*l*l+5*l-12)/2+e*(3*l+7)
            assert mx<=bound,('Lemma2 bound violated',l,e,mx,bound)
            maxexcess=max(maxexcess,mx-N)
    print(f'balanced non-parity windows l={l}: {nwin}; T1/T1prime exists in all; worst w over ALL instances - N = {maxexcess} (<=0 required)',flush=True)
# section 7a: parity window, k odd
def parity_chain(l,e):
    k=l+e; N=F(k,l); assert k%2==1
    O=list(range(1,2*l,2)); E=list(range(2,2*l+1,2))
    m=1 if l in (6,7) else -(-(l-2*int((l-1)**0.5)) //2) if False else None
    import math
    if l in (6,7): m=1
    else:
        s=math.sqrt(l-1); m=math.ceil(l/2-s)
        # exact ceil of l/2 - sqrt(l-1)
        m=next(mm for mm in range(0,l) if 4*(l-1)>= (l-2*mm)**2 and (mm==0 or 4*(l-1)<(l-2*(mm-1))**2)) if False else m
    NA=e*(l-1)+1
    Avals=[l*l+e+2*i for i in range(NA)]
    G=E[-m:]; Gp=E[:m]
    r=(l-1)**2-e*(2*l-3)-2*m*(l-m)
    assert r%2==0
    if abs(r)>2*m*(NA-m): return ('span',l,e,m,r)
    # choose L, L' (m-subsets of A) with sum(L')-sum(L)=r
    def subset_sum(idx_sum):  # m indices in [0,NA) with given index-sum
        base=list(range(m)); need=idx_sum-sum(base)
        for i in range(m-1,-1,-1):
            room=(NA-1-(m-1-i))-base[i]; mv=min(room,need); base[i]+=mv; need-=mv
        assert need==0; return [Avals[t] for t in base]
    lo=m*(m-1)//2
    if r>=0: L=subset_sum(lo); Lp=subset_sum(lo+r//2)
    else: Lp=subset_sum(lo); L=subset_sum(lo+(-r)//2)
    assert sum(Lp)-sum(L)==r
    col={x:('R' if x%2 else 'B') for x in range(1,2*l+1)}
    forced={}
    def colour(x): return col[x] if x<=2*l else forced[x]
    def edge(ms,c):
        assert len(ms)==k and len(set(ms))==l
        for v in set(ms): assert colour(v)==c,(v,c)
        return sum(ms)
    # A values: red k-sums of O with e odd extras
    for a in set(L+Lp):
        sig=a-l*l; ext=[]; rem=sig
        for t in range(e):   # e odd numbers in [1,2l-1] summing to sig
            left=e-t-1; v=min(2*l-1, rem-left)
            if v%2==0: v-=1
            ext.append(v); rem-=v
        assert rem==0 and all(1<=v<=2*l-1 and v%2 for v in ext),(sig,ext)
        assert edge(O+ext,'R')==a and a<=N
        forced[a]='B'
    P=[x for x in E if x not in G]+L; Mv=edge(P+[2]*e,'B'); forced[Mv]='R'
    w=edge([x for x in O if x!=2*l-1]+[Mv]+[1]*e,'R')
    Pp=[x for x in E if x not in Gp]+Lp; wp=edge(Pp+[2*l]*e,'B')
    assert w==wp,(w,wp)
    if w>N: return ('w>N',l,e,m,w,N)
    return None
fails=[]; cnt=0
for l in range(6,161):
    for e in list(range(1,61))+[80,101,150,200]:
        if (l+e)%2==0: continue
        res=parity_chain(l,e); cnt+=1
        if res: fails.append(res)
print('parity k odd chains built and verified:',cnt,'failures:',fails[:10])
