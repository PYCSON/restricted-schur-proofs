#!/usr/bin/env python3
"""Certify every T19 done cube (cert_11_13). Resumable: results.tsv lines are skipped on rerun.
usage: runcert.py state.json edges_dir out_dir workers rounds
Per cube P: cubecert.py 11 13 P.edges P C<P> <rounds>  -> verify.sh (check_cert symbolic + CaDiCaL LRAT
+ lrat-check + cake_lpr). Keeps certC<P>_11_13.{json,lrat}.xz + logs; the .cnf/.cube.cnf are
re-derivable from the json (check_cert re-derives and compares the CNF)."""
import sys, json, os, subprocess, threading
from concurrent.futures import ThreadPoolExecutor, as_completed
st, ED, OUT, W, R = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), sys.argv[5]
HERE = os.path.dirname(os.path.abspath(__file__))
os.makedirs(OUT, exist_ok=True)
RES = os.path.join(OUT, 'results.tsv')
done = sorted(p for p, v in json.load(open(st))['tasks'].items() if v['status'] == 'done')
have = set(l.split('\t')[0] for l in open(RES)) if os.path.exists(RES) else set()
lock = threading.Lock(); vlock = threading.Lock()
def one(p):
    b = f'certC{p}_11_13'
    r1 = subprocess.run(['python3', '-I', os.path.join(HERE, 'cubecert.py'), '11', '13', os.path.join(ED, p + '.edges'), p, 'C' + p, R],
                        cwd=OUT, capture_output=True, text=True)
    cc = r1.stdout.strip().splitlines()[-1] if r1.stdout.strip() else 'NO OUTPUT ' + r1.stderr[-200:]
    if r1.returncode != 0 or not cc.startswith('wrote'): return p, 'CUBECERT_FAIL ' + cc
    with vlock:  # one LRAT/cake_lpr at a time (memory)
        v = subprocess.run(['bash', os.path.join(HERE, 'verify.sh'), b], cwd=OUT, capture_output=True, text=True).stdout.strip()
    ok = ('symbolic_problems=0' in v and 'cnf_matches=True' in v and 'numeric_problems=0' in v and 'cadical_rc=20' in v
          and 'lrat-check:c VERIFIED' in v and 'cake_lpr:s VERIFIED UNSAT' in v)
    if ok:
        for ext in ('json', 'lrat'): subprocess.run(['xz', '-9', '-f', f'{b}.{ext}'], cwd=OUT, check=True)
        for ext in ('cnf', 'cube.cnf'): os.remove(os.path.join(OUT, f'{b}.{ext}'))
    return p, ('PASS ' if ok else 'FAIL ') + cc.replace('wrote ', '') + ' || ' + v
with ThreadPoolExecutor(W) as ex:
    for f in as_completed([ex.submit(one, p) for p in done if p not in have]):
        p, r = f.result()
        with lock:
            open(RES, 'a').write(p + '\t' + r + '\n')
        print(p, r[:60], flush=True)
rs = dict(l.rstrip('\n').split('\t', 1) for l in open(RES))
npass = sum(1 for p in done if rs.get(p, '').startswith('PASS'))
print(f'SUMMARY {npass}/{len(done)} PASS', flush=True)
