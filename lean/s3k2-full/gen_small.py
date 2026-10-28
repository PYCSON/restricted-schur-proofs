#!/usr/bin/env python3
# NOTE (public release): absolute paths of the original workspace were replaced by <TOOLS>/<REPO>/<WORKDIR>; this script was used to generate certificates and is not part of the verification chain.
"""Direct weak-family instance for a small k: vertices 1..F (vertex id = integer), edges (u, v, (k-1)u+v),
u != v, plus unit clause 'vertex 1 has colour 0'. Writes inputs/small_k{k}.cnf (caseCNF order), runs CaDiCaL
(LRAT), and generates Lean data + segment checks.  usage: gen_small.py k SEG"""
import sys, subprocess
k, SEG = int(sys.argv[1]), int(sys.argv[2])
F = k**3 + 3*k*k + 2*k - 2; m = k - 1
import json
CORE = set(json.load(open(f'inputs/core_k{k}.json')))   # vertex-minimal UNSAT core (core_small.py)
E = [(u, v, m*u + v) for u in range(1, F + 1) for v in range(1, F + 1)
     if u != v and m*u + v <= F and u in CORE and v in CORE and m*u + v in CORE]
var = lambda i, c: 3*(i - 1) + c + 1
cl = [[var(i, 0), var(i, 1), var(i, 2)] for i in range(1, F + 1)]
for (u, v, w) in E:
    for c in range(3): cl.append([-var(u, c), -var(v, c), -var(w, c)])
cl.append([var(1, 0)])
fn = f'inputs/small_k{k}.cnf'
open(fn, 'w').write(f'p cnf {3*F} {len(cl)}\n' + ''.join(' '.join(map(str, c)) + ' 0\n' for c in cl))
CAD = '<TOOLS>/cadical/build/cadical'
LC = '<TOOLS>/drat-trim/lrat-check'
out = subprocess.run([CAD, '-q', fn, f'inputs/small_k{k}.lrat', '--lrat=true', '--binary=false'], capture_output=True, text=True).stdout
res = [l for l in out.split('\n') if l.startswith('s ')]
chk = subprocess.run([LC, fn, f'inputs/small_k{k}.lrat'], capture_output=True, text=True).stdout
print('k', k, 'F', F, 'edges', len(E), res, [l for l in chk.split('\n') if 'VERIFIED' in l])
name = f'small{k}'; N = f'Small{k}'
L = lambda xs: '[' + ', '.join(map(str, xs)) + ']'
with open(f'RSN/Data/{N}.lean', 'w') as f:
    f.write('module\n\npublic import Init\n\nset_option maxRecDepth 100000\n\n@[expose] public section\n\nnamespace RSN\n\n')
    f.write(f'/-- The weak edges `(u, v, {m}u + v)`, `u ≠ v`, whose three vertices lie in a vertex-minimal UNSAT core inside `[1, {F}]` (k = {k}). -/\n')
    f.write(f'def {name}Edges : List (Nat × Nat × Nat) := [\n' + ',\n'.join(f'  ({u}, {v}, {w})' for u, v, w in E) + '\n]\n\nend RSN\n')
import segwriter
steps = segwriter.read_lrat(f'inputs/small_k{k}.lrat')
extra = f"""
theorem {name}_ids : idsInRange {F} {name}Edges [1] [] = true := by decide +kernel
theorem {name}_edges : edgesOK {k} {name}Edges = true := by decide +kernel

theorem {name}_case (c : Nat → Fin 3) (h1 : c 1 = 0) : WeakMono {k} (F {k}) c :=
  direct_case {k} {name}Edges (by decide) {name}_ids {name}_edges {name}_unsat c h1
"""
nseg, nf = segwriter.write(name, N, steps, SEG, 10, f'RSN.Data.{N}', f'def {name}CNF : List Clause := caseCNF {F} {name}Edges [1] []', extra, base_import='RSN.Direct')
print('steps', len(steps), 'segments', nseg, 'files', nf)
