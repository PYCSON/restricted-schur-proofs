module

public import RSN.Direct
public import RSN.Fast
public import RSN.Data.Small5
public import RSN.Data.Small5Seg0
public import RSN.Data.Small5Seg1
public import RSN.Data.Small5Seg2
public import RSN.Data.Small5Seg3
public import RSN.Data.Small5Seg4
public import RSN.Data.Small5Seg5

/-! # Kernel check of the LRAT proof for `small5` (generated) -/

@[expose] public section

namespace RSN

def small5CNF : List Clause := caseCNF 208 small5Edges [1] []

noncomputable def small5Db0 : Trie := buildDBF small5CNF .leaf 1
noncomputable def small5Db1 : Trie := insertStepsF small5Seg0 small5Db0
noncomputable def small5Db2 : Trie := insertStepsF small5Seg1 small5Db1
noncomputable def small5Db3 : Trie := insertStepsF small5Seg2 small5Db2
noncomputable def small5Db4 : Trie := insertStepsF small5Seg3 small5Db3
noncomputable def small5Db5 : Trie := insertStepsF small5Seg4 small5Db4
noncomputable def small5Db6 : Trie := insertStepsF small5Seg5 small5Db5
noncomputable def small5Db7 : Trie := insertStepsF small5Seg6 small5Db6
noncomputable def small5Db8 : Trie := insertStepsF small5Seg7 small5Db7
noncomputable def small5Db9 : Trie := insertStepsF small5Seg8 small5Db8
noncomputable def small5Db10 : Trie := insertStepsF small5Seg9 small5Db9
noncomputable def small5Db11 : Trie := insertStepsF small5Seg10 small5Db10
noncomputable def small5Db12 : Trie := insertStepsF small5Seg11 small5Db11
noncomputable def small5Db13 : Trie := insertStepsF small5Seg12 small5Db12
noncomputable def small5Db14 : Trie := insertStepsF small5Seg13 small5Db13
noncomputable def small5Db15 : Trie := insertStepsF small5Seg14 small5Db14
noncomputable def small5Db16 : Trie := insertStepsF small5Seg15 small5Db15
noncomputable def small5Db17 : Trie := insertStepsF small5Seg16 small5Db16
noncomputable def small5Db18 : Trie := insertStepsF small5Seg17 small5Db17
noncomputable def small5Db19 : Trie := insertStepsF small5Seg18 small5Db18
noncomputable def small5Db20 : Trie := insertStepsF small5Seg19 small5Db19
noncomputable def small5Db21 : Trie := insertStepsF small5Seg20 small5Db20
noncomputable def small5Db22 : Trie := insertStepsF small5Seg21 small5Db21
noncomputable def small5Db23 : Trie := insertStepsF small5Seg22 small5Db22
noncomputable def small5Db24 : Trie := insertStepsF small5Seg23 small5Db23
noncomputable def small5Db25 : Trie := insertStepsF small5Seg24 small5Db24
noncomputable def small5Db26 : Trie := insertStepsF small5Seg25 small5Db25
noncomputable def small5Db27 : Trie := insertStepsF small5Seg26 small5Db26
noncomputable def small5Db28 : Trie := insertStepsF small5Seg27 small5Db27
noncomputable def small5Db29 : Trie := insertStepsF small5Seg28 small5Db28
noncomputable def small5Db30 : Trie := insertStepsF small5Seg29 small5Db29
noncomputable def small5Db31 : Trie := insertStepsF small5Seg30 small5Db30
noncomputable def small5Db32 : Trie := insertStepsF small5Seg31 small5Db31
noncomputable def small5Db33 : Trie := insertStepsF small5Seg32 small5Db32
noncomputable def small5Db34 : Trie := insertStepsF small5Seg33 small5Db33
noncomputable def small5Db35 : Trie := insertStepsF small5Seg34 small5Db34
noncomputable def small5Db36 : Trie := insertStepsF small5Seg35 small5Db35
noncomputable def small5Db37 : Trie := insertStepsF small5Seg36 small5Db36
noncomputable def small5Db38 : Trie := insertStepsF small5Seg37 small5Db37
noncomputable def small5Db39 : Trie := insertStepsF small5Seg38 small5Db38
noncomputable def small5Db40 : Trie := insertStepsF small5Seg39 small5Db39
noncomputable def small5Db41 : Trie := insertStepsF small5Seg40 small5Db40
noncomputable def small5Db42 : Trie := insertStepsF small5Seg41 small5Db41
noncomputable def small5Db43 : Trie := insertStepsF small5Seg42 small5Db42
noncomputable def small5Db44 : Trie := insertStepsF small5Seg43 small5Db43
noncomputable def small5Db45 : Trie := insertStepsF small5Seg44 small5Db44
noncomputable def small5Db46 : Trie := insertStepsF small5Seg45 small5Db45
noncomputable def small5Db47 : Trie := insertStepsF small5Seg46 small5Db46
noncomputable def small5Db48 : Trie := insertStepsF small5Seg47 small5Db47
noncomputable def small5Db49 : Trie := insertStepsF small5Seg48 small5Db48
noncomputable def small5Db50 : Trie := insertStepsF small5Seg49 small5Db49
noncomputable def small5Db51 : Trie := insertStepsF small5Seg50 small5Db50
theorem small5Seg0_ok : checkSegF small5Seg0 small5Db0 = true := by decide +kernel
theorem small5Seg1_ok : checkSegF small5Seg1 small5Db1 = true := by decide +kernel
theorem small5Seg2_ok : checkSegF small5Seg2 small5Db2 = true := by decide +kernel
theorem small5Seg3_ok : checkSegF small5Seg3 small5Db3 = true := by decide +kernel
theorem small5Seg4_ok : checkSegF small5Seg4 small5Db4 = true := by decide +kernel
theorem small5Seg5_ok : checkSegF small5Seg5 small5Db5 = true := by decide +kernel
theorem small5Seg6_ok : checkSegF small5Seg6 small5Db6 = true := by decide +kernel
theorem small5Seg7_ok : checkSegF small5Seg7 small5Db7 = true := by decide +kernel
theorem small5Seg8_ok : checkSegF small5Seg8 small5Db8 = true := by decide +kernel
theorem small5Seg9_ok : checkSegF small5Seg9 small5Db9 = true := by decide +kernel
theorem small5Seg10_ok : checkSegF small5Seg10 small5Db10 = true := by decide +kernel
theorem small5Seg11_ok : checkSegF small5Seg11 small5Db11 = true := by decide +kernel
theorem small5Seg12_ok : checkSegF small5Seg12 small5Db12 = true := by decide +kernel
theorem small5Seg13_ok : checkSegF small5Seg13 small5Db13 = true := by decide +kernel
theorem small5Seg14_ok : checkSegF small5Seg14 small5Db14 = true := by decide +kernel
theorem small5Seg15_ok : checkSegF small5Seg15 small5Db15 = true := by decide +kernel
theorem small5Seg16_ok : checkSegF small5Seg16 small5Db16 = true := by decide +kernel
theorem small5Seg17_ok : checkSegF small5Seg17 small5Db17 = true := by decide +kernel
theorem small5Seg18_ok : checkSegF small5Seg18 small5Db18 = true := by decide +kernel
theorem small5Seg19_ok : checkSegF small5Seg19 small5Db19 = true := by decide +kernel
theorem small5Seg20_ok : checkSegF small5Seg20 small5Db20 = true := by decide +kernel
theorem small5Seg21_ok : checkSegF small5Seg21 small5Db21 = true := by decide +kernel
theorem small5Seg22_ok : checkSegF small5Seg22 small5Db22 = true := by decide +kernel
theorem small5Seg23_ok : checkSegF small5Seg23 small5Db23 = true := by decide +kernel
theorem small5Seg24_ok : checkSegF small5Seg24 small5Db24 = true := by decide +kernel
theorem small5Seg25_ok : checkSegF small5Seg25 small5Db25 = true := by decide +kernel
theorem small5Seg26_ok : checkSegF small5Seg26 small5Db26 = true := by decide +kernel
theorem small5Seg27_ok : checkSegF small5Seg27 small5Db27 = true := by decide +kernel
theorem small5Seg28_ok : checkSegF small5Seg28 small5Db28 = true := by decide +kernel
theorem small5Seg29_ok : checkSegF small5Seg29 small5Db29 = true := by decide +kernel
theorem small5Seg30_ok : checkSegF small5Seg30 small5Db30 = true := by decide +kernel
theorem small5Seg31_ok : checkSegF small5Seg31 small5Db31 = true := by decide +kernel
theorem small5Seg32_ok : checkSegF small5Seg32 small5Db32 = true := by decide +kernel
theorem small5Seg33_ok : checkSegF small5Seg33 small5Db33 = true := by decide +kernel
theorem small5Seg34_ok : checkSegF small5Seg34 small5Db34 = true := by decide +kernel
theorem small5Seg35_ok : checkSegF small5Seg35 small5Db35 = true := by decide +kernel
theorem small5Seg36_ok : checkSegF small5Seg36 small5Db36 = true := by decide +kernel
theorem small5Seg37_ok : checkSegF small5Seg37 small5Db37 = true := by decide +kernel
theorem small5Seg38_ok : checkSegF small5Seg38 small5Db38 = true := by decide +kernel
theorem small5Seg39_ok : checkSegF small5Seg39 small5Db39 = true := by decide +kernel
theorem small5Seg40_ok : checkSegF small5Seg40 small5Db40 = true := by decide +kernel
theorem small5Seg41_ok : checkSegF small5Seg41 small5Db41 = true := by decide +kernel
theorem small5Seg42_ok : checkSegF small5Seg42 small5Db42 = true := by decide +kernel
theorem small5Seg43_ok : checkSegF small5Seg43 small5Db43 = true := by decide +kernel
theorem small5Seg44_ok : checkSegF small5Seg44 small5Db44 = true := by decide +kernel
theorem small5Seg45_ok : checkSegF small5Seg45 small5Db45 = true := by decide +kernel
theorem small5Seg46_ok : checkSegF small5Seg46 small5Db46 = true := by decide +kernel
theorem small5Seg47_ok : checkSegF small5Seg47 small5Db47 = true := by decide +kernel
theorem small5Seg48_ok : checkSegF small5Seg48 small5Db48 = true := by decide +kernel
theorem small5Seg49_ok : checkSegF small5Seg49 small5Db49 = true := by decide +kernel
theorem small5Seg50_ok : checkSegF small5Seg50 small5Db50 = true := by decide +kernel

def small5Segs : List (List Step) := [small5Seg0, small5Seg1, small5Seg2, small5Seg3, small5Seg4, small5Seg5, small5Seg6, small5Seg7, small5Seg8, small5Seg9, small5Seg10, small5Seg11, small5Seg12, small5Seg13, small5Seg14, small5Seg15, small5Seg16, small5Seg17, small5Seg18, small5Seg19, small5Seg20, small5Seg21, small5Seg22, small5Seg23, small5Seg24, small5Seg25, small5Seg26, small5Seg27, small5Seg28, small5Seg29, small5Seg30, small5Seg31, small5Seg32, small5Seg33, small5Seg34, small5Seg35, small5Seg36, small5Seg37, small5Seg38, small5Seg39, small5Seg40, small5Seg41, small5Seg42, small5Seg43, small5Seg44, small5Seg45, small5Seg46, small5Seg47, small5Seg48, small5Seg49, small5Seg50]

theorem small5Segs_okF : SegsOKF small5Db0 small5Segs := by
  simp only [small5Segs, SegsOKF]
  exact ⟨small5Seg0_ok, small5Seg1_ok, small5Seg2_ok, small5Seg3_ok, small5Seg4_ok, small5Seg5_ok, small5Seg6_ok, small5Seg7_ok, small5Seg8_ok, small5Seg9_ok, small5Seg10_ok, small5Seg11_ok, small5Seg12_ok, small5Seg13_ok, small5Seg14_ok, small5Seg15_ok, small5Seg16_ok, small5Seg17_ok, small5Seg18_ok, small5Seg19_ok, small5Seg20_ok, small5Seg21_ok, small5Seg22_ok, small5Seg23_ok, small5Seg24_ok, small5Seg25_ok, small5Seg26_ok, small5Seg27_ok, small5Seg28_ok, small5Seg29_ok, small5Seg30_ok, small5Seg31_ok, small5Seg32_ok, small5Seg33_ok, small5Seg34_ok, small5Seg35_ok, small5Seg36_ok, small5Seg37_ok, small5Seg38_ok, small5Seg39_ok, small5Seg40_ok, small5Seg41_ok, small5Seg42_ok, small5Seg43_ok, small5Seg44_ok, small5Seg45_ok, small5Seg46_ok, small5Seg47_ok, small5Seg48_ok, small5Seg49_ok, small5Seg50_ok, trivial⟩

theorem small5Segs_empty : small5Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem small5_unsat (v : Nat → Bool) : ∃ c ∈ small5CNF, clauseEval v c = false := by
  have h := segsOKF_iff small5Segs small5Db0 small5Segs_okF
  rw [show small5Db0 = buildDB .leaf 1 small5CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs small5CNF small5Segs h small5Segs_empty v

theorem small5_ids : idsInRange 208 small5Edges [1] [] = true := by decide +kernel
theorem small5_edges : edgesOK 5 small5Edges = true := by decide +kernel

theorem small5_case (c : Nat → Fin 3) (h1 : c 1 = 0) : WeakMono 5 (F 5) c :=
  direct_case 5 small5Edges (by decide) small5_ids small5_edges small5_unsat c h1

end RSN
