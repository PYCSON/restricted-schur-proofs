#!/usr/bin/env python3
"""Build a minimal kernel certificate from the C++ engine's edge file.
line format:  a0 a1 a2 | c | m:o0,o1,o2 ... | w0 w1 w2
usage: cert_from_edges.py l k0 edges.txt [minimise_rounds]"""
import sys, json, time
from pysat.solvers import Solver
l = int(sys.argv[1]); k0 = int(sys.argv[2]); fn = sys.argv[3]
rounds = int(sys.argv[4]) if len(sys.argv) > 4 else 2
FX = int(sys.argv[5]) if len(sys.argv) > 5 else 0
TAG = sys.argv[6] if len(sys.argv) > 6 else ''
D = l*(l-1)//2; F = (l*l-2*l+FX, D+1, 1)
t0 = time.time()
edges = []; seen = set()
for line in open(fn):
    parts = [p.strip() for p in line.split('|')]
    a = tuple(map(int, parts[0].split())); c = int(parts[1])
    oth = []
    for tok in parts[2].split():
        m, o = tok.split(':'); oth.append((int(m), tuple(map(int, o.split(',')))))
    w = tuple(map(int, parts[3].split()))
    key = (w, a, c, tuple(oth))
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
nv = len(verts); sel0 = nv
S = Solver(name='cadical195')
S.add_clause([vid((1, 0, 0)) + 1])
for i, (w, a, c, oth) in enumerate(edges):
    vs = [vid(a)] + [vid(o) for m, o in oth] + [vid(w)]
    s = sel0 + i + 1
    S.add_clause([-s] + [-(x+1) for x in vs]); S.add_clause([-s] + [(x+1) for x in vs])
allsel = [sel0 + i + 1 for i in range(len(edges))]
assert not S.solve(assumptions=allsel), "CNF over all edges is SAT?!"
keep = sorted(set(S.get_core()))
print(f"edges={len(edges)} first core={len(keep)} ({time.time()-t0:.1f}s)", flush=True)
for r in range(rounds):
    changed = False
    for s in list(keep):
        if s not in keep: continue
        trial = [x for x in keep if x != s]
        if not S.solve(assumptions=trial):
            keep = sorted(set(S.get_core())); changed = True
    print(f" round {r}: kernel edges={len(keep)} ({time.time()-t0:.1f}s)", flush=True)
    if not changed: break
kedges = [edges[s - sel0 - 1] for s in keep]
kv = {}
def kid(p):
    if p not in kv: kv[p] = len(kv)
    return kv[p]
kid((1, 0, 0))
for (w, a, c, oth) in kedges:
    kid(a); [kid(o) for m, o in oth]; kid(w)
cert = {'l': l, 'k0': k0, 'F': list(F), 'F_extra': FX,
        'description': 'vertices are polynomials c0+c1*k+c2*k^2; edge: w = (k-c)*a + sum m_i*o_i, region: all integers k>=k0',
        'vertices': [list(p) for p, i in sorted(kv.items(), key=lambda x: x[1])],
        'edges': [{'a': kv[a], 'c': c, 'others': [[m, kv[o]] for m, o in oth], 'w': kv[w]} for (w, a, c, oth) in kedges],
        'unit_red': kv[(1, 0, 0)]}
json.dump(cert, open(f'cert{TAG}_{l}_{k0}.json', 'w'), indent=0)
with open(f'cert{TAG}_{l}_{k0}.cnf', 'w') as f:
    f.write(f"p cnf {len(kv)} {2*len(kedges)+1}\n{kv[(1,0,0)]+1} 0\n")
    for e in cert['edges']:
        vs = [e['a']] + [o for m, o in e['others']] + [e['w']]
        f.write(' '.join(str(-(x+1)) for x in vs) + ' 0\n'); f.write(' '.join(str(x+1) for x in vs) + ' 0\n')
print(f"wrote cert{TAG}_{l}_{k0}.json/.cnf: vertices={len(kv)} edges={len(kedges)} total {time.time()-t0:.1f}s")
