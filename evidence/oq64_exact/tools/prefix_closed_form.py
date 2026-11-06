#!/usr/bin/env python3
"""Closed form (P0) of LEMMA_P.md against the C objective: for 9 <= l <= 40, 1 <= e <= 11 and every 2 <= j <= l-2,
w*(P_j) - F(l+e,l) computed by t1hill C on the prefix window red=[1,j] must equal the closed form.
usage: prefix_closed_form.py T1HILL_BINARY"""
import sys, subprocess
if not __debug__: raise SystemExit("refusing to run under python -O")
def F(k, l): return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)
def Pw(l, e, j):
    q = l - j
    return (q+1)*(l*j + l*(l+1)//2) + j*(j+1)//2 + (q+1)*(e-1)*(j+1) + (q+1)*j + (q+1)*(q+2)//2 - j + e
keys = [(l, e, j) for l in range(9, 41) for e in range(1, 12) for j in range(2, l - 1)]
out = subprocess.run([sys.argv[1], 'C'], input=''.join(f"{l} {e} {'R'*j + 'B'*(2*l-j)}\n" for l, e, j in keys),
                     capture_output=True, text=True).stdout.split()
assert len(out) == len(keys)
bad = sum(int(o) != Pw(l, e, j) - F(l + e, l) for (l, e, j), o in zip(keys, out))
print(f'closed form checked on {len(keys)} prefix windows: mismatches {bad}')
sys.exit(1 if bad else 0)
