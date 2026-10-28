module

public import RSN.CaseCNF
public import RSN.Fast
public import RSN.Data.Top2
public import RSN.Data.Top2Seg0
public import RSN.Data.Top2Seg1

/-! # Kernel check of the LRAT proof for `top2` (generated) -/

@[expose] public section

namespace RSN

def top2CNF : List Clause := caseCNF top2N top2Edges top2Reds top2Blues

noncomputable def top2Db0 : Trie := buildDBF top2CNF .leaf 1
noncomputable def top2Db1 : Trie := insertStepsF top2Seg0 top2Db0
noncomputable def top2Db2 : Trie := insertStepsF top2Seg1 top2Db1
noncomputable def top2Db3 : Trie := insertStepsF top2Seg2 top2Db2
noncomputable def top2Db4 : Trie := insertStepsF top2Seg3 top2Db3
noncomputable def top2Db5 : Trie := insertStepsF top2Seg4 top2Db4
noncomputable def top2Db6 : Trie := insertStepsF top2Seg5 top2Db5
noncomputable def top2Db7 : Trie := insertStepsF top2Seg6 top2Db6
noncomputable def top2Db8 : Trie := insertStepsF top2Seg7 top2Db7
noncomputable def top2Db9 : Trie := insertStepsF top2Seg8 top2Db8
noncomputable def top2Db10 : Trie := insertStepsF top2Seg9 top2Db9
noncomputable def top2Db11 : Trie := insertStepsF top2Seg10 top2Db10
noncomputable def top2Db12 : Trie := insertStepsF top2Seg11 top2Db11
noncomputable def top2Db13 : Trie := insertStepsF top2Seg12 top2Db12
noncomputable def top2Db14 : Trie := insertStepsF top2Seg13 top2Db13
theorem top2Seg0_ok : checkSegF top2Seg0 top2Db0 = true := by decide +kernel
theorem top2Seg1_ok : checkSegF top2Seg1 top2Db1 = true := by decide +kernel
theorem top2Seg2_ok : checkSegF top2Seg2 top2Db2 = true := by decide +kernel
theorem top2Seg3_ok : checkSegF top2Seg3 top2Db3 = true := by decide +kernel
theorem top2Seg4_ok : checkSegF top2Seg4 top2Db4 = true := by decide +kernel
theorem top2Seg5_ok : checkSegF top2Seg5 top2Db5 = true := by decide +kernel
theorem top2Seg6_ok : checkSegF top2Seg6 top2Db6 = true := by decide +kernel
theorem top2Seg7_ok : checkSegF top2Seg7 top2Db7 = true := by decide +kernel
theorem top2Seg8_ok : checkSegF top2Seg8 top2Db8 = true := by decide +kernel
theorem top2Seg9_ok : checkSegF top2Seg9 top2Db9 = true := by decide +kernel
theorem top2Seg10_ok : checkSegF top2Seg10 top2Db10 = true := by decide +kernel
theorem top2Seg11_ok : checkSegF top2Seg11 top2Db11 = true := by decide +kernel
theorem top2Seg12_ok : checkSegF top2Seg12 top2Db12 = true := by decide +kernel
theorem top2Seg13_ok : checkSegF top2Seg13 top2Db13 = true := by decide +kernel

def top2Segs : List (List Step) := [top2Seg0, top2Seg1, top2Seg2, top2Seg3, top2Seg4, top2Seg5, top2Seg6, top2Seg7, top2Seg8, top2Seg9, top2Seg10, top2Seg11, top2Seg12, top2Seg13]

theorem top2Segs_okF : SegsOKF top2Db0 top2Segs := by
  simp only [top2Segs, SegsOKF]
  exact ⟨top2Seg0_ok, top2Seg1_ok, top2Seg2_ok, top2Seg3_ok, top2Seg4_ok, top2Seg5_ok, top2Seg6_ok, top2Seg7_ok, top2Seg8_ok, top2Seg9_ok, top2Seg10_ok, top2Seg11_ok, top2Seg12_ok, top2Seg13_ok, trivial⟩

theorem top2Segs_empty : top2Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem top2_unsat (v : Nat → Bool) : ∃ c ∈ top2CNF, clauseEval v c = false := by
  have h := segsOKF_iff top2Segs top2Db0 top2Segs_okF
  rw [show top2Db0 = buildDB .leaf 1 top2CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs top2CNF top2Segs h top2Segs_empty v

end RSN
