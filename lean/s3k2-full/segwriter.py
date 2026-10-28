"""Shared writer: LRAT steps -> segmented Lean data files (PER segments per file) + Unsat module."""
def read_lrat(path):
    steps = []
    for line in open(path):
        p = line.split()
        if not p or p[1] == 'd': continue
        i = p.index('0', 1)
        lits = [int(x) for x in p[1:i]]; hints = [int(x) for x in p[i + 1:-1]]
        assert p[-1] == '0' and all(h > 0 for h in hints)
        steps.append((int(p[0]), [2 * abs(x) + (1 if x < 0 else 0) for x in lits], hints))
        if not lits: break
    return steps

def write(name, N, steps, SEG, PER, data_import, cnf_def, extra='', base_import='RSN.CaseCNF'):
    L = lambda xs: '[' + ', '.join(map(str, xs)) + ']'
    segs = [steps[i:i + SEG] for i in range(0, len(steps), SEG)]
    nfiles = (len(segs) + PER - 1) // PER
    for fi in range(nfiles):
        with open(f'RSN/Data/{N}Seg{fi}.lean', 'w') as f:
            f.write('module\n\npublic import RSN.Checker\n\nset_option maxRecDepth 100000\n\n@[expose] public section\n\nnamespace RSN\n\n')
            for kk in range(fi * PER, min((fi + 1) * PER, len(segs))):
                f.write(f'def {name}Seg{kk} : List Step := [\n' + ',\n'.join(f'  ⟨{a}, {L(b)}, {L(c)}⟩' for a, b, c in segs[kk]) + '\n]\n\n')
            f.write('end RSN\n')
    with open(f'RSN/{N}Unsat.lean', 'w') as f:
        f.write(f'module\n\npublic import {base_import}\npublic import RSN.Fast\npublic import {data_import}\n')
        for fi in range(nfiles): f.write(f'public import RSN.Data.{N}Seg{fi}\n')
        f.write(f'\n/-! # Kernel check of the LRAT proof for `{name}` (generated) -/\n\n@[expose] public section\n\nnamespace RSN\n\n')
        f.write(cnf_def + '\n\n')
        f.write(f'noncomputable def {name}Db0 : Trie := buildDBF {name}CNF .leaf 1\n')
        for kk in range(len(segs)):
            f.write(f'noncomputable def {name}Db{kk + 1} : Trie := insertStepsF {name}Seg{kk} {name}Db{kk}\n')
        for kk in range(len(segs)):
            f.write(f'theorem {name}Seg{kk}_ok : checkSegF {name}Seg{kk} {name}Db{kk} = true := by decide +kernel\n')
        names = ', '.join(f'{name}Seg{kk}' for kk in range(len(segs)))
        f.write(f'\ndef {name}Segs : List (List Step) := [{names}]\n\n')
        f.write(f'theorem {name}Segs_okF : SegsOKF {name}Db0 {name}Segs := by\n  simp only [{name}Segs, SegsOKF]\n')
        f.write('  exact ⟨' + ''.join(f'{name}Seg{kk}_ok, ' for kk in range(len(segs))) + 'trivial⟩\n\n')
        f.write(f'theorem {name}Segs_empty : {name}Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel\n\n')
        f.write(f'''/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem {name}_unsat (v : Nat → Bool) : ∃ c ∈ {name}CNF, clauseEval v c = false := by
  have h := segsOKF_iff {name}Segs {name}Db0 {name}Segs_okF
  rw [show {name}Db0 = buildDB .leaf 1 {name}CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs {name}CNF {name}Segs h {name}Segs_empty v
{extra}
end RSN
''')
    return len(segs), nfiles
