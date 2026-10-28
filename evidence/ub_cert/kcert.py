#!/usr/bin/env python3
"""Build a symbolic-kernel certificate for one case of the S_3(k;2) <= F proof, minimise it, write files.
Cases: uni const:a | uni top:c   (region k>=K)     bi mid (region A0<=a<=k-B0)
Monomials (bi): 1,a,k,ak,k^2,ak^2,k^3 ; (uni): 1,k,k^2,k^3.
Edges: w=(k-1)u+v with u!=v (one equation family of x_1+..+x_k=x_{k+1} with 3 distinct values).
usage: kcert.py NAME uni K spec box   |   kcert.py NAME bi A0 B0 box"""
import sys, itertools, json, numpy as np, subprocess, hashlib
from math import comb
from pysat.solvers import Solver
name=sys.argv[1]; mode=sys.argv[2]
if mode=='uni':
    K=int(sys.argv[3]); spec=sys.argv[4]; b=[int(x) for x in sys.argv[5].split(',')]
    MON=['1','k','k^2','k^3']; F=np.array([-2,2,3,1])
    Tm=np.array([[comb(j,i)*K**(j-i) if i<=j else 0 for j in range(4)] for i in range(4)],dtype=np.int64)
    rng=[range(-b[0],b[0]+1),range(-b[1],b[1]+1),range(-b[2],b[2]+1),range(0,b[3]+1)]
    Mk=np.zeros((4,4),dtype=np.int64)
    for j in range(3): Mk[j+1,j]=1; Mk[j,j]=-1
    nomul=[3]
    kind,val=spec.split(':'); val=int(val)
    if kind=='const': A=np.array([val,0,0,0]); B=np.array([val+1,0,0,0])
    else: A=np.array([-val,1,0,0]); B=np.array([1-val,1,0,0])
    region={'mode':'uni','K':K,'case':spec}
else:
    A0,B0=int(sys.argv[3]),int(sys.argv[4]); b=[int(x) for x in sys.argv[5].split(',')]
    MON=['1','a','k','ak','k^2','ak^2','k^3']; F=np.array([-2,0,2,0,3,0,1])
    import sympy as sp
    s_,t_=sp.symbols('s t'); aa=A0+s_; kk=A0+B0+s_+t_
    mp=[sp.Poly(sp.expand(e),s_,t_) for e in [sp.Integer(1),aa,kk,aa*kk,kk**2,aa*kk**2,kk**3]]
    allm=sorted(set(m for p in mp for m in p.monoms()))
    Tm=np.zeros((len(allm),7),dtype=np.int64)
    for j,p in enumerate(mp):
        for mon,c in zip(p.monoms(),p.coeffs()): Tm[allm.index(mon),j]=int(c)
    Tm=Tm[[allm.index((0,0))]+[i for i in range(len(allm)) if allm[i]!=(0,0)]]  # constant row first
    rng=[range(-b[0],b[0]+1),range(-b[1],b[1]+1),range(-b[2],b[2]+1),range(0,b[3]+1),range(0,b[4]+1),range(0,b[5]+1),range(0,b[6]+1)]
    Mk=np.zeros((7,7),dtype=np.int64)
    for (dst,src) in [(2,0),(3,1),(4,2),(5,3),(6,4)]: Mk[dst,src]=1; Mk[src,src]=-1
    nomul=[5,6]
    A=np.array([0,1,0,0,0,0,0]); B=np.array([1,1,0,0,0,0,0])
    region={'mode':'bi','A0':A0,'B0':B0,'case':'mid'}
D=len(MON)
nonneg=lambda P:(Tm@P>=0).all()
pos=lambda P:(lambda c:(c>=0).all() and c[0]>0)(Tm@P)
one=np.zeros(D,dtype=np.int64); one[0]=1
pts=[np.array(c,dtype=np.int64) for c in itertools.product(*rng)]
pts=[P for P in pts if nonneg(P-one) and nonneg(F-P)]
P=np.array(pts); n=len(P)
off=64; rad=128
enc=lambda X: ((X+off)*(rad**np.arange(D))).sum(axis=-1)
codes={int(c):i for i,c in enumerate(enc(P))}
okmul=np.all(P[:,nomul]==0,axis=1); KU=P@Mk.T
edges=set()
for iu in np.nonzero(okmul)[0]:
    W=KU[iu][None,:]+P; assert np.abs(W).max()<off
    cw=enc(W)
    for iv in range(n):
        j=codes.get(int(cw[iv]))
        if j is None or iv==iu: continue
        d=P[iu]-P[iv]
        if not (pos(d) or pos(-d)): continue
        edges.add((int(iu),iv,j))     # ordered: (u,v,w)
red=[x for x in range(n) if nonneg(A-P[x])]
blue=codes[int(enc(B))]
# minimise vertex set
Vv=lambda x,c:3*x+c+1; act=lambda x:3*n+x+1
S=Solver(name='cadical153')
for x in range(n): S.add_clause([-act(x)]+[Vv(x,c) for c in range(3)])
for (u,v,w) in edges:
    for c in range(3): S.add_clause([-Vv(u,c),-Vv(v,c),-Vv(w,c)])
for x in red: S.add_clause([-act(x),Vv(x,0)])
S.add_clause([-act(blue),Vv(blue,1)])
keep=set(range(n))
assert not S.solve(assumptions=[act(x) for x in keep])
keep={l-3*n-1 for l in S.get_core() if l>3*n}
for x in sorted(keep,reverse=True):
    if x not in keep: continue
    t=keep-{x}
    if not S.solve(assumptions=[act(y) for y in t]): keep={l-3*n-1 for l in S.get_core() if l>3*n}
keep=sorted(keep); ren={x:i for i,x in enumerate(keep)}
E=[(ren[u],ren[v],ren[w]) for (u,v,w) in edges if u in ren and v in ren and w in ren]
R=[ren[x] for x in red if x in ren]; Bl=[ren[blue]] if blue in ren else []
verts=[[int(c) for c in P[x]] for x in keep]
cl=[]
for i in range(len(keep)): cl.append([Vv(i,c) for c in range(3)])
for (u,v,w) in E:
    for c in range(3): cl.append([-Vv(u,c),-Vv(v,c),-Vv(w,c)])
for i in R: cl.append([Vv(i,0)])
for i in Bl: cl.append([Vv(i,1)])
cnf=f"p cnf {3*len(keep)} {len(cl)}\n"+"".join(" ".join(map(str,c))+" 0\n" for c in cl)
open(f"cert/{name}.cnf","w").write(cnf)
json.dump({'name':name,'region':region,'monomials':MON,'F':[int(x) for x in F],'vertices':verts,'edges':E,'red':R,'blue':Bl,
           'cnf_sha256':hashlib.sha256(cnf.encode()).hexdigest(),
           'var_convention':'colour c of vertex i is variable 3*i+c+1; c=0 red, 1 blue, 2 green'},open(f"cert/{name}.json","w"),indent=0)
CAD='/tmp/claude-0/-home-claude/e4d196b7-05e8-510e-8550-4ec4df7c279d/scratchpad/tools/cadical/build/cadical'
LC='/tmp/claude-0/-home-claude/e4d196b7-05e8-510e-8550-4ec4df7c279d/scratchpad/tools/drat-trim/lrat-check'
out=subprocess.run([CAD,'-q',f'cert/{name}.cnf',f'cert/{name}.lrat','--lrat=true','--binary=false'],capture_output=True,text=True).stdout
res=[l for l in out.split('\n') if l.startswith('s ')]
chk=subprocess.run([LC,f'cert/{name}.cnf',f'cert/{name}.lrat'],capture_output=True,text=True).stdout
print(name,region,'pool',n,'core vertices',len(keep),'edges',len(E),'red',len(R),'blue',len(Bl),res,'lrat-check:',[l for l in chk.split('\n') if 'VERIFIED' in l or 'FAIL' in l.upper()][:2],flush=True)
