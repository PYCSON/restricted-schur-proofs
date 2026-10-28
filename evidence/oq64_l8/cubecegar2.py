#!/usr/bin/env python3
"""Cube-and-conquer CEGAR for one (k, l, n): is every 2-colouring of [1,n] forced to contain a monochromatic
solution of x_1+...+x_k = x_{k+1} with exactly l+1 distinct integers?

One incremental SAT solver holds every hyperedge found so far (each is a genuine solution, so it is valid in
every cube). A cube fixes the colours of 2..d (1 is red). In a cube: solve under the cube's assumptions;
if SAT, search both colour classes of the model for monochromatic solutions (exact DP) and add them;
repeat until UNSAT (cube closed) or the budget runs out (split on the next integer).
A model with no monochromatic solution is a colouring of [1,n] that avoids all solutions -> printed and saved.
usage: cubecegar2.py k l n [budget_per_cube] [max_seconds] [conflict_budget] [seed_edges]
v2: each SAT call has a conflict budget (undecided -> split); progress line every 60 s; edges saved every 10 min.
writes cube_<l>_<k>_<n>.edges (all hyperedges) and, if found, cube_<l>_<k>_<n>.good"""
import sys, time
from pysat.solvers import Solver

k, l, n = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
BUDGET = int(sys.argv[4]) if len(sys.argv) > 4 else 60
TMAX = float(sys.argv[5]) if len(sys.argv) > 5 else 3600
CONF = int(sys.argv[6]) if len(sys.argv) > 6 else 20000
SEED = sys.argv[7] if len(sys.argv) > 7 else None
t0 = time.time()
tag = f'cube2_{l}_{k}_{n}'
S = Solver(name='cadical195')
S.add_clause([1])
edges = {}

def valid(summ, w):
    vals = [v for m, v in summ]
    return (len(set(vals)) == l and all(m >= 1 for m, v in summ) and sum(m for m, v in summ) == k
            and all(1 <= v <= n for v in vals) and sum(m * v for m, v in summ) == w and 1 <= w <= n and w not in vals)

def add(summ, w):
    key = (tuple(sorted(summ)), w)
    if key in edges: return 0
    edges[key] = 1
    vs = sorted(set([v for m, v in summ] + [w]))
    S.add_clause([-x for x in vs]); S.add_clause(vs)
    return 1

def find_solutions(C, limit):
    E = k - l
    maskC = 0
    for v in C: maskC |= 1 << v
    full = (1 << (n + 1)) - 1
    hist = []
    cur = [[0] * (E + 1) for _ in range(l + 1)]
    cur[0][0] = 1
    hist.append(cur)
    for v in C:
        nxt = [row[:] for row in cur]
        for cnt in range(l):
            for e in range(E + 1):
                b = cur[cnt][e]
                if not b: continue
                for extra in range(0, E - e + 1):
                    sh = (b << (v * (1 + extra))) & full
                    if sh: nxt[cnt + 1][e + extra] |= sh
        cur = nxt; hist.append(cur)
    hits = cur[l][E] & maskC
    sols = []; w = 0
    while hits and len(sols) < limit:
        if hits & 1 and w > 0:
            summ = []; cnt, e, s = l, E, w
            for i in range(len(C), 0, -1):
                v = C[i - 1]; prev = hist[i - 1]
                if (prev[cnt][e] >> s) & 1: continue
                for extra in range(0, e + 1):
                    if cnt >= 1 and s - v * (1 + extra) >= 0 and (prev[cnt - 1][e - extra] >> (s - v * (1 + extra))) & 1:
                        summ.append((1 + extra, v)); cnt -= 1; e -= extra; s -= v * (1 + extra); break
                if cnt == 0: break
            assert cnt == 0 and s == 0 and e == 0
            sols.append((summ, w))
        hits >>= 1; w += 1
        if w > n: break
    return sols

stats = {'cubes': 0, 'closed': 0, 'iters': 0, 'maxdepth': 0, 'undecided': 0}
last = {'log': time.time(), 'save': time.time(), 'saved': 0}
def save_edges():
    with open(tag + '.edges', 'w') as f:
        for (summ, w) in edges:
            f.write(' '.join(f'{m}:{v}' for m, v in summ) + f' | {w}\n')
if SEED:
    for line in open(SEED):
        a, b = line.split('|')
        summ = [tuple(map(int, t.split(':'))) for t in a.split()]
        add(summ, int(b))
    print(f'seeded {len(edges)} edges from {SEED}', flush=True)
GOOD = None

def refine(model):
    pos = set(x for x in model if x > 0)
    col = [None] + [1 if i in pos else 0 for i in range(1, n + 1)]
    added = 0
    for X in (1, 0):
        C = [v for v in range(1, n + 1) if col[v] == X]
        for summ, w in find_solutions(C, 400):
            assert valid(summ, w)
            added += add(summ, w)
    return added, col

def cube(assum, nxt, depth):
    global GOOD
    stats['cubes'] += 1; stats['maxdepth'] = max(stats['maxdepth'], depth)
    for _ in range(BUDGET):
        stats['iters'] += 1
        now = time.time()
        if now - last['log'] > 60:
            last['log'] = now
            print(f"t={now-t0:.0f}s cubes={stats['cubes']} closed={stats['closed']} undecided={stats['undecided']} depth={depth} maxdepth={stats['maxdepth']} iters={stats['iters']} edges={len(edges)}", flush=True)
        if now - last['save'] > 600:
            last['save'] = now; save_edges()
        S.conf_budget(CONF)
        r = S.solve_limited(assumptions=assum)
        if r is None:
            stats['undecided'] += 1
            break
        if not r:
            stats['closed'] += 1
            return True
        added, col = refine(S.get_model())
        if added == 0:
            GOOD = col
            return False
        if time.time() - t0 > TMAX: raise TimeoutError
    for lit in (nxt, -nxt):   # split on the next integer
        if not cube(assum + [lit], nxt + 1, depth + 1): return False
    return True

try:
    ok = cube([], 2, 0)
    res = 'UNSAT' if ok else 'GOOD_COLOURING'
except TimeoutError:
    res = 'TIMEOUT'
print(f"{res}: cubes={stats['cubes']} closed={stats['closed']} undecided={stats['undecided']} maxdepth={stats['maxdepth']} iters={stats['iters']} edges={len(edges)} {time.time()-t0:.0f}s", flush=True)
if GOOD is not None:
    open(tag + '.good', 'w').write(' '.join(str(GOOD[v]) for v in range(1, n + 1)) + '\n')
save_edges()
