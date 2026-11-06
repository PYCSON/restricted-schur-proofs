#!/usr/bin/env python3
"""Per-window refutation with certificates.  For each window string (colours of 1..2l, 'R' = colour of 1)
run numfastc on [1, F(l+e, l)] with the window as prefix, keep the hyperedges, rebuild the CNF with mkcnfw
(which re-checks every hyperedge and adds the prefix unit clauses), prove it UNSAT with CaDiCaL (LRAT) and
check the proof with lrat-check and cake_lpr.  Resumable via the results file.
usage: perwin_cert.py l e windows_file results.tsv edges_out.txt [time_limit_s]"""
import sys, os, subprocess, tempfile, shutil
if not __debug__: raise SystemExit("refusing to run under python -O")
l, e = int(sys.argv[1]), int(sys.argv[2]); WF, RES, EOUT = sys.argv[3], sys.argv[4], sys.argv[5]
TL = int(sys.argv[6]) if len(sys.argv) > 6 else 6000
NUM = '<TOOLS>/numfastc'
MK = '<REPO>/evidence/oq64_windows/tools/mkcnfw.py'
T = '<TOOLS>'
def F(k): return k * k + ((l + 1) * (l - 2) // 2 + 2) * k + l * (l - 2)
k = l + e; n = F(k)
wins = [x.split()[0] for x in open(WF) if x.strip()]
done = set((x.split('\t')[0], int(x.split('\t')[1])) for x in open(RES)) if os.path.exists(RES) else set()
for pre in wins:
    assert len(pre) == 2 * l and pre[0] == 'R' and set(pre) <= {'R', 'B'}, pre
    if (pre, e) in done: continue
    d = tempfile.mkdtemp(dir='<WORKDIR>')
    try:
        out = subprocess.run([NUM, str(k), str(l), str(n), str(TL), pre, f'{d}/e.txt'], capture_output=True, text=True).stdout
        line = next((x for x in out.splitlines() if x.startswith(('UNSAT', 'GOOD', 'TIMEOUT'))), 'ERROR')
        if not line.startswith('UNSAT'):
            status = 'NOT-UNSAT'; mkl = ''
        else:
            mk = subprocess.run(['python3', '-I', MK, str(k), str(l), str(n), f'{d}/e.txt', f'{d}/c.cnf', pre],
                                capture_output=True, text=True).stdout.strip().splitlines()
            mkl = mk[-1] if mk else 'none'
            if 'bad=0' not in mkl: status = 'MKCNF-FAIL'
            else:
                rc = subprocess.run([f'{T}/cadical/build/cadical', '--unsat', '--lrat=true', '--binary=false', '-q',
                                     f'{d}/c.cnf', f'{d}/p.lrat'], capture_output=True).returncode
                if rc != 20: status = f'CADICAL-rc{rc}'
                else:
                    lc = subprocess.run([f'{T}/drat-trim/lrat-check', f'{d}/c.cnf', f'{d}/p.lrat'], capture_output=True, text=True)
                    lok = lc.returncode == 0 and any(s.strip() == 'c VERIFIED' for s in lc.stdout.splitlines())
                    ck = subprocess.run([f'{T}/cake_lpr/cake_lpr', '--CML_HEAP_SIZE=4000', '--CML_STACK_SIZE=500',
                                         f'{d}/c.cnf', f'{d}/p.lrat'], capture_output=True, text=True)
                    cok = ck.returncode == 0 and any(s.strip() == 's VERIFIED UNSAT' for s in ck.stdout.splitlines())
                    status = 'PASS' if lok and cok else 'CHECK-FAIL'
            body = open(f'{d}/e.txt').read().strip().replace('\n', ';') if os.path.exists(f'{d}/e.txt') else ''
            with open(EOUT, 'a') as g: g.write(f'{pre}_{e}\t{body}\n')
        with open(RES, 'a') as g: g.write(f'{pre}\t{e}\t{status}\t{line}\t{mkl}\n')
        print(pre, e, status, line[:90], flush=True)
    finally:
        shutil.rmtree(d, ignore_errors=True)
print('ALL DONE', flush=True)
