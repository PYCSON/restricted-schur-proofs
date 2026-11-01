#!/usr/bin/env python3
"""Build the CNFs of one cube certificate after checking that its unit clauses are exactly implied by its prefix.

usage: check_cube.py <certC<P>_11_13.json> <P> <base_cnf_out> <cube_cnf_out>

The symbolic content of the JSON (identities, multiplicities, distinctness and ranges for every k >= 13) is
checked separately by evidence/oq64_kernel/check_cert.py, which also compares <base_cnf_out> with its own
re-derivation. This script checks the cube part:
  * l = 11, k0 = 13, and the JSON's "prefix" field equals <P> (the prefix in the file name);
  * the unit vertex is the constant 1 and gets colour 0;
  * every other unit (v, col) is on a constant vertex m with 2 <= m <= len(P)+1 and col = P[m-2], and no
    vertex gets two units.
So the cube CNF only adds facts that hold for every colouring in the cube "1 has colour 0 and the integer
j+2 has colour P[j]". A refutation of the cube CNF therefore excludes every good colouring in that cube.
CNF variable v+1 true means colour 0. Each hyperedge gives two clauses (not all colour 0, not all colour 1).
"""
import json, sys

jpath, P, base_out, cube_out = sys.argv[1:5]
c = json.load(open(jpath))
bad = []
if not (c.get('l') == 11 and c.get('k0') == 13): bad.append('l/k0 is not 11/13')
if c.get('prefix') != P: bad.append(f"prefix field {c.get('prefix')!r} != {P!r}")
if not (P and set(P) <= {'0', '1'}): bad.append('prefix is not a 0/1 string')
V = c['vertices']; n = len(V); ur = c['unit_red']
if not (0 <= ur < n and list(V[ur]) in ([1, 0, 0], [1])): bad.append('unit_red is not the constant 1')
seen = {}
for v, col in c['cube_units']:
    if not (isinstance(v, int) and 0 <= v < n and col in (0, 1)): bad.append(f'bad unit {v, col}'); continue
    if v in seen: bad.append(f'vertex {v} has two units'); continue
    seen[v] = col
    q = list(V[v]) + [0, 0, 0]
    if any(q[1:3]): bad.append(f'unit on a non-constant vertex {V[v]}'); continue
    m = q[0]
    if v == ur:
        if col != 0: bad.append('the integer 1 must have colour 0')
    elif not (2 <= m <= len(P) + 1 and col == int(P[m - 2])): bad.append(f'unit (integer {m}, colour {col}) not implied by prefix {P}')
if seen.get(ur) != 0: bad.append('missing unit for the integer 1')
L = [f"{ur + 1} 0"]
for e in c['edges']:
    vs = [e['a']] + [o for m, o in e['others']] + [e['w']]
    if not all(isinstance(x, int) and 0 <= x < n for x in vs): bad.append('edge vertex out of range'); break
    L.append(' '.join(str(-(x + 1)) for x in vs) + ' 0'); L.append(' '.join(str(x + 1) for x in vs) + ' 0')
U = [f"{(v + 1) * (1 if col == 0 else -1)} 0" for v, col in c['cube_units'] if v != ur]
open(base_out, 'w').write(f"p cnf {n} {len(L)}\n" + '\n'.join(L) + '\n')
open(cube_out, 'w').write(f"p cnf {n} {len(L) + len(U)}\n" + '\n'.join(L + U) + '\n')
print(f"cube {P}: vertices={n} edges={len(c['edges'])} prefix_units={len(U)} problems={len(bad)}")
for b in bad[:20]: print('  FAIL', b)
sys.exit(1 if bad else 0)
