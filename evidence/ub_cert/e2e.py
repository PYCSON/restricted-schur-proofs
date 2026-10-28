"""End-to-end numeric test: for given k and every a in [1,k], take the certificate for that case, evaluate its
vertices at (k,a), and solve the ACTUAL restricted problem (all weak triples among those integers, [1,a] red, a+1 blue)."""
import sys, json
from pysat.solvers import Solver
MONO=lambda m,k,a:{'1':1,'a':a,'k':k,'ak':a*k,'k^2':k*k,'ak^2':a*k*k,'k^3':k**3}[m]
def case(k,a):
    if a<=3: return f'uni_const{a}'
    if a>=k-2: return f'uni_top{k-a}'
    return 'bi_mid'
for k in map(int,sys.argv[1:]):
    res=[]
    for a in range(1,k+1):
        J=json.load(open(case(k,a)+'.json'))
        pts=sorted({sum(c*MONO(m,k,a) for c,m in zip(v,J['monomials'])) for v in J['vertices']})
        S=set(pts); idx={x:i for i,x in enumerate(pts)}; V=lambda x,c:3*idx[x]+c+1
        s=Solver(name='cadical153')
        for x in pts:
            s.add_clause([V(x,c) for c in range(3)])
            if x<=a: s.add_clause([V(x,0)])
            if x==a+1: s.add_clause([V(x,1)])
        for u in pts:
            for v in pts:
                if u!=v and (k-1)*u+v in S:
                    for c in range(3): s.add_clause([-V(u,c),-V(v,c),-V((k-1)*u+v,c)])
        res.append('U' if not s.solve() else 'S')
    print('k',k,''.join(res))
