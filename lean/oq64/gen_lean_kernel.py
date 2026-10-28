#!/usr/bin/env python3
# NOTE (public release): absolute paths of the original workspace were replaced by <TOOLS>/<REPO>/<WORKDIR>; this script was used to generate certificates and is not part of the verification chain.
"""Generate Lean data + proof modules for one kernel certificate.
usage: gen_lean_kernel.py NAME cert.json cert.lrat [SEG] [EDGECHUNK]
Writes OQ64/Data/<Name>.lean (V, E, F, u, k0, k1), OQ64/Data/<Name>Seg*.lean (LRAT steps),
OQ64/<Name>.lean (edge checks, unsat, final theorem)."""
import sys, json
sys.path.insert(0, '<WORKDIR>/rsnlean')
name, cf, lrat = sys.argv[1], sys.argv[2], sys.argv[3]
SEG = int(sys.argv[4]) if len(sys.argv) > 4 else 200
CH = int(sys.argv[5]) if len(sys.argv) > 5 else 200
N = name[0].upper() + name[1:]
C = json.load(open(cf))
l, k0 = C['l'], C['k0']
V = [list(v) for v in C['vertices']]
Fp = list(C['F'])
u = C['unit_red']
E = C['edges']
FX = C.get('F_extra', 0)
FTXT = f'F(k,{l}) + {FX}' if FX else f'F(k,{l})'

def peval(p, x):
    r = 0
    for c in reversed(p): r = c + x * r
    return r
def pshift(p, s):
    # coefficients of p(s+t)
    out = [0] * len(p)
    from math import comb
    for j, cj in enumerate(p):
        for i in range(j + 1): out[i] += cj * comb(j, i) * s ** (j - i)
    return out
def poscheck(p, k1):
    q = pshift(p, k1)
    if not q or q[0] <= 0 or any(x < 0 for x in q[1:]): return False
    return all(peval(p, k) > 0 for k in range(k0, k1))
def psub(p, q):
    n = max(len(p), len(q)); return [(p[i] if i < len(p) else 0) - (q[i] if i < len(q) else 0) for i in range(n)]
def needed(k1):
    for e in E:
        a = V[e['a']]; w = V[e['w']]; os = [V[o] for m, o in e['others']]
        if not poscheck(a, k1) or not all(poscheck(o, k1) for o in os): return False
        Fw = psub(Fp, w); Fw[0] += 1
        if not poscheck(Fw, k1): return False
        S = [a] + os
        for i in range(len(S)):
            for j in range(i + 1, len(S)):
                if not (poscheck(psub(S[i], S[j]), k1) or poscheck(psub(S[j], S[i]), k1)): return False
    return True
k1 = k0
while not needed(k1):
    k1 += 1
    assert k1 < k0 + 2000, "no k1 found"
print('k1 =', k1)
L = lambda xs: '[' + ', '.join(map(str, xs)) + ']'
def ilist(p): return '[' + ', '.join(f'({x} : Int)' if x < 0 else str(x) for x in p) + ']'
PERF = 8   # chunks per data file
chunks = [E[i:i + CH] for i in range(0, len(E), CH)]
def ev(e): return [e['a']] + [o for m, o in e['others']] + [e['w']]
with open(f'OQ64/Data/{N}.lean', 'w') as f:
    f.write('module\n\npublic import OQ64.Kernel\n\nset_option maxRecDepth 100000\n\n@[expose] public section\n\nnamespace OQ64\n\n')
    f.write(f'/-- Kernel for ℓ = {l}, region k ≥ {k0} (generated from {cf.split("/")[-1]}). Vertex `i` = entry `i`, coefficients of `c0 + c1 k + c2 k^2`. -/\n')
    f.write(f'def {name}V : List (List Int) := [\n' + ',\n'.join('  ' + ilist(v) for v in V) + '\n]\n\n')
    f.write(f'def {name}F : List Int := {ilist(Fp)}\n\ndef {name}u : Nat := {u}\n\n')
    f.write('end OQ64\n')
ndf = (len(chunks) + PERF - 1) // PERF
for fi in range(ndf):
    with open(f'OQ64/Data/{N}D{fi}.lean', 'w') as f:
        f.write('module\n\npublic import OQ64.Kernel\n\nset_option maxRecDepth 100000\n\n@[expose] public section\n\nnamespace OQ64\n\n')
        for ci in range(fi * PERF, min((fi + 1) * PERF, len(chunks))):
            ch = chunks[ci]
            f.write(f'def {name}E{ci} : List Edge := [\n' + ',\n'.join(
                f"  ⟨{e['a']}, {e['c']}, {L([f'({m}, {o})' for m, o in e['others']])}, {e['w']}⟩" for e in ch) + '\n]\n\n')
            cls = []
            for e in ch:
                vs = ev(e)
                cls.append([2*(x+1)+1 for x in vs]); cls.append([2*(x+1) for x in vs])
            f.write(f'def {name}C{ci} : List RSN.Clause := [\n' + ',\n'.join('  ' + L(c) for c in cls) + '\n]\n\n')
        f.write('end OQ64\n')
with open(f'OQ64/Data/{N}All.lean', 'w') as f:
    f.write('module\n\npublic import OQ64.Kernel\n')
    for fi in range(ndf): f.write(f'public import OQ64.Data.{N}D{fi}\n')
    f.write('\n@[expose] public section\n\nnamespace OQ64\n\n')
    f.write(f'def {name}Es : List (List Edge) := [' + ', '.join(f'{name}E{ci}' for ci in range(len(chunks))) + ']\n\n')
    f.write(f'def {name}Cs : List (List RSN.Clause) := [' + ', '.join(f'{name}C{ci}' for ci in range(len(chunks))) + ']\n\n')
    f.write('end OQ64\n')
import segwriter
steps = segwriter.read_lrat(lrat)
segs = [steps[i:i + SEG] for i in range(0, len(steps), SEG)]
PER = 10
nfiles = (len(segs) + PER - 1) // PER
for fi in range(nfiles):
    with open(f'OQ64/Data/{N}Seg{fi}.lean', 'w') as f:
        f.write('module\n\npublic import RSN.Checker\n\nset_option maxRecDepth 100000\n\n@[expose] public section\n\nnamespace OQ64\nopen RSN\n\n')
        for kk in range(fi * PER, min((fi + 1) * PER, len(segs))):
            f.write(f'def {name}Seg{kk} : List Step := [\n' + ',\n'.join(f'  ⟨{a}, {L(b)}, {L(c)}⟩' for a, b, c in segs[kk]) + '\n]\n\n')
        f.write('end OQ64\n')
with open(f'OQ64/{N}.lean', 'w') as f:
    f.write(f'module\n\npublic import OQ64.Kernel\npublic import RSN.Fast\npublic import OQ64.Data.{N}\npublic import OQ64.Data.{N}All\n')
    for fi in range(nfiles): f.write(f'public import OQ64.Data.{N}Seg{fi}\n')
    nch = len(chunks)
    f.write(f'''
/-! # ℓ = {l}: S₂(k;{l}) ≤ {FTXT} for every k ≥ {k0} (generated by gen_lean_kernel.py) -/

@[expose] public section

namespace OQ64
open RSN

''')
    for ci in range(nch):
        f.write(f'theorem {name}E{ci}_ok : {name}E{ci}.all (edgeOK {l} {k0} {k1} {name}V {name}F) = true := by decide +kernel\n')
    alts = ' | '.join(['rfl'] * nch)
    f.write(f'''
theorem {name}E_ok : {name}Es.flatten.all (edgeOK {l} {k0} {k1} {name}V {name}F) = true := by
  rw [List.all_eq_true]
  intro e he
  simp only [List.mem_flatten, {name}Es, List.mem_cons, List.not_mem_nil, or_false] at he
  obtain ⟨L, hL, heL⟩ := he
  rcases hL with {alts}
''')
    for ci in range(nch):
        f.write(f'  · exact List.all_eq_true.1 {name}E{ci}_ok e heL\n')
    f.write('\n')
    for ci in range(nch):
        f.write(f'theorem {name}C{ci}_eq : edgeClauses {name}E{ci} = {name}C{ci} := by decide +kernel\n')
    f.write(f'''
theorem {name}map_eq : {name}Es.map edgeClauses = {name}Cs := by
  simp only [{name}Es, {name}Cs, List.map_cons, List.map_nil{''.join(f", {name}C{ci}_eq" for ci in range(nch))}]

def {name}Chunks : List (List Clause) := [[2 * ({name}u + 1)]] :: {name}Cs

def {name}CNF : List Clause := {name}Chunks.flatten

noncomputable def {name}Db0 : Trie := buildChunksF {name}Chunks .leaf 1

theorem {name}Db0_eq : {name}Db0 = buildDB .leaf 1 {name}CNF := by
  rw [{name}Db0, buildChunksF_eq, buildChunks_eq]
  rfl

''')
    for kk in range(len(segs)):
        f.write(f'noncomputable def {name}Db{kk + 1} : Trie := insertStepsF {name}Seg{kk} {name}Db{kk}\n')
    for kk in range(len(segs)):
        f.write(f'theorem {name}Seg{kk}_ok : checkSegF {name}Seg{kk} {name}Db{kk} = true := by decide +kernel\n')
    names = ', '.join(f'{name}Seg{kk}' for kk in range(len(segs)))
    f.write(f'\ndef {name}Segs : List (List Step) := [{names}]\n\n')
    f.write(f'theorem {name}Segs_okF : SegsOKF {name}Db0 {name}Segs := by\n  simp only [{name}Segs, SegsOKF]\n')
    f.write('  exact ⟨' + ''.join(f'{name}Seg{kk}_ok, ' for kk in range(len(segs))) + 'trivial⟩\n\n')
    f.write(f'theorem {name}Segs_empty : {name}Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel\n\n')
    f.write(f'''theorem {name}_unsat (v : Nat → Bool) : ∃ c ∈ kernelCNF {name}u {name}Es.flatten, clauseEval v c = false := by
  have h := segsOKF_iff {name}Segs {name}Db0 {name}Segs_okF
  rw [{name}Db0_eq] at h
  have h2 := unsat_of_segs {name}CNF {name}Segs h {name}Segs_empty v
  rw [kernelCNF_chunks {name}u {name}Es {name}Cs {name}map_eq]
  exact h2

theorem {name}_u : vtx {name}V {name}u = [1, 0, 0] := by decide

/-- **ℓ = {l}.** For every `k ≥ {k0}`, every 2-colouring of `[1, {FTXT}]` (`natv {name}F k = {FTXT}`) has a monochromatic solution of
`x₁ + ⋯ + x_k = x_{{k+1}}` with exactly {l + 1} distinct integers. -/
theorem {name}_upper (k : Nat) (hk : {k0} ≤ k) (c : Nat → Bool) : ExactSol k {l} (natv {name}F k) c :=
  kernel_upper {l} {k0} {k1} {name}V {name}Es.flatten {name}F {name}u {name}_u {name}E_ok {name}_unsat k hk c

end OQ64
''')
print(f'{name}: vertices={len(V)} edges={len(E)} chunks={len(chunks)} lrat steps={len(steps)} segments={len(segs)} files={nfiles} k1={k1}')
