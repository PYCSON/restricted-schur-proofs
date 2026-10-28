#!/usr/bin/env python3
"""numeng2: numeric DPLL like numeng.py, but records only the edges each leaf actually needs.

Same search as numeng.py (complete bitset-DP propagation, branch on the smallest uncoloured integer, 1 is red).
Every forced integer keeps its reason hyperedge. At each conflict, the backward cone of reasons from the conflict
hyperedge is added to the output; nothing else is stored. Unit propagation over the union of these cones, started
from the decisions of any leaf, re-derives the forced integers of that cone in order and then falsifies the
conflict hyperedge, so the CNF built from the output (unit {1} + two clauses per hyperedge) is unsatisfiable when
the search closes. The CNF is then certified separately (CaDiCaL LRAT + lrat-check + cake_lpr), so this file is
only a generator: its correctness does not need to be trusted.
usage: numeng2w.py k l n max_seconds out_prefix PREFIX(R/B string fixing 1..len)"""
import sys, time
sys.setrecursionlimit(100000)
k, l, n = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
TMAX = float(sys.argv[4]) if len(sys.argv) > 4 else 3600
OUT = sys.argv[5] if len(sys.argv) > 5 else f'num2_{l}_{k}_{n}'
PREFIX = sys.argv[6] if len(sys.argv) > 6 else 'R'
assert PREFIX[0] == 'R'
E = k - l
FULL = (1 << (n + 1)) - 1
t0 = time.time()
col = [-1] * (n + 1)
reason = [None] * (n + 1)      # reason hyperedge of a forced integer (None for decisions and for 1)
mask = [0, 0]
edges = set()
stats = {'nodes': 0, 'maxdepth': 0, 'forced': 0, 'leaves': 0}
path = []                      # branch index (0/1) at each depth, for progress display

def dp(X):
    C = [v for v in range(1, n + 1) if col[v] == X]
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
                    sh = (b << (v * (1 + extra))) & FULL
                    if sh: nxt[cnt + 1][e + extra] |= sh
        cur = nxt; hist.append(cur)
    return C, hist, cur[l][E]

def witness(C, hist, w):
    summ = []; cnt, e, s = l, E, w
    for i in range(len(C), 0, -1):
        v = C[i - 1]; prev = hist[i - 1]
        if (prev[cnt][e] >> s) & 1: continue
        for extra in range(0, e + 1):
            if cnt >= 1 and s - v * (1 + extra) >= 0 and (prev[cnt - 1][e - extra] >> (s - v * (1 + extra))) & 1:
                summ.append((1 + extra, v)); cnt -= 1; e -= extra; s -= v * (1 + extra); break
        if cnt == 0: break
    assert cnt == 0 and s == 0 and e == 0
    assert sum(m * v for m, v in summ) == w and sum(m for m, v in summ) == k and len(summ) == l
    return (tuple(sorted(summ)), w)

def cone(edge):
    stack = [edge]; seen = set()
    while stack:
        ed = stack.pop()
        if ed in seen: continue
        seen.add(ed)
        summ, w = ed
        for u in [v for _, v in summ] + [w]:
            r = reason[u]
            if r is not None and r is not ed and r not in seen:
                stack.append(r)
    edges.update(seen)

def setc(v, X, trail, r=None):
    col[v] = X; mask[X] |= 1 << v; reason[v] = r; trail.append(v)

def unset(trail):
    for u in trail:
        mask[col[u]] &= ~(1 << u); col[u] = -1; reason[u] = None

def propagate(trail):
    """returns True on conflict"""
    while True:
        progress = False
        for X in (0, 1):
            C, hist, sums = dp(X)
            bad = sums & mask[X]
            if bad:
                w = (bad & -bad).bit_length() - 1
                cone(witness(C, hist, w))
                stats['leaves'] += 1
                return True
            free = sums & ~mask[0] & ~mask[1] & FULL & ~1
            while free:
                w = (free & -free).bit_length() - 1
                free &= free - 1
                setc(w, 1 - X, trail, witness(C, hist, w)); stats['forced'] += 1
                progress = True
        if not progress:
            return False

GOOD = None
lastp = [0.0]
def solve(depth):
    global GOOD
    stats['nodes'] += 1; stats['maxdepth'] = max(stats['maxdepth'], depth)
    now = time.time()
    if now - lastp[0] > 30:
        lastp[0] = now
        print(f"t={now-t0:.0f}s nodes={stats['nodes']} leaves={stats['leaves']} depth={depth} maxdepth={stats['maxdepth']} "
              f"edges={len(edges)} path={''.join(map(str, path[:40]))}", flush=True)
    if now - t0 > TMAX: raise TimeoutError
    trail = []
    try:
        if propagate(trail): return True
        v = next((u for u in range(1, n + 1) if col[u] == -1), None)
        if v is None:
            GOOD = col[:]; return False
        for X in (0, 1):
            t2 = []
            setc(v, X, t2)
            path.append(X)
            ok = solve(depth + 1)
            path.pop()
            unset(t2)
            if not ok: return False
        return True
    finally:
        unset(trail)

t2 = []
for i, ch in enumerate(PREFIX, start=1):
    setc(i, 0 if ch == 'R' else 1, t2)
try:
    res = 'UNSAT' if solve(0) else 'GOOD_COLOURING'
except TimeoutError:
    res = 'TIMEOUT'
print(f"{res}: k={k} l={l} n={n} nodes={stats['nodes']} leaves={stats['leaves']} maxdepth={stats['maxdepth']} "
      f"forced={stats['forced']} edges={len(edges)} {time.time()-t0:.1f}s", flush=True)
with open(OUT + '.edges', 'w') as f:
    for summ, w in sorted(edges):
        f.write(' '.join(f'{m}:{v}' for m, v in summ) + f' | {w}\n')
if GOOD is not None:
    with open(OUT + '.good', 'w') as f: f.write(' '.join(str(GOOD[v]) for v in range(1, n + 1)) + '\n')
