#!/usr/bin/env python3
"""Replay of one set of per-window certificates (fail-closed).

usage: LRAT_CHECK=... CAKE_LPR=... replay_perwin.py SETDIR l e n [JOBS]

SETDIR holds, for this (l, e):
  red_l<l>_e<e>.txt         survivors of the exact T1-fill enumeration at the bound n ("SURV <window> <obj>"
                            lines and a final "DONE l=.. e=.. N=.. ..." line)
  perwin_l<l>_e<e>.txt      the windows treated one by one
  edges_l<l>_e<e>.txt.xz    "<window>_<e>\t<hyperedge>;<hyperedge>;..." (hyperedge = "m:v m:v ... | w")
  proofs_e<e>/<window>_<e>.lrat.xz   one LRAT proof per window

Checks, every one of which must pass:
  1. the red file is well formed, its DONE line has l, e and N = n, and its survivor count is right;
  2. the per-window list is exactly  survivors  plus (for e <= 2) the 2l windows with one minority element;
  3. the edge file and the proof directory hold exactly one entry per listed window;
  4. for every window: mkcnfw.py rebuilds the CNF on [1, n] with the window as unit clauses and re-checks every
     hyperedge (bad=0, exit 0); lrat-check exits 0 and prints "c VERIFIED"; cake_lpr exits 0 and prints
     "s VERIFIED UNSAT".
"""
import sys, os, re, lzma, subprocess, tempfile, shutil
from concurrent.futures import ThreadPoolExecutor
if not __debug__:
    raise SystemExit("refusing to run under python -O")

def fail(msg):
    print("FAIL:", msg, file=sys.stderr)
    sys.exit(1)

setdir, l, e, n = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
jobs = int(sys.argv[5]) if len(sys.argv) > 5 else 1
k = l + e
LRAT_CHECK = os.environ.get("LRAT_CHECK") or fail("set LRAT_CHECK")
CAKE_LPR = os.environ.get("CAKE_LPR") or fail("set CAKE_LPR")
HEAP = os.environ.get("CAKE_HEAP", "4000")
MK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "oq64_windows", "tools", "mkcnfw.py")
win_re = re.compile(r"^R[RB]{%d}$" % (2 * l - 1))

# 1. survivors
lines = open(os.path.join(setdir, f"red_l{l}_e{e}.txt")).read().splitlines()
if not lines or not lines[-1].startswith("DONE "):
    fail("red file has no final DONE line")
done = dict(x.split("=", 1) for x in lines[-1].split()[1:])
if (int(done["l"]), int(done["e"]), int(done["N"])) != (l, e, n):
    fail(f"DONE line is for l={done['l']} e={done['e']} N={done['N']}, expected l={l} e={e} N={n}")
surv = []
for x in lines[:-1]:
    p = x.split()
    if len(p) != 3 or p[0] != "SURV" or not win_re.match(p[1]) or int(p[2]) <= 0:
        fail(f"malformed survivor line: {x[:80]}")
    surv.append(p[1])
if len(surv) != int(done["survivors"]) or len(set(surv)) != len(surv):
    fail("survivor count does not match the DONE line, or a survivor is repeated")

# 2. the per-window list
j1 = set()
if e <= 2:
    j1 = {"".join("B" if x == b0 else "R" for x in range(1, 2 * l + 1)) for b0 in range(2, 2 * l + 1)}
    j1.add("R" + "B" * (2 * l - 1))
    assert len(j1) == 2 * l
expected = sorted(set(surv) | j1)
lf = os.path.join(setdir, f"perwin_l{l}_e{e}.txt")
if not expected and not os.path.exists(lf):
    print(f"  PASS l={l} e={e} n={n}: no survivors and no one-minority windows to treat (DONE line checked)")
    sys.exit(0)
listed = [x for x in open(lf).read().split("\n") if x]
if listed != expected:
    fail(f"per-window list differs from survivors + j=1 windows ({len(listed)} listed, {len(expected)} expected)")

# 3. edges and proofs: one entry per window
edges = {}
with lzma.open(os.path.join(setdir, f"edges_l{l}_e{e}.txt.xz"), "rt") as f:
    for line in f:
        key, body = line.rstrip("\n").split("\t", 1)
        if key in edges:
            fail(f"repeated edge entry {key}")
        edges[key] = body
if set(edges) != {f"{w}_{e}" for w in expected}:
    fail("edge file entries do not match the per-window list")
pdir = os.path.join(setdir, f"proofs_e{e}")
if set(os.listdir(pdir)) != {f"{w}_{e}.lrat.xz" for w in expected}:
    fail("proof directory entries do not match the per-window list")

# 4. one certificate per window
def check(w):
    d = tempfile.mkdtemp()
    try:
        with open(f"{d}/e.txt", "w") as g:
            g.write(edges[f"{w}_{e}"].replace(";", "\n") + "\n")
        r = subprocess.run([sys.executable, MK, str(k), str(l), str(n), f"{d}/e.txt", f"{d}/c.cnf", w],
                           capture_output=True, text=True)
        out = r.stdout.strip().splitlines()
        if r.returncode != 0 or not out or " bad=0 " not in out[-1] + " ":
            return f"{w}: hyperedge check failed ({out[-1] if out else r.stderr.strip()[:80]})"
        with lzma.open(os.path.join(pdir, f"{w}_{e}.lrat.xz"), "rb") as src, open(f"{d}/p.lrat", "wb") as dst:
            shutil.copyfileobj(src, dst)
        r = subprocess.run([LRAT_CHECK, f"{d}/c.cnf", f"{d}/p.lrat"], capture_output=True, text=True)
        if r.returncode != 0 or not any(re.match(r"^c VERIFIED\s*$", s) for s in r.stdout.splitlines()):
            return f"{w}: lrat-check did not verify (exit {r.returncode})"
        r = subprocess.run([CAKE_LPR, f"--CML_HEAP_SIZE={HEAP}", "--CML_STACK_SIZE=500", f"{d}/c.cnf", f"{d}/p.lrat"],
                           capture_output=True, text=True)
        if r.returncode != 0 or not any(re.match(r"^s VERIFIED UNSAT\s*$", s) for s in r.stdout.splitlines()):
            return f"{w}: cake_lpr did not verify (exit {r.returncode})"
        return None
    finally:
        shutil.rmtree(d, ignore_errors=True)

ex = ThreadPoolExecutor(max_workers=jobs)
futs = [ex.submit(check, w) for w in expected]
for i, fu in enumerate(futs, 1):
    res = fu.result()
    if res:
        ex.shutdown(wait=True, cancel_futures=True)
        fail(res)
    if i % 500 == 0:
        print(f"  ... {i}/{len(expected)}", flush=True)
ex.shutdown(wait=True)
print(f"  PASS l={l} e={e} n={n}: {len(surv)} survivors + {len(j1)} one-minority windows = {len(expected)} "
      f"certificates (mkcnfw bad=0, lrat-check, cake_lpr)")
