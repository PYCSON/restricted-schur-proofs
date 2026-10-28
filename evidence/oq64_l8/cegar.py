#!/usr/bin/env python3
"""CEGAR test of S_2(k;l) <= n (exact version) for one k: lazily add monochromatic-solution hyperedges.
A solution: k summands taking exactly l distinct values (multiplicities >= 1 summing to k), sum w <= n;
w exceeds every summand, so the solution has exactly l+1 distinct integers.
Loop: SAT-solve the current 2-colouring CNF (vertex 1 red); search the colouring for monochromatic solutions
(exact DP over each colour class); add them; stop at UNSAT or at a colouring with no solution.
usage: cegar.py k l n [seed_edges.txt k_eval] [max_seconds]
writes cegar_<l>_<k>_<n>.edges (hyperedges, one per line: summand values with multiplicity m:v ..., then | w)
and, if a colouring without solutions is found, cegar_<l>_<k>_<n>.good (colour list, 1 = red)."""
import sys, time
from pysat.solvers import Solver

k, l, n = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
seedf = sys.argv[4] if len(sys.argv) > 4 and sys.argv[4] != '-' else None
kev = int(sys.argv[5]) if len(sys.argv) > 5 else k
TMAX = float(sys.argv[6]) if len(sys.argv) > 6 else 3000
t0 = time.time()
tag = f'cegar_{l}_{k}_{n}'
S = Solver(name='cadical195')
S.add_clause([1])   # vertex 1 red (colour symmetry)
edges = {}          # frozenset-key -> (summands as tuple of (m,v), w)

def valid(summ, w):
    vals = [v for m, v in summ]
    return (len(set(vals)) == l and len(vals) == l and all(m >= 1 for m, v in summ) and sum(m for m, v in summ) == k
            and all(1 <= v <= n for v in vals) and sum(m * v for m, v in summ) == w and 1 <= w <= n and w not in vals)

def add(summ, w):
    key = (tuple(sorted(summ)), w)
    if key in edges: return False
    edges[key] = 1
    vs = sorted(set([v for m, v in summ] + [w]))
    S.add_clause([-x for x in vs]); S.add_clause(vs)
    return True

if seedf:
    def ev(p): return sum(c * kev ** i for i, c in enumerate(p))
    ok = bad = 0
    for line in open(seedf):
        parts = [p.strip() for p in line.split('|')]
        a = tuple(map(int, parts[0].split())); c = int(parts[1])
        summ = [(kev - c, ev(a))]
        for tok in parts[2].split():
            m, o = tok.split(':'); summ.append((int(m), ev(tuple(map(int, o.split(','))))))
        w = ev(tuple(map(int, parts[3].split())))
        if valid(summ, w): ok += add(summ, w)
        else: bad += 1
    print(f'seed: {ok} edges added, {bad} invalid at k={kev}', flush=True)

def find_solutions(C, limit):
    """all-ish monochromatic solutions inside colour class C (sorted): DP over items with bitsets.
    state (cnt distinct used, extra multiplicity used e = sum(m)-cnt) ; reachable sums as int bitmask."""
    E = k - l                      # total extra multiplicity to distribute
    maskC = 0
    for v in C: maskC |= 1 << v
    full = (1 << (n + 1)) - 1
    # dp[i][cnt][e] after first i items
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
                for extra in range(0, E - e + 1):      # multiplicity 1 + extra
                    sh = (b << (v * (1 + extra))) & full
                    if sh: nxt[cnt + 1][e + extra] |= sh
        cur = nxt; hist.append(cur)
    hits = cur[l][E] & maskC
    sols = []
    w = 0
    while hits and len(sols) < limit:
        if hits & 1 and w > 0:
            # reconstruct one solution with sum w
            summ = []; cnt, e, s = l, E, w
            for i in range(len(C), 0, -1):
                v = C[i - 1]; prev = hist[i - 1]
                if (prev[cnt][e] >> s) & 1: continue   # item not used
                found = False
                for extra in range(0, e + 1):
                    if cnt >= 1 and s - v * (1 + extra) >= 0 and (prev[cnt - 1][e - extra] >> (s - v * (1 + extra))) & 1:
                        summ.append((1 + extra, v)); cnt -= 1; e -= extra; s -= v * (1 + extra); found = True; break
                assert found
                if cnt == 0: break
            assert cnt == 0 and s == 0 and e == 0
            sols.append((summ, w))
        hits >>= 1; w += 1
        if w > n: break
    return sols

it = 0
while True:
    it += 1
    if not S.solve():
        print(f'UNSAT after {it} iterations, {len(edges)} edges, {time.time()-t0:.0f}s', flush=True)
        res = 'UNSAT'; break
    model = S.get_model()
    pos = set(x for x in model if x > 0)
    col = [None] + [1 if i in pos else 0 for i in range(1, n + 1)]   # unconstrained vertices: blue
    added = 0
    for X in (1, 0):
        C = [v for v in range(1, n + 1) if col[v] == X]
        for summ, w in find_solutions(C, 400):
            assert valid(summ, w)
            added += add(summ, w)
    if it % 20 == 0 or added == 0:
        print(f'it={it} edges={len(edges)} added={added} {time.time()-t0:.0f}s', flush=True)
    if added == 0:
        res = 'GOOD_COLOURING'
        open(tag + '.good', 'w').write(' '.join(str(col[v]) for v in range(1, n + 1)) + '\n')
        print(f'colouring of [1,{n}] with no monochromatic exact solution found -> {tag}.good', flush=True)
        break
    if time.time() - t0 > TMAX:
        res = 'TIMEOUT'; print(f'TIMEOUT it={it} edges={len(edges)}', flush=True); break
with open(tag + '.edges', 'w') as f:
    for (summ, w) in edges:
        f.write(' '.join(f'{m}:{v}' for m, v in summ) + f' | {w}\n')
print(res)
