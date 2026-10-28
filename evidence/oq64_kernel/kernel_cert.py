#!/usr/bin/env python3
"""Run the symbolic engine for (l,k0), then extract a minimal set of identities whose CNF is UNSAT,
and write a certificate:  cert_<l>_<k0>.json  (vertices, edges, region)  +  cert_<l>_<k0>.cnf  (DIMACS).
CNF: variable i+1 <-> vertex i is RED.  For each edge (ℓ summand vertices + w): clause 'not all red' and
'not all blue'.  Unit clause: vertex (1,0,0) is red (colour symmetry).
usage: kernel_cert.py l k0 [maxdepth] [max_nonconst_others]"""
import sys, json, time
from pysat.solvers import Solver
import symeng

l = int(sys.argv[1]); k0 = int(sys.argv[2])
md = int(sys.argv[3]) if len(sys.argv) > 3 else 14
mnc = int(sys.argv[4]) if len(sys.argv) > 4 and sys.argv[4] != '-' else None
t0 = time.time()
E, tree, dt = symeng.run(l, k0, maxdepth=md, max_nonconst_others=mnc)
print(f"engine: {'PROOF' if tree else 'NO PROOF'} nodes={E.nodes} time={dt:.1f}s", flush=True)
if not tree: sys.exit(1)
# all distinct edges
edges = []
seen = set()
for w, lst in E.edges.items():
    for (a, c, oth) in lst:
        key = (w, a, c, oth)
        if key in seen: continue
        seen.add(key); edges.append(key)
verts = {}
def vid(p):
    if p not in verts: verts[p] = len(verts)
    return verts[p]
vid((1, 0, 0))
for (w, a, c, oth) in edges:
    vid(a); vid(w)
    for m, o in oth: vid(o)
nv = len(verts)
sel0 = nv  # selector vars nv+1 .. nv+len(edges)
S = Solver(name='cadical195')
S.add_clause([vid((1, 0, 0)) + 1])
for i, (w, a, c, oth) in enumerate(edges):
    vs = [vid(a)] + [vid(o) for m, o in oth] + [vid(w)]
    s = sel0 + i + 1
    S.add_clause([-s] + [-(x+1) for x in vs])
    S.add_clause([-s] + [(x+1) for x in vs])
allsel = [sel0 + i + 1 for i in range(len(edges))]
assert not S.solve(assumptions=allsel), "CNF over all discovered edges is SAT?!"
core = set(S.get_core())
# greedy minimisation
keep = sorted(core)
changed = True
it = 0
while changed and it < 3:
    changed = False; it += 1
    for s in list(keep):
        if s not in keep: continue
        trial = [x for x in keep if x != s]
        if not S.solve(assumptions=trial):
            keep = sorted(set(S.get_core())); changed = True
print(f"edges discovered={len(edges)} minimal kernel edges={len(keep)}", flush=True)
kedges = [edges[s - sel0 - 1] for s in keep]
kv = {}
def kid(p):
    if p not in kv: kv[p] = len(kv)
    return kv[p]
kid((1, 0, 0))
for (w, a, c, oth) in kedges:
    kid(a); [kid(o) for m, o in oth]; kid(w)
cert = {'l': l, 'k0': k0, 'F': list(E.F),
        'description': 'vertices are polynomials c0+c1*k+c2*k^2; edge: w = (k-c)*a + sum m_i*o_i, region: all integers k>=k0',
        'vertices': [list(p) for p, i in sorted(kv.items(), key=lambda x: x[1])],
        'edges': [{'a': kv[a], 'c': c, 'others': [[m, kv[o]] for m, o in oth], 'w': kv[w]} for (w, a, c, oth) in kedges],
        'unit_red': kv[(1, 0, 0)]}
json.dump(cert, open(f'cert_{l}_{k0}.json', 'w'), indent=0)
with open(f'cert_{l}_{k0}.cnf', 'w') as f:
    f.write(f"p cnf {len(kv)} {2*len(kedges)+1}\n{kv[(1,0,0)]+1} 0\n")
    for e in cert['edges']:
        vs = [e['a']] + [o for m, o in e['others']] + [e['w']]
        f.write(' '.join(str(-(x+1)) for x in vs) + ' 0\n')
        f.write(' '.join(str(x+1) for x in vs) + ' 0\n')
print(f"wrote cert_{l}_{k0}.json/.cnf: vertices={len(kv)} edges={len(kedges)} total {time.time()-t0:.1f}s")
