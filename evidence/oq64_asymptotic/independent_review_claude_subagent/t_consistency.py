import sys, itertools, math
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import *
from t1fill import *
def V3f(l,e,j):
    m=l*(l+1)//2+l*j+e*(j+1)-1
    return j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e
def V4f(l,e,j):
    m=e+(l-1)*j+l*(l+1)//2-1
    return j*(j+3)//2+(l-j)*m+(l-j)*(l-j+1)//2+2*e
def minw_broad(l,e,col,S1list):
    """exact min of w over: S1 in S1list, all triples, all u in R', all r in S1 minus r, z = smallest q-1
    of S1\{r,r'} (w increasing in sum z), d_b = min(D_W\{b}) (w increasing in d_b)."""
    Mc,Mw,Dw=window_info(l,col); j=len(Dw); q=l-j; Dset=set(Dw); sD=sum(Dw)
    best=None; arg=None
    for S1 in S1list:
        sS=sum(S1)
        for y in S1:
            Rp=[x for x in S1 if x!=y]
            for rp in S1:
                for d in S1:
                    if d in (y,rp): continue
                    b=y+rp-d
                    if b not in Dset: continue
                    db=min(x for x in Dw if x!=b)
                    for uu in Rp:
                        for r in S1:
                            if r==rp: continue
                            zs=[x for x in S1 if x not in (r,rp)][:q-1]
                            w=(sS-y)+sD+q*(sS+(e-1)*uu)+sum(zs)+r+d+e*db+(e-1)*uu
                            if best is None or w<best: best=w; arg=dict(S1=list(S1),y=y,rp=rp,d=d,u=uu,r=r,zs=zs,db=db,Mc=Mc,Dw=Dw)
    return best,arg
tested=0; incons=0; chi_checked=0; chi_bad=0
def run(l,e,j,kind,brute):
    global tested,incons,chi_checked,chi_bad
    k=l+e; N=F(k,l)
    if kind=='3': col,V,m=threeblock(l,e,j)
    else: col,V,m=fourblock(l,e,j)
    if V-1<N: return None
    if brute:
        g=is_good(col,k,l); assert g,('claimed-good colouring not good',kind,l,e,j)
    Mc,Mw,Dw=window_info(l,col)
    if not (2<=len(Dw)<=l-2): return None
    q=l-len(Dw)
    if math.comb(len(Mw),l)<=60: S1list=list(itertools.combinations(Mw,l))
    else: S1list=[Mw[:l]]
    mw,arg=minw_broad(l,e,col,S1list); tested+=1
    if mw<V: incons+=1; print('INCONSISTENT (w <= V-1 in a good colouring!)',kind,l,e,j,mw,V,arg)
    # chi check on the proof's choices: every forced value below V must match chi
    for p in proof_choices(l,e,col):
        o=build(l,e,col,p['S1'],p['y'],p['rp'],p['d'],p['u'],p['r'],p['zs'],p['db'],p['Mc'],p['Dw'],N=10**18,chi=col)
        chi_checked+=1
        if 'early' in o and o['early'][0]=='CHI': chi_bad+=1; print('CHI mismatch',kind,l,e,j,o['early'])
        if 'res' in o and any(rr and rr[0]=='CHI' for rr in o['res']): chi_bad+=1; print('CHI mismatch w',kind,l,e,j,o['res'])
    return mw-N, mw-V
# small l with brute-force goodness confirmation (all e where good, every j)
for l in range(6,15):
    for e in range(1,l):
        for j in range(2,l-1):
            for kind in '34':
                run(l,e,j,kind,brute=True)
print('small l done: tested',tested,'inconsistent',incons,'chi checks',chi_checked,'chi mismatches',chi_bad,flush=True)
# l=19,20 instances with brute force
for (l,e,j) in [(19,1,5),(20,1,5),(20,1,4),(20,1,6)]:
    r=run(l,e,j,'3',brute=True); print('instance',l,e,j,'(minw-N, minw-V)=',r,flush=True)
# larger l without brute force (goodness of the families is elementary)
for l in list(range(15,61))+[80,100]:
    for e in range(1,l):
        for j in range(2,l-1):
            for kind in '34':
                run(l,e,j,kind,brute=False)
print('ALL: tested',tested,'inconsistent',incons,'chi checks',chi_checked,'chi mismatches',chi_bad)
