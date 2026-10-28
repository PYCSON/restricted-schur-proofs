module

public import RSN.CaseCNF
public import RSN.Fast
public import RSN.Data.Top0
public import RSN.Data.Top0Seg0

/-! # Kernel check of the LRAT proof for `top0` (generated) -/

@[expose] public section

namespace RSN

def top0CNF : List Clause := caseCNF top0N top0Edges top0Reds top0Blues

noncomputable def top0Db0 : Trie := buildDBF top0CNF .leaf 1
noncomputable def top0Db1 : Trie := insertStepsF top0Seg0 top0Db0
noncomputable def top0Db2 : Trie := insertStepsF top0Seg1 top0Db1
noncomputable def top0Db3 : Trie := insertStepsF top0Seg2 top0Db2
noncomputable def top0Db4 : Trie := insertStepsF top0Seg3 top0Db3
theorem top0Seg0_ok : checkSegF top0Seg0 top0Db0 = true := by decide +kernel
theorem top0Seg1_ok : checkSegF top0Seg1 top0Db1 = true := by decide +kernel
theorem top0Seg2_ok : checkSegF top0Seg2 top0Db2 = true := by decide +kernel
theorem top0Seg3_ok : checkSegF top0Seg3 top0Db3 = true := by decide +kernel

def top0Segs : List (List Step) := [top0Seg0, top0Seg1, top0Seg2, top0Seg3]

theorem top0Segs_okF : SegsOKF top0Db0 top0Segs := by
  simp only [top0Segs, SegsOKF]
  exact ⟨top0Seg0_ok, top0Seg1_ok, top0Seg2_ok, top0Seg3_ok, trivial⟩

theorem top0Segs_empty : top0Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem top0_unsat (v : Nat → Bool) : ∃ c ∈ top0CNF, clauseEval v c = false := by
  have h := segsOKF_iff top0Segs top0Db0 top0Segs_okF
  rw [show top0Db0 = buildDB .leaf 1 top0CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs top0CNF top0Segs h top0Segs_empty v

end RSN
