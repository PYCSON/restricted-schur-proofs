#!/usr/bin/env python3
"""Regenerate an LRAT proof for every per-window certificate from the archived hyperedges.
For each (set, window): rebuild the CNF with mkcnfw (re-checks every hyperedge, adds the prefix unit clauses),
prove UNSAT with CaDiCaL (LRAT), and store xz -9 of the proof as <out>/<window>_<e>.lrat.xz.  The proofs are
checked later (lrat-check and cake_lpr) by the replay script.  Resumable; jobs are split by index modulo P.
usage: regen_proofs.py part P"""
import sys, os, subprocess, lzma, hashlib, tempfile, shutil
if not __debug__: raise SystemExit("refusing to run under python -O")
part, P = int(sys.argv[1]), int(sys.argv[2])
EV = '<PRIVATE_EVIDENCE>'
MK = '<REPO>/evidence/oq64_windows/tools/mkcnfw.py'
CAD = '<TOOLS>/cadical/build/cadical'
SP = '<WORKDIR>'
def F(k, l): return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)
sets = []
for l in range(12, 19):
    for e in (1, 2, 3):
        f = f'{EV}/edges_l{l}_e{e}.txt.xz'
        if os.path.exists(f): sets.append((f'l{l}', l, e, F(l+e, l), f))
for l in (19, 20):
    for e in (2, 3): sets.append((f'l{l}', l, e, F(l+e, l), f'{EV}/l{l}/edges_l{l}_e{e}.txt.xz'))
sets.append(('S2_20_19', 19, 1, 4181, f'{EV}/S2_20_19/edges_n4181.txt.xz'))
sets.append(('S2_21_20', 20, 1, 4861, f'{EV}/S2_21_20/edges_n4861.txt.xz'))
OUT = '<WORKDIR>/proofs'
idx = 0; done = made = 0
for name, l, e, n, ef in sets:
    od = f'{OUT}/{name}_e{e}'; os.makedirs(od, exist_ok=True)
    with lzma.open(ef, 'rt') as f:
        for line in f:
            key, body = line.rstrip('\n').split('\t', 1)
            pre, ee = key.rsplit('_', 1); assert int(ee) == e and len(pre) == 2*l
            idx += 1
            if idx % P != part: continue
            out = f'{od}/{pre}_{e}.lrat.xz'
            if os.path.exists(out): done += 1; continue
            d = tempfile.mkdtemp(dir=SP)
            try:
                open(f'{d}/e.txt', 'w').write(body.replace(';', '\n') + '\n')
                mk = subprocess.run(['python3', '-I', MK, str(l+e), str(l), str(n), f'{d}/e.txt', f'{d}/c.cnf', pre],
                                    capture_output=True, text=True).stdout.strip().splitlines()
                assert mk and 'bad=0' in mk[-1], (name, pre, mk)
                rc = subprocess.run([CAD, '--unsat', '--lrat=true', '--binary=false', '-q', f'{d}/c.cnf', f'{d}/p.lrat'],
                                    capture_output=True).returncode
                assert rc == 20, (name, pre, rc)
                subprocess.run(['xz', '-9', '-f', f'{d}/p.lrat'], check=True)
                shutil.move(f'{d}/p.lrat.xz', out + '.tmp'); os.replace(out + '.tmp', out); made += 1
            finally:
                shutil.rmtree(d, ignore_errors=True)
print(f'part {part}/{P}: made {made}, already present {done}', flush=True)
