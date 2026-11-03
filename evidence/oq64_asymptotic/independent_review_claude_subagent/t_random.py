import sys, random
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F
from t1fill import *
random.seed(2026)
def eU(l):
    e=1
    while not all(wbound(l,j,e,c)<=F(l+e,l) for j in range(2,l-1) for c in (True,False)): e+=1
    return e
for l in list(range(9,15))+[20,30]:
    E=eU(l); tot=0; viol=0; notref=0; inst=0
    for trial in range(300 if l<20 else 80):
        # bias towards a spread of j
        j=random.randint(2,l-2); Mred=random.random()<0.5
        if Mred:
            Dpos=random.sample(range(2,2*l+1),j); col=[None]+['B' if x in Dpos else 'R' for x in range(1,2*l+1)]
        else:
            Dpos=[1]+random.sample(range(2,2*l+1),j-1); col=[None]+['R' if x in Dpos else 'B' for x in range(1,2*l+1)]
        Mc,Mw,Dw=window_info(l,col); assert len(Dw)==j
        assert triples_exist(l,col)
        for e in (E-1,E,E+2):
            N=F(l+e,l); wb=wbound(l,j,e,Mc=='R'); best=None
            for p in proof_choices(l,e,col):
                o=build(l,e,col,p['S1'],p['y'],p['rp'],p['d'],p['u'],p['r'],p['zs'],p['db'],p['Mc'],p['Dw'],N=10**18)
                inst+=1
                if o['w']>wb: viol+=1
                best=o['w'] if best is None else min(best,o['w'])
                assert o['res'][1] and o['res'][1][0]=='CLASH'
            if e>=E and best>N: notref+=1
        tot+=1
    print(f'l={l} eU={E}: random windows {tot}, instances {inst}, bound violations {viol}, windows NOT refuted at e>=eU: {notref}',flush=True)
