#!/usr/bin/env python3
"""Cube certificate from engine edges.  Claim: with 1 red (colour 0) and integer j+2 coloured
prefix[j] for each j, no 2-colouring of [1,F(k,l)] avoids the edges, for all k>=k0.
Writes cert<TAG>_<l>_<k0>.json/.cnf (base, check_cert compatible) and .cube.cnf (base + prefix units).
usage: cubecert.py l k0 edges prefix TAG [rounds]"""
import sys, json, time
from pysat.solvers import Solver
l=int(sys.argv[1]); k0=int(sys.argv[2]); fn=sys.argv[3]; pre=sys.argv[4]; TAG=sys.argv[5]
rounds=int(sys.argv[6]) if len(sys.argv)>6 else 1
D=l*(l-1)//2; F=(l*l-2*l, D+1, 1); t0=time.time()
edges=[]; seen=set()
for line in open(fn):
    p=[x.strip() for x in line.split('|')]
    a=tuple(map(int,p[0].split())); c=int(p[1])
    oth=tuple((int(t.split(':')[0]), tuple(map(int,t.split(':')[1].split(',')))) for t in p[2].split())
    w=tuple(map(int,p[3].split())); key=(w,a,c,oth)
    if key in seen: continue
    seen.add(key); edges.append(key)
verts={}
def vid(q):
    if q not in verts: verts[q]=len(verts)
    return verts[q]
units=[((1,0,0),0)]+[((j+2,0,0),int(b)) for j,b in enumerate(pre)]
for q,_ in units: vid(q)
for (w,a,c,oth) in edges:
    vid(a); vid(w); [vid(o) for m,o in oth]
sel0=len(verts); S=Solver(name='cadical195')
for q,col in units: S.add_clause([(verts[q]+1)*(1 if col==0 else -1)])  # var true = colour 0
for i,(w,a,c,oth) in enumerate(edges):
    vs=[vid(a)]+[vid(o) for m,o in oth]+[vid(w)]; s=sel0+i+1
    S.add_clause([-s]+[-(x+1) for x in vs]); S.add_clause([-s]+[x+1 for x in vs])
allsel=[sel0+i+1 for i in range(len(edges))]
if S.solve(assumptions=allsel): print("SAT -- cube NOT closed by these edges"); sys.exit(2)
keep=sorted(set(S.get_core())); print(f"edges={len(edges)} core={len(keep)} ({time.time()-t0:.1f}s)",flush=True)
for r in range(rounds):
    ch=False
    for s in list(keep):
        if s not in keep: continue
        tr=[x for x in keep if x!=s]
        if not S.solve(assumptions=tr): keep=sorted(set(S.get_core())); ch=True
    print(f" round {r}: {len(keep)} ({time.time()-t0:.1f}s)",flush=True)
    if not ch: break
ke=[edges[s-sel0-1] for s in keep]; kv={}
def kid(q):
    if q not in kv: kv[q]=len(kv)
    return kv[q]
kid((1,0,0))
for (w,a,c,oth) in ke: kid(a); [kid(o) for m,o in oth]; kid(w)
cu=[(q,col) for q,col in units if q in kv]
cert={'l':l,'k0':k0,'F':list(F),'F_extra':0,'prefix':pre,'prefix_semantics':'integer j+2 has colour prefix[j]; 1 has colour 0; CNF var true = colour 0',
 'vertices':[list(q) for q,i in sorted(kv.items(),key=lambda x:x[1])],
 'edges':[{'a':kv[a],'c':c,'others':[[m,kv[o]] for m,o in oth],'w':kv[w]} for (w,a,c,oth) in ke],
 'unit_red':kv[(1,0,0)],'cube_units':[[kv[q],col] for q,col in cu]}
b=f'cert{TAG}_{l}_{k0}'; json.dump(cert,open(b+'.json','w'),indent=0)
L=[f"{kv[(1,0,0)]+1} 0"]
for e in cert['edges']:
    vs=[e['a']]+[o for m,o in e['others']]+[e['w']]
    L.append(' '.join(str(-(x+1)) for x in vs)+' 0'); L.append(' '.join(str(x+1) for x in vs)+' 0')
open(b+'.cnf','w').write(f"p cnf {len(kv)} {len(L)}\n"+'\n'.join(L)+'\n')
U=[f"{(v+1)*(1 if col==0 else -1)} 0" for v,col in cert['cube_units'] if v!=kv[(1,0,0)]]
open(b+'.cube.cnf','w').write(f"p cnf {len(kv)} {len(L)+len(U)}\n"+'\n'.join(L+U)+'\n')
print(f"wrote {b}: vertices={len(kv)} edges={len(ke)} prefix_units_used={len(U)} {time.time()-t0:.1f}s")
