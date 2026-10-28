module

public import RSN.Direct
public import RSN.Fast
public import RSN.Data.Small4
public import RSN.Data.Small4Seg0
public import RSN.Data.Small4Seg1
public import RSN.Data.Small4Seg2

/-! # Kernel check of the LRAT proof for `small4` (generated) -/

@[expose] public section

namespace RSN

def small4CNF : List Clause := caseCNF 118 small4Edges [1] []

noncomputable def small4Db0 : Trie := buildDBF small4CNF .leaf 1
noncomputable def small4Db1 : Trie := insertStepsF small4Seg0 small4Db0
noncomputable def small4Db2 : Trie := insertStepsF small4Seg1 small4Db1
noncomputable def small4Db3 : Trie := insertStepsF small4Seg2 small4Db2
noncomputable def small4Db4 : Trie := insertStepsF small4Seg3 small4Db3
noncomputable def small4Db5 : Trie := insertStepsF small4Seg4 small4Db4
noncomputable def small4Db6 : Trie := insertStepsF small4Seg5 small4Db5
noncomputable def small4Db7 : Trie := insertStepsF small4Seg6 small4Db6
noncomputable def small4Db8 : Trie := insertStepsF small4Seg7 small4Db7
noncomputable def small4Db9 : Trie := insertStepsF small4Seg8 small4Db8
noncomputable def small4Db10 : Trie := insertStepsF small4Seg9 small4Db9
noncomputable def small4Db11 : Trie := insertStepsF small4Seg10 small4Db10
noncomputable def small4Db12 : Trie := insertStepsF small4Seg11 small4Db11
noncomputable def small4Db13 : Trie := insertStepsF small4Seg12 small4Db12
noncomputable def small4Db14 : Trie := insertStepsF small4Seg13 small4Db13
noncomputable def small4Db15 : Trie := insertStepsF small4Seg14 small4Db14
noncomputable def small4Db16 : Trie := insertStepsF small4Seg15 small4Db15
noncomputable def small4Db17 : Trie := insertStepsF small4Seg16 small4Db16
noncomputable def small4Db18 : Trie := insertStepsF small4Seg17 small4Db17
noncomputable def small4Db19 : Trie := insertStepsF small4Seg18 small4Db18
noncomputable def small4Db20 : Trie := insertStepsF small4Seg19 small4Db19
noncomputable def small4Db21 : Trie := insertStepsF small4Seg20 small4Db20
noncomputable def small4Db22 : Trie := insertStepsF small4Seg21 small4Db21
noncomputable def small4Db23 : Trie := insertStepsF small4Seg22 small4Db22
noncomputable def small4Db24 : Trie := insertStepsF small4Seg23 small4Db23
noncomputable def small4Db25 : Trie := insertStepsF small4Seg24 small4Db24
noncomputable def small4Db26 : Trie := insertStepsF small4Seg25 small4Db25
noncomputable def small4Db27 : Trie := insertStepsF small4Seg26 small4Db26
noncomputable def small4Db28 : Trie := insertStepsF small4Seg27 small4Db27
theorem small4Seg0_ok : checkSegF small4Seg0 small4Db0 = true := by decide +kernel
theorem small4Seg1_ok : checkSegF small4Seg1 small4Db1 = true := by decide +kernel
theorem small4Seg2_ok : checkSegF small4Seg2 small4Db2 = true := by decide +kernel
theorem small4Seg3_ok : checkSegF small4Seg3 small4Db3 = true := by decide +kernel
theorem small4Seg4_ok : checkSegF small4Seg4 small4Db4 = true := by decide +kernel
theorem small4Seg5_ok : checkSegF small4Seg5 small4Db5 = true := by decide +kernel
theorem small4Seg6_ok : checkSegF small4Seg6 small4Db6 = true := by decide +kernel
theorem small4Seg7_ok : checkSegF small4Seg7 small4Db7 = true := by decide +kernel
theorem small4Seg8_ok : checkSegF small4Seg8 small4Db8 = true := by decide +kernel
theorem small4Seg9_ok : checkSegF small4Seg9 small4Db9 = true := by decide +kernel
theorem small4Seg10_ok : checkSegF small4Seg10 small4Db10 = true := by decide +kernel
theorem small4Seg11_ok : checkSegF small4Seg11 small4Db11 = true := by decide +kernel
theorem small4Seg12_ok : checkSegF small4Seg12 small4Db12 = true := by decide +kernel
theorem small4Seg13_ok : checkSegF small4Seg13 small4Db13 = true := by decide +kernel
theorem small4Seg14_ok : checkSegF small4Seg14 small4Db14 = true := by decide +kernel
theorem small4Seg15_ok : checkSegF small4Seg15 small4Db15 = true := by decide +kernel
theorem small4Seg16_ok : checkSegF small4Seg16 small4Db16 = true := by decide +kernel
theorem small4Seg17_ok : checkSegF small4Seg17 small4Db17 = true := by decide +kernel
theorem small4Seg18_ok : checkSegF small4Seg18 small4Db18 = true := by decide +kernel
theorem small4Seg19_ok : checkSegF small4Seg19 small4Db19 = true := by decide +kernel
theorem small4Seg20_ok : checkSegF small4Seg20 small4Db20 = true := by decide +kernel
theorem small4Seg21_ok : checkSegF small4Seg21 small4Db21 = true := by decide +kernel
theorem small4Seg22_ok : checkSegF small4Seg22 small4Db22 = true := by decide +kernel
theorem small4Seg23_ok : checkSegF small4Seg23 small4Db23 = true := by decide +kernel
theorem small4Seg24_ok : checkSegF small4Seg24 small4Db24 = true := by decide +kernel
theorem small4Seg25_ok : checkSegF small4Seg25 small4Db25 = true := by decide +kernel
theorem small4Seg26_ok : checkSegF small4Seg26 small4Db26 = true := by decide +kernel
theorem small4Seg27_ok : checkSegF small4Seg27 small4Db27 = true := by decide +kernel

def small4Segs : List (List Step) := [small4Seg0, small4Seg1, small4Seg2, small4Seg3, small4Seg4, small4Seg5, small4Seg6, small4Seg7, small4Seg8, small4Seg9, small4Seg10, small4Seg11, small4Seg12, small4Seg13, small4Seg14, small4Seg15, small4Seg16, small4Seg17, small4Seg18, small4Seg19, small4Seg20, small4Seg21, small4Seg22, small4Seg23, small4Seg24, small4Seg25, small4Seg26, small4Seg27]

theorem small4Segs_okF : SegsOKF small4Db0 small4Segs := by
  simp only [small4Segs, SegsOKF]
  exact ⟨small4Seg0_ok, small4Seg1_ok, small4Seg2_ok, small4Seg3_ok, small4Seg4_ok, small4Seg5_ok, small4Seg6_ok, small4Seg7_ok, small4Seg8_ok, small4Seg9_ok, small4Seg10_ok, small4Seg11_ok, small4Seg12_ok, small4Seg13_ok, small4Seg14_ok, small4Seg15_ok, small4Seg16_ok, small4Seg17_ok, small4Seg18_ok, small4Seg19_ok, small4Seg20_ok, small4Seg21_ok, small4Seg22_ok, small4Seg23_ok, small4Seg24_ok, small4Seg25_ok, small4Seg26_ok, small4Seg27_ok, trivial⟩

theorem small4Segs_empty : small4Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem small4_unsat (v : Nat → Bool) : ∃ c ∈ small4CNF, clauseEval v c = false := by
  have h := segsOKF_iff small4Segs small4Db0 small4Segs_okF
  rw [show small4Db0 = buildDB .leaf 1 small4CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs small4CNF small4Segs h small4Segs_empty v

theorem small4_ids : idsInRange 118 small4Edges [1] [] = true := by decide +kernel
theorem small4_edges : edgesOK 4 small4Edges = true := by decide +kernel

theorem small4_case (c : Nat → Fin 3) (h1 : c 1 = 0) : WeakMono 4 (F 4) c :=
  direct_case 4 small4Edges (by decide) small4_ids small4_edges small4_unsat c h1

end RSN
