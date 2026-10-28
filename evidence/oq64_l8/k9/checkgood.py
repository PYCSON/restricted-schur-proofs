#!/usr/bin/env python3
"""Independent check that a colouring of [1,n] has no monochromatic solution of x_1+...+x_k=x_{k+1} with exactly
l+1 distinct integers (set-based DP over each colour class; does not share code with numeng.py).
usage: checkgood.py k l n colouring.txt"""
import sys
k, l, n = map(int, sys.argv[1:4]); col = list(map(int, open(sys.argv[4]).read().split()))
assert len(col) == n
E = k - l; found = 0
for X in set(col):
    C = [i + 1 for i in range(n) if col[i] == X]
    # reach[(d, e)] = set of sums using d distinct values with e extra multiplicity
    reach = {(0, 0): {0}}
    for v in C:
        new = {key: set(s) for key, s in reach.items()}
        for (d, e), sums in reach.items():
            if d == l: continue
            for extra in range(0, E - e + 1):
                key = (d + 1, e + extra); add = v * (1 + extra)
                tgt = new.setdefault(key, set())
                for s in sums:
                    t = s + add
                    if t <= n: tgt.add(t)
        reach = new
    hits = reach.get((l, E), set()) & set(C)
    found += len(hits)
    print(f'colour {X}: {len(C)} integers, monochromatic exact sums inside class: {len(hits)}')
print('GOOD' if found == 0 else 'NOT GOOD'); sys.exit(0 if found == 0 else 1)
