#!/usr/bin/env python3
"""Check every hyperedge of a numeric edge file independently and write the 2-colouring CNF.
usage: mkcnf.py k l n edges.txt out.cnf"""
import sys
k, l, n = map(int, sys.argv[1:4]); fn, out = sys.argv[4], sys.argv[5]
cls = [[1]]; bad = 0; cnt = 0
for line in open(fn):
    a, b = line.split('|'); w = int(b)
    summ = [tuple(map(int, t.split(':'))) for t in a.split()]
    vals = [v for m, v in summ]
    ok = (len(vals) == l and len(set(vals)) == l and all(m >= 1 for m, v in summ) and sum(m for m, v in summ) == k
          and all(1 <= v <= n for v in vals) and 1 <= w <= n and sum(m * v for m, v in summ) == w and w not in vals)
    if not ok: bad += 1; continue
    vs = sorted(set(vals + [w])); assert len(vs) == l + 1
    cls.append([-x for x in vs]); cls.append(vs); cnt += 1
with open(out, 'w') as f:
    f.write(f'p cnf {n} {len(cls)}\n')
    for c in cls: f.write(' '.join(map(str, c)) + ' 0\n')
print(f'hyperedges ok={cnt} bad={bad} clauses={len(cls)}')
sys.exit(1 if bad else 0)
