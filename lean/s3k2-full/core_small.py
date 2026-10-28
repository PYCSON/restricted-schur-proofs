"""Vertex-minimal UNSAT core (with vertex 1 fixed to colour 0) for the weak direct instance of small k.
Prints the core as a JSON list."""
import sys, json
from pysat.solvers import Solver
k = int(sys.argv[1]); F = k**3 + 3*k*k + 2*k - 2; m = k - 1
E = [(u, v, m*u + v) for u in range(1, F + 1) for v in range(1, F + 1) if u != v and m*u + v <= F]
V = lambda x, c: 3*(x - 1) + c + 1; act = lambda x: 3*F + x
s = Solver(name='cadical153')
for x in range(1, F + 1): s.add_clause([-act(x)] + [V(x, c) for c in range(3)])
s.add_clause([V(1, 0)])
for (u, v, w) in E:
    for c in range(3): s.add_clause([-V(u, c), -V(v, c), -V(w, c)])
keep = set(range(1, F + 1))
assert not s.solve(assumptions=[act(x) for x in keep])
keep = {l - 3*F for l in s.get_core() if l > 3*F} | {1}
for x in sorted(keep, reverse=True):
    if x == 1 or x not in keep: continue
    t = keep - {x}
    if not s.solve(assumptions=[act(y) for y in t]):
        keep = {l - 3*F for l in s.get_core() if l > 3*F} | {1}
json.dump(sorted(keep), open(f'inputs/core_k{k}.json', 'w'))
print(k, F, 'core', len(keep), 'edges inside', sum(1 for (u, v, w) in E if u in keep and v in keep and w in keep))
