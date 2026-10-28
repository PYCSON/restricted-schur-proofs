#!/usr/bin/env python3
"""Numeric DPLL with complete DP propagation for one (k, l, n): does every 2-colouring of [1,n] contain a
monochromatic solution of x_1+...+x_k = x_{k+1} with exactly l+1 distinct integers?

Propagation: for each colour X, a bitset DP over the integers of colour X gives every sum w of k summands taking
exactly l distinct values of colour X (multiplicities >= 1). If such a w has colour X: conflict. If w <= n is
uncoloured: w is forced to the other colour. Branch on the smallest uncoloured integer (1 is red by symmetry).

Every forcing and every conflict is justified by an explicit solution (reconstructed from the DP); all of them are
written out as hyperedges. Unit propagation over these hyperedges replays the whole search tree, so the CNF built
from them (unit clause {1} + two clauses per hyperedge) is unsatisfiable whenever the search closes; this CNF is
then certified separately with LRAT.
usage: numeng.py k l n [max_seconds] [out_prefix]"""
import sys, time
sys.setrecursionlimit(100000)
k, l, n = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
TMAX = float(sys.argv[4]) if len(sys.argv) > 4 else 3600
OUT = sys.argv[5] if len(sys.argv) > 5 else f'num_{l}_{k}_{n}'
E = k - l
FULL = (1 << (n + 1)) - 1
t0 = time.time()
col = [-1] * (n + 1)
mask = [0, 0]                 # bitmask of integers of colour 0 / 1
edges = set()
stats = {'nodes': 0, 'maxdepth': 0, 'forced': 0}

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

def setc(v, X, trail):
    col[v] = X; mask[X] |= 1 << v; trail.append(v)

def propagate(trail):
    """returns True on conflict"""
    while True:
        progress = False
        for X in (0, 1):
            C, hist, sums = dp(X)
            bad = sums & mask[X]
            if bad:
                w = (bad & -bad).bit_length() - 1
                edges.add(witness(C, hist, w))
                return True
            free = sums & ~mask[0] & ~mask[1] & FULL & ~1
            while free:
                w = (free & -free).bit_length() - 1
                free &= free - 1
                edges.add(witness(C, hist, w))
                setc(w, 1 - X, trail); stats['forced'] += 1
                progress = True
        if not progress:
            return False

GOOD = None
def solve(depth):
    global GOOD
    stats['nodes'] += 1; stats['maxdepth'] = max(stats['maxdepth'], depth)
    if stats['nodes'] % 200 == 0:
        print(f"t={time.time()-t0:.0f}s nodes={stats['nodes']} depth={depth} maxdepth={stats['maxdepth']} forced={stats['forced']} edges={len(edges)}", flush=True)
    if time.time() - t0 > TMAX: raise TimeoutError
    trail = []
    try:
        if propagate(trail): return True
        v = next((u for u in range(1, n + 1) if col[u] == -1), None)
        if v is None:
            GOOD = col[:]; return False
        for X in (0, 1):
            t2 = []
            setc(v, X, t2)
            ok = solve(depth + 1)
            for u in t2: mask[col[u]] &= ~(1 << u); col[u] = -1
            if not ok: return False
        return True
    finally:
        for u in trail: mask[col[u]] &= ~(1 << u); col[u] = -1

t2 = []
setc(1, 0, t2)
try:
    res = 'UNSAT' if solve(0) else 'GOOD_COLOURING'
except TimeoutError:
    res = 'TIMEOUT'
print(f"{res}: k={k} l={l} n={n} nodes={stats['nodes']} maxdepth={stats['maxdepth']} forced={stats['forced']} edges={len(edges)} {time.time()-t0:.1f}s", flush=True)
with open(OUT + '.edges', 'w') as f:
    for summ, w in sorted(edges):
        f.write(' '.join(f'{m}:{v}' for m, v in summ) + f' | {w}\n')
if GOOD is not None:
    with open(OUT + '.good', 'w') as f: f.write(' '.join(str(GOOD[v]) for v in range(1, n + 1)) + '\n')
