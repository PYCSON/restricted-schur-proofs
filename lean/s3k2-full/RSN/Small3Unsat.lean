module

public import RSN.Direct
public import RSN.Fast
public import RSN.Data.Small3
public import RSN.Data.Small3Seg0
public import RSN.Data.Small3Seg1

/-! # Kernel check of the LRAT proof for `small3` (generated) -/

@[expose] public section

namespace RSN

def small3CNF : List Clause := caseCNF 58 small3Edges [1] []

noncomputable def small3Db0 : Trie := buildDBF small3CNF .leaf 1
noncomputable def small3Db1 : Trie := insertStepsF small3Seg0 small3Db0
noncomputable def small3Db2 : Trie := insertStepsF small3Seg1 small3Db1
noncomputable def small3Db3 : Trie := insertStepsF small3Seg2 small3Db2
noncomputable def small3Db4 : Trie := insertStepsF small3Seg3 small3Db3
noncomputable def small3Db5 : Trie := insertStepsF small3Seg4 small3Db4
noncomputable def small3Db6 : Trie := insertStepsF small3Seg5 small3Db5
noncomputable def small3Db7 : Trie := insertStepsF small3Seg6 small3Db6
noncomputable def small3Db8 : Trie := insertStepsF small3Seg7 small3Db7
noncomputable def small3Db9 : Trie := insertStepsF small3Seg8 small3Db8
noncomputable def small3Db10 : Trie := insertStepsF small3Seg9 small3Db9
noncomputable def small3Db11 : Trie := insertStepsF small3Seg10 small3Db10
noncomputable def small3Db12 : Trie := insertStepsF small3Seg11 small3Db11
noncomputable def small3Db13 : Trie := insertStepsF small3Seg12 small3Db12
noncomputable def small3Db14 : Trie := insertStepsF small3Seg13 small3Db13
theorem small3Seg0_ok : checkSegF small3Seg0 small3Db0 = true := by decide +kernel
theorem small3Seg1_ok : checkSegF small3Seg1 small3Db1 = true := by decide +kernel
theorem small3Seg2_ok : checkSegF small3Seg2 small3Db2 = true := by decide +kernel
theorem small3Seg3_ok : checkSegF small3Seg3 small3Db3 = true := by decide +kernel
theorem small3Seg4_ok : checkSegF small3Seg4 small3Db4 = true := by decide +kernel
theorem small3Seg5_ok : checkSegF small3Seg5 small3Db5 = true := by decide +kernel
theorem small3Seg6_ok : checkSegF small3Seg6 small3Db6 = true := by decide +kernel
theorem small3Seg7_ok : checkSegF small3Seg7 small3Db7 = true := by decide +kernel
theorem small3Seg8_ok : checkSegF small3Seg8 small3Db8 = true := by decide +kernel
theorem small3Seg9_ok : checkSegF small3Seg9 small3Db9 = true := by decide +kernel
theorem small3Seg10_ok : checkSegF small3Seg10 small3Db10 = true := by decide +kernel
theorem small3Seg11_ok : checkSegF small3Seg11 small3Db11 = true := by decide +kernel
theorem small3Seg12_ok : checkSegF small3Seg12 small3Db12 = true := by decide +kernel
theorem small3Seg13_ok : checkSegF small3Seg13 small3Db13 = true := by decide +kernel

def small3Segs : List (List Step) := [small3Seg0, small3Seg1, small3Seg2, small3Seg3, small3Seg4, small3Seg5, small3Seg6, small3Seg7, small3Seg8, small3Seg9, small3Seg10, small3Seg11, small3Seg12, small3Seg13]

theorem small3Segs_okF : SegsOKF small3Db0 small3Segs := by
  simp only [small3Segs, SegsOKF]
  exact ⟨small3Seg0_ok, small3Seg1_ok, small3Seg2_ok, small3Seg3_ok, small3Seg4_ok, small3Seg5_ok, small3Seg6_ok, small3Seg7_ok, small3Seg8_ok, small3Seg9_ok, small3Seg10_ok, small3Seg11_ok, small3Seg12_ok, small3Seg13_ok, trivial⟩

theorem small3Segs_empty : small3Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem small3_unsat (v : Nat → Bool) : ∃ c ∈ small3CNF, clauseEval v c = false := by
  have h := segsOKF_iff small3Segs small3Db0 small3Segs_okF
  rw [show small3Db0 = buildDB .leaf 1 small3CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs small3CNF small3Segs h small3Segs_empty v

theorem small3_ids : idsInRange 58 small3Edges [1] [] = true := by decide +kernel
theorem small3_edges : edgesOK 3 small3Edges = true := by decide +kernel

theorem small3_case (c : Nat → Fin 3) (h1 : c 1 = 0) : WeakMono 3 (F 3) c :=
  direct_case 3 small3Edges (by decide) small3_ids small3_edges small3_unsat c h1

end RSN
