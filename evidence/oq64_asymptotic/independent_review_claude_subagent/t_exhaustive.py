import sys, itertools
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F
from t1fill import *
def eU(l):
    e=1
    while not all(wbound(l,j,e,c)<=F(l+e,l) for j in range(2,l-1) for c in (True,False)): e+=1
    return e
for l in [int(a) for a in sys.argv[1:]]:
    nwin=0; maxratio=0; worst=None; nviol=0; ntrip=0
    E=eU(l); es=sorted(set([1,2,E-1,E,E+3]))
    es=[x for x in es if x>=1]
    refuted={e:0 for e in es}
    for bits in itertools.product('RB',repeat=2*l-1):
        col=[None,'R']+list(bits)
        Mc,Mw,Dw=window_info(l,col); j=len(Dw)
        if not (2<=j<=l-2): continue
        nwin+=1
        assert triples_exist(l,col), ('no triple',col)
        if Mc=='R': assert triples_exist(l,col,True), ('no triple with y!=1',col)
        for e in es:
            N=F(l+e,l); wb=wbound(l,j,e,Mc=='R'); bestw=None
            for p in proof_choices(l,e,col):
                o=build(l,e,col,p['S1'],p['y'],p['rp'],p['d'],p['u'],p['r'],p['zs'],p['db'],p['Mc'],p['Dw'])
                w=o['w']; ntrip+=1
                assert o['maxval']==w
                if w>wb: nviol+=1; print('BOUND VIOLATED',l,e,''.join(col[1:]),p,w,wb)
                if bestw is None or w<bestw: bestw=w
            if bestw is not None and bestw<=N: refuted[e]+=1
    print(f'l={l}: windows with 2<=j<=l-2: {nwin}; triple exists in all; instances checked {ntrip}; bound violations {nviol}; eU(bound)={E}; refuted counts per e: {refuted}',flush=True)
