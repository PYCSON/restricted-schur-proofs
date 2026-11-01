#!/usr/bin/env python3
"""Check that the cube prefixes of the K(11)=12 certificate family form a complete partition.

usage: check_partition.py <certs_dir>

The prefixes are read from the certificate file names certC<P>_11_13.json.xz in <certs_dir>.
Prefix bit j is the colour of the integer j+2 (0 = same colour as 1; the colour of 1 is fixed by symmetry).
Checks (exit status 1 on any failure):
  * every prefix is a non-empty 0/1 string and has both a .json.xz and a .lrat.xz file, and no other
    certC*_11_13.* certificate files are present;
  * no prefix is a proper prefix of another (the cubes are disjoint);
  * sum over prefixes of 2^(-length) = 1 exactly (together with prefix-freeness: the cubes cover every
    colouring of 2,3,... ).
"""
import os, re, sys
from fractions import Fraction

d = sys.argv[1]
names = os.listdir(d)
pat = re.compile(r'^certC([01]+)_11_13\.(json|lrat)\.xz$')
js, lr, other = set(), set(), []
for n in names:
    m = pat.match(n)
    if m:
        (js if m.group(2) == 'json' else lr).add(m.group(1))
    elif n.startswith('certC'):
        other.append(n)
bad = []
if other: bad.append(f'unexpected certificate files: {sorted(other)[:5]}')
if js != lr: bad.append(f'json/lrat mismatch: {sorted(js ^ lr)[:5]}')
P = sorted(js)
s = sorted(P)
for a, b in zip(s, s[1:]):          # in sorted order a proper prefix of b is immediately followed by an extension
    if b.startswith(a): bad.append(f'{a} is a prefix of {b}')
for i, a in enumerate(P):            # full quadratic check as well (222 prefixes)
    for b in P[i + 1:]:
        if b.startswith(a) or a.startswith(b): bad.append(f'overlap {a} {b}')
W = sum(Fraction(1, 2 ** len(p)) for p in P)
if W != 1: bad.append(f'sum of 2^-len = {W}, not 1')
lens = {}
for p in P: lens[len(p)] = lens.get(len(p), 0) + 1
print(f'prefixes={len(P)} lengths={dict(sorted(lens.items()))} weight={W} prefix_free={not any("overlap" in b or "prefix of" in b for b in bad)}')
for b in bad[:20]: print('  FAIL', b)
sys.exit(1 if bad else 0)
