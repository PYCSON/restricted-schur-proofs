#!/usr/bin/env python3
"""From a CNF and an LRAT proof, collect the original clauses in the backward cone of the empty clause and
write the hyperedges they come from (both clauses of a hyperedge are kept together).
usage: trimcore.py edges.txt cnf lrat out_edges.txt"""
import sys
edges_fn, cnf_fn, lrat_fn, out = sys.argv[1:5]
ncls = 0
for line in open(cnf_fn):
    if line.startswith('p'): ncls = int(line.split()[3]); break
steps = {}; empty = None
for line in open(lrat_fn):
    p = line.split()
    if p[1] == 'd': continue
    sid = int(p[0]); i = 1
    while p[i] != '0': i += 1
    lits_empty = (i == 1)
    hints = [int(x) for x in p[i + 1:-1]]
    steps[sid] = hints
    if lits_empty: empty = sid; break
need_orig = set(); seen = set(); st = [empty]
while st:
    s = st.pop()
    if s in seen: continue
    seen.add(s)
    if s <= ncls: need_orig.add(s); continue
    for h in steps[s]: st.append(abs(h))
# clause 1 is the unit {1}; clauses 2j and 2j+1 (1-based: 2+2(j), 3+2(j)) belong to hyperedge j
keep = set()
for c in need_orig:
    if c >= 2: keep.add((c - 2) // 2)
lines = open(edges_fn).read().splitlines()
with open(out, 'w') as f:
    for j in sorted(keep): f.write(lines[j] + '\n')
print(f'original clauses used {len(need_orig)}; hyperedges kept {len(keep)} of {len(lines)}')
