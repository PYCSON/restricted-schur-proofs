#!/usr/bin/env python3
"""Result 7, combined argument: build the set of certified (l, j, e) from the certificate directories present in
this package, then run z1c_combined.py on it (forcing lemma R-23', R-22 for large k, balanced windows j=l-1).
Every certificate directory used here is checked by `verify_all.sh windows`.
usage: windows_coverage.py   (prints z1c_combined.py output; exit 0 iff all 208 windows are covered)"""
import os, re, subprocess, sys
here = os.path.dirname(os.path.abspath(__file__))
cert = {}
for root, dirs, files in os.walk(here):
    if 'prefix.txt' not in files: continue
    rel = os.path.relpath(root, here).split(os.sep)
    name = rel[-1]; e = 1
    if rel[0] == 'wj_certs_e2_5': e = int(rel[1][1:])
    elif rel[0] == 'wj_certs_gap':
        m = re.match(r'e(\d+)_(W_.*)', name); e = int(m.group(1)); name = m.group(2)
    m = re.match(r'W_l(\d+)_j(\d+)$', name); l, j = int(m.group(1)), int(m.group(2))
    cert.setdefault((l, j), set()).add(e)
n = sum(len(v) for v in cert.values())
print(f'certified (l,j,e) triples found: {n}', flush=True)
out = subprocess.run([sys.executable, os.path.join(here, 'z1c_combined.py'), repr(cert)], capture_output=True, text=True)
print(out.stdout, end='')
sys.exit(0 if n == 1470 and out.stdout.startswith('windows excluded for every k>=l+1: 208 of 208') and out.stdout.count('\n') == 1 else 1)
