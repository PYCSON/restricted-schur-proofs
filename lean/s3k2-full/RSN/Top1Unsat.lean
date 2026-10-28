module

public import RSN.CaseCNF
public import RSN.Fast
public import RSN.Data.Top1
public import RSN.Data.Top1Seg0

/-! # Kernel check of the LRAT proof for `top1` (generated) -/

@[expose] public section

namespace RSN

def top1CNF : List Clause := caseCNF top1N top1Edges top1Reds top1Blues

noncomputable def top1Db0 : Trie := buildDBF top1CNF .leaf 1
noncomputable def top1Db1 : Trie := insertStepsF top1Seg0 top1Db0
noncomputable def top1Db2 : Trie := insertStepsF top1Seg1 top1Db1
noncomputable def top1Db3 : Trie := insertStepsF top1Seg2 top1Db2
noncomputable def top1Db4 : Trie := insertStepsF top1Seg3 top1Db3
noncomputable def top1Db5 : Trie := insertStepsF top1Seg4 top1Db4
noncomputable def top1Db6 : Trie := insertStepsF top1Seg5 top1Db5
theorem top1Seg0_ok : checkSegF top1Seg0 top1Db0 = true := by decide +kernel
theorem top1Seg1_ok : checkSegF top1Seg1 top1Db1 = true := by decide +kernel
theorem top1Seg2_ok : checkSegF top1Seg2 top1Db2 = true := by decide +kernel
theorem top1Seg3_ok : checkSegF top1Seg3 top1Db3 = true := by decide +kernel
theorem top1Seg4_ok : checkSegF top1Seg4 top1Db4 = true := by decide +kernel
theorem top1Seg5_ok : checkSegF top1Seg5 top1Db5 = true := by decide +kernel

def top1Segs : List (List Step) := [top1Seg0, top1Seg1, top1Seg2, top1Seg3, top1Seg4, top1Seg5]

theorem top1Segs_okF : SegsOKF top1Db0 top1Segs := by
  simp only [top1Segs, SegsOKF]
  exact ⟨top1Seg0_ok, top1Seg1_ok, top1Seg2_ok, top1Seg3_ok, top1Seg4_ok, top1Seg5_ok, trivial⟩

theorem top1Segs_empty : top1Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem top1_unsat (v : Nat → Bool) : ∃ c ∈ top1CNF, clauseEval v c = false := by
  have h := segsOKF_iff top1Segs top1Db0 top1Segs_okF
  rw [show top1Db0 = buildDB .leaf 1 top1CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs top1CNF top1Segs h top1Segs_empty v

end RSN
