"""T1-fill vs good colourings of [1,V-1] for ALL e>=1 (not only those beating F):
any instance with w <= V-1 would be a monochromatic solution in a good colouring -> logic error.
Also random (non-proof) parameter choices, with forced colours compared against the actual colouring."""
import sys, itertools, math, random
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import *
from t1fill import *
random.seed(11)
def minw(l,e,col):
    Mc,Mw,Dw=window_info(l,col); j=len(Dw); q=l-j; Dset=set(Dw); sD=sum(Dw)
    S1list=list(itertools.combinations(Mw,l)) if math.comb(len(Mw),l)<=40 else [Mw[:l]]
    best=None
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
                            if best is None or w<best: best=w
    return best
def random_params(l,e,col):
    Mc,Mw,Dw=window_info(l,col); j=len(Dw); q=l-j; Dset=set(Dw)
    out=[]
    for _ in range(30):
        S1=sorted(random.sample(Mw,l))
        trip=[(y,rp,d) for y in S1 for rp in S1 for d in S1 if d not in (y,rp) and y+rp-d in Dset]
        if not trip: continue
        y,rp,d=random.choice(trip); b=y+rp-d
        Rp=[x for x in S1 if x!=y]; uu=random.choice(Rp)
        r=random.choice([x for x in S1 if x!=rp])
        zs=random.sample([x for x in S1 if x not in (r,rp)],q-1)
        out.append(dict(S1=S1,y=y,rp=rp,d=d,u=uu,r=r,zs=zs,Mc=Mc,Dw=Dw,b=b))
    return out
stats=dict(tested=0,incons=0,chi=0,chibad=0,brute=0,notgood=0)
for l in range(6,27):
    for e in range(1,13):
        k=l+e
        for j in range(2,l-1):
            for kind in '34':
                col,V,m=threeblock(l,e,j) if kind=='3' else fourblock(l,e,j)
                if l<=9 and e<=4:
                    stats['brute']+=1
                    if not is_good(col,k,l): stats['notgood']+=1; print('family colouring NOT good',kind,l,e,j); continue
                Mc,Mw,Dw=window_info(l,col)
                if not (2<=len(Dw)<=l-2): continue
                mw=minw(l,e,col); stats['tested']+=1
                if mw<V: stats['incons']+=1; print('INCONSISTENT',kind,l,e,j,mw,V)
                for p in random_params(l,e,col):
                    b=p['b']; B3w=[x for x in p['Dw'] if x!=b]
                    # d_b: random element of B3 = (D_W minus b) + Zs; Zs index chosen after build -> only D_W part or 'Z'
                    choice=random.choice(B3w+['Z']*(1 if p['zs'] else 0))
                    if choice=='Z':
                        Sig0=sum(p['S1'])+(e-1)*p['u']; db=Sig0+p['zs'][0]
                    else: db=choice
                    o=build(l,e,col,p['S1'],p['y'],p['rp'],p['d'],p['u'],p['r'],p['zs'],db,p['Mc'],p['Dw'],N=10**18,chi=col)
                    stats['chi']+=1
                    flags=[o.get('early')]+list(o.get('res',(None,None)))
                    for fl in flags:
                        if fl and fl[0]=='CHI': stats['chibad']+=1; print('CHI mismatch',kind,l,e,j,fl,p)
                    if o.get('w') is not None and o['w']<V: print('instance w below V!',kind,l,e,j,o['w'],V)
    print(l,stats,flush=True)
print('FINAL',stats)
