#!/usr/bin/env python3
"""Full second-implementation check of the T1-fill decision used by t1red/t1multi, for one (l, e).
For EVERY window of [1,2l] (colour of 1 = R) with 2 <= j <= l-2: compare the C objective (t1hill C mode, the same
evalw logic as t1red/t1multi) with the separately written Python minimum (t1fill_witness.best_w of
evidence/oq64_asymptotic/scripts); for every window the C code calls refuted (obj <= 0), build the explicit
T1-fill hyperedges with t1fill_witness.verify and check that the chain closes (CLASH).
usage: full_explicit.py T1HILL_BINARY l e"""
import sys, os, subprocess
if not __debug__: raise SystemExit("refusing to run under python -O")
t1hill, l, e = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
W = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'oq64_asymptotic', 'scripts', 't1fill_witness.py')
argv = sys.argv[:]; sys.argv = [sys.argv[0]]
exec(open(W).read().split("if __name__")[0])
N = F(l + e, l)
wins = []
for bits in range(1 << (2*l - 1)):
    s = 'R' + ''.join('R' if (bits >> (x - 2)) & 1 else 'B' for x in range(2, 2*l + 1))
    nr = s.count('R'); nb = 2*l - nr; j = min(nr, nb)
    if max(nr, nb) >= l + 2 and 2 <= j <= l - 2: wins.append(s)
out = subprocess.run([t1hill, 'C'], input=''.join(f'{l} {e} {w}\n' for w in wins), capture_output=True, text=True).stdout.split()
assert len(out) == len(wins)
mism = refuted = clash = surv = 0
for w, o in zip(wins, out):
    col = [None] + list(w)
    bw = best_w(l, e, col); o = int(o)
    if bw is None or bw[0] - N != o:
        mism += 1
        if mism <= 5: print('MISMATCH', w, o, None if bw is None else bw[0] - N)
        continue
    if o <= 0:
        refuted += 1
        r = verify(l, e, col, bw[1])
        if r and r[0] == 'CLASH': clash += 1
        else: print('NO CLASH', w)
    else: surv += 1
print(f'l={l} e={e} N={N} windows={len(wins)} objective mismatches={mism} refuted={refuted} '
      f'explicit chains closing={clash} survivors={surv}', flush=True)
