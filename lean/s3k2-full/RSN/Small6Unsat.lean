module

public import RSN.Direct
public import RSN.Fast
public import RSN.Data.Small6
public import RSN.Data.Small6Seg0
public import RSN.Data.Small6Seg1
public import RSN.Data.Small6Seg2
public import RSN.Data.Small6Seg3
public import RSN.Data.Small6Seg4
public import RSN.Data.Small6Seg5
public import RSN.Data.Small6Seg6

/-! # Kernel check of the LRAT proof for `small6` (generated) -/

@[expose] public section

namespace RSN

def small6CNF : List Clause := caseCNF 334 small6Edges [1] []

noncomputable def small6Db0 : Trie := buildDBF small6CNF .leaf 1
noncomputable def small6Db1 : Trie := insertStepsF small6Seg0 small6Db0
noncomputable def small6Db2 : Trie := insertStepsF small6Seg1 small6Db1
noncomputable def small6Db3 : Trie := insertStepsF small6Seg2 small6Db2
noncomputable def small6Db4 : Trie := insertStepsF small6Seg3 small6Db3
noncomputable def small6Db5 : Trie := insertStepsF small6Seg4 small6Db4
noncomputable def small6Db6 : Trie := insertStepsF small6Seg5 small6Db5
noncomputable def small6Db7 : Trie := insertStepsF small6Seg6 small6Db6
noncomputable def small6Db8 : Trie := insertStepsF small6Seg7 small6Db7
noncomputable def small6Db9 : Trie := insertStepsF small6Seg8 small6Db8
noncomputable def small6Db10 : Trie := insertStepsF small6Seg9 small6Db9
noncomputable def small6Db11 : Trie := insertStepsF small6Seg10 small6Db10
noncomputable def small6Db12 : Trie := insertStepsF small6Seg11 small6Db11
noncomputable def small6Db13 : Trie := insertStepsF small6Seg12 small6Db12
noncomputable def small6Db14 : Trie := insertStepsF small6Seg13 small6Db13
noncomputable def small6Db15 : Trie := insertStepsF small6Seg14 small6Db14
noncomputable def small6Db16 : Trie := insertStepsF small6Seg15 small6Db15
noncomputable def small6Db17 : Trie := insertStepsF small6Seg16 small6Db16
noncomputable def small6Db18 : Trie := insertStepsF small6Seg17 small6Db17
noncomputable def small6Db19 : Trie := insertStepsF small6Seg18 small6Db18
noncomputable def small6Db20 : Trie := insertStepsF small6Seg19 small6Db19
noncomputable def small6Db21 : Trie := insertStepsF small6Seg20 small6Db20
noncomputable def small6Db22 : Trie := insertStepsF small6Seg21 small6Db21
noncomputable def small6Db23 : Trie := insertStepsF small6Seg22 small6Db22
noncomputable def small6Db24 : Trie := insertStepsF small6Seg23 small6Db23
noncomputable def small6Db25 : Trie := insertStepsF small6Seg24 small6Db24
noncomputable def small6Db26 : Trie := insertStepsF small6Seg25 small6Db25
noncomputable def small6Db27 : Trie := insertStepsF small6Seg26 small6Db26
noncomputable def small6Db28 : Trie := insertStepsF small6Seg27 small6Db27
noncomputable def small6Db29 : Trie := insertStepsF small6Seg28 small6Db28
noncomputable def small6Db30 : Trie := insertStepsF small6Seg29 small6Db29
noncomputable def small6Db31 : Trie := insertStepsF small6Seg30 small6Db30
noncomputable def small6Db32 : Trie := insertStepsF small6Seg31 small6Db31
noncomputable def small6Db33 : Trie := insertStepsF small6Seg32 small6Db32
noncomputable def small6Db34 : Trie := insertStepsF small6Seg33 small6Db33
noncomputable def small6Db35 : Trie := insertStepsF small6Seg34 small6Db34
noncomputable def small6Db36 : Trie := insertStepsF small6Seg35 small6Db35
noncomputable def small6Db37 : Trie := insertStepsF small6Seg36 small6Db36
noncomputable def small6Db38 : Trie := insertStepsF small6Seg37 small6Db37
noncomputable def small6Db39 : Trie := insertStepsF small6Seg38 small6Db38
noncomputable def small6Db40 : Trie := insertStepsF small6Seg39 small6Db39
noncomputable def small6Db41 : Trie := insertStepsF small6Seg40 small6Db40
noncomputable def small6Db42 : Trie := insertStepsF small6Seg41 small6Db41
noncomputable def small6Db43 : Trie := insertStepsF small6Seg42 small6Db42
noncomputable def small6Db44 : Trie := insertStepsF small6Seg43 small6Db43
noncomputable def small6Db45 : Trie := insertStepsF small6Seg44 small6Db44
noncomputable def small6Db46 : Trie := insertStepsF small6Seg45 small6Db45
noncomputable def small6Db47 : Trie := insertStepsF small6Seg46 small6Db46
noncomputable def small6Db48 : Trie := insertStepsF small6Seg47 small6Db47
noncomputable def small6Db49 : Trie := insertStepsF small6Seg48 small6Db48
noncomputable def small6Db50 : Trie := insertStepsF small6Seg49 small6Db49
noncomputable def small6Db51 : Trie := insertStepsF small6Seg50 small6Db50
noncomputable def small6Db52 : Trie := insertStepsF small6Seg51 small6Db51
noncomputable def small6Db53 : Trie := insertStepsF small6Seg52 small6Db52
noncomputable def small6Db54 : Trie := insertStepsF small6Seg53 small6Db53
noncomputable def small6Db55 : Trie := insertStepsF small6Seg54 small6Db54
noncomputable def small6Db56 : Trie := insertStepsF small6Seg55 small6Db55
noncomputable def small6Db57 : Trie := insertStepsF small6Seg56 small6Db56
noncomputable def small6Db58 : Trie := insertStepsF small6Seg57 small6Db57
noncomputable def small6Db59 : Trie := insertStepsF small6Seg58 small6Db58
noncomputable def small6Db60 : Trie := insertStepsF small6Seg59 small6Db59
noncomputable def small6Db61 : Trie := insertStepsF small6Seg60 small6Db60
theorem small6Seg0_ok : checkSegF small6Seg0 small6Db0 = true := by decide +kernel
theorem small6Seg1_ok : checkSegF small6Seg1 small6Db1 = true := by decide +kernel
theorem small6Seg2_ok : checkSegF small6Seg2 small6Db2 = true := by decide +kernel
theorem small6Seg3_ok : checkSegF small6Seg3 small6Db3 = true := by decide +kernel
theorem small6Seg4_ok : checkSegF small6Seg4 small6Db4 = true := by decide +kernel
theorem small6Seg5_ok : checkSegF small6Seg5 small6Db5 = true := by decide +kernel
theorem small6Seg6_ok : checkSegF small6Seg6 small6Db6 = true := by decide +kernel
theorem small6Seg7_ok : checkSegF small6Seg7 small6Db7 = true := by decide +kernel
theorem small6Seg8_ok : checkSegF small6Seg8 small6Db8 = true := by decide +kernel
theorem small6Seg9_ok : checkSegF small6Seg9 small6Db9 = true := by decide +kernel
theorem small6Seg10_ok : checkSegF small6Seg10 small6Db10 = true := by decide +kernel
theorem small6Seg11_ok : checkSegF small6Seg11 small6Db11 = true := by decide +kernel
theorem small6Seg12_ok : checkSegF small6Seg12 small6Db12 = true := by decide +kernel
theorem small6Seg13_ok : checkSegF small6Seg13 small6Db13 = true := by decide +kernel
theorem small6Seg14_ok : checkSegF small6Seg14 small6Db14 = true := by decide +kernel
theorem small6Seg15_ok : checkSegF small6Seg15 small6Db15 = true := by decide +kernel
theorem small6Seg16_ok : checkSegF small6Seg16 small6Db16 = true := by decide +kernel
theorem small6Seg17_ok : checkSegF small6Seg17 small6Db17 = true := by decide +kernel
theorem small6Seg18_ok : checkSegF small6Seg18 small6Db18 = true := by decide +kernel
theorem small6Seg19_ok : checkSegF small6Seg19 small6Db19 = true := by decide +kernel
theorem small6Seg20_ok : checkSegF small6Seg20 small6Db20 = true := by decide +kernel
theorem small6Seg21_ok : checkSegF small6Seg21 small6Db21 = true := by decide +kernel
theorem small6Seg22_ok : checkSegF small6Seg22 small6Db22 = true := by decide +kernel
theorem small6Seg23_ok : checkSegF small6Seg23 small6Db23 = true := by decide +kernel
theorem small6Seg24_ok : checkSegF small6Seg24 small6Db24 = true := by decide +kernel
theorem small6Seg25_ok : checkSegF small6Seg25 small6Db25 = true := by decide +kernel
theorem small6Seg26_ok : checkSegF small6Seg26 small6Db26 = true := by decide +kernel
theorem small6Seg27_ok : checkSegF small6Seg27 small6Db27 = true := by decide +kernel
theorem small6Seg28_ok : checkSegF small6Seg28 small6Db28 = true := by decide +kernel
theorem small6Seg29_ok : checkSegF small6Seg29 small6Db29 = true := by decide +kernel
theorem small6Seg30_ok : checkSegF small6Seg30 small6Db30 = true := by decide +kernel
theorem small6Seg31_ok : checkSegF small6Seg31 small6Db31 = true := by decide +kernel
theorem small6Seg32_ok : checkSegF small6Seg32 small6Db32 = true := by decide +kernel
theorem small6Seg33_ok : checkSegF small6Seg33 small6Db33 = true := by decide +kernel
theorem small6Seg34_ok : checkSegF small6Seg34 small6Db34 = true := by decide +kernel
theorem small6Seg35_ok : checkSegF small6Seg35 small6Db35 = true := by decide +kernel
theorem small6Seg36_ok : checkSegF small6Seg36 small6Db36 = true := by decide +kernel
theorem small6Seg37_ok : checkSegF small6Seg37 small6Db37 = true := by decide +kernel
theorem small6Seg38_ok : checkSegF small6Seg38 small6Db38 = true := by decide +kernel
theorem small6Seg39_ok : checkSegF small6Seg39 small6Db39 = true := by decide +kernel
theorem small6Seg40_ok : checkSegF small6Seg40 small6Db40 = true := by decide +kernel
theorem small6Seg41_ok : checkSegF small6Seg41 small6Db41 = true := by decide +kernel
theorem small6Seg42_ok : checkSegF small6Seg42 small6Db42 = true := by decide +kernel
theorem small6Seg43_ok : checkSegF small6Seg43 small6Db43 = true := by decide +kernel
theorem small6Seg44_ok : checkSegF small6Seg44 small6Db44 = true := by decide +kernel
theorem small6Seg45_ok : checkSegF small6Seg45 small6Db45 = true := by decide +kernel
theorem small6Seg46_ok : checkSegF small6Seg46 small6Db46 = true := by decide +kernel
theorem small6Seg47_ok : checkSegF small6Seg47 small6Db47 = true := by decide +kernel
theorem small6Seg48_ok : checkSegF small6Seg48 small6Db48 = true := by decide +kernel
theorem small6Seg49_ok : checkSegF small6Seg49 small6Db49 = true := by decide +kernel
theorem small6Seg50_ok : checkSegF small6Seg50 small6Db50 = true := by decide +kernel
theorem small6Seg51_ok : checkSegF small6Seg51 small6Db51 = true := by decide +kernel
theorem small6Seg52_ok : checkSegF small6Seg52 small6Db52 = true := by decide +kernel
theorem small6Seg53_ok : checkSegF small6Seg53 small6Db53 = true := by decide +kernel
theorem small6Seg54_ok : checkSegF small6Seg54 small6Db54 = true := by decide +kernel
theorem small6Seg55_ok : checkSegF small6Seg55 small6Db55 = true := by decide +kernel
theorem small6Seg56_ok : checkSegF small6Seg56 small6Db56 = true := by decide +kernel
theorem small6Seg57_ok : checkSegF small6Seg57 small6Db57 = true := by decide +kernel
theorem small6Seg58_ok : checkSegF small6Seg58 small6Db58 = true := by decide +kernel
theorem small6Seg59_ok : checkSegF small6Seg59 small6Db59 = true := by decide +kernel
theorem small6Seg60_ok : checkSegF small6Seg60 small6Db60 = true := by decide +kernel

def small6Segs : List (List Step) := [small6Seg0, small6Seg1, small6Seg2, small6Seg3, small6Seg4, small6Seg5, small6Seg6, small6Seg7, small6Seg8, small6Seg9, small6Seg10, small6Seg11, small6Seg12, small6Seg13, small6Seg14, small6Seg15, small6Seg16, small6Seg17, small6Seg18, small6Seg19, small6Seg20, small6Seg21, small6Seg22, small6Seg23, small6Seg24, small6Seg25, small6Seg26, small6Seg27, small6Seg28, small6Seg29, small6Seg30, small6Seg31, small6Seg32, small6Seg33, small6Seg34, small6Seg35, small6Seg36, small6Seg37, small6Seg38, small6Seg39, small6Seg40, small6Seg41, small6Seg42, small6Seg43, small6Seg44, small6Seg45, small6Seg46, small6Seg47, small6Seg48, small6Seg49, small6Seg50, small6Seg51, small6Seg52, small6Seg53, small6Seg54, small6Seg55, small6Seg56, small6Seg57, small6Seg58, small6Seg59, small6Seg60]

theorem small6Segs_okF : SegsOKF small6Db0 small6Segs := by
  simp only [small6Segs, SegsOKF]
  exact ⟨small6Seg0_ok, small6Seg1_ok, small6Seg2_ok, small6Seg3_ok, small6Seg4_ok, small6Seg5_ok, small6Seg6_ok, small6Seg7_ok, small6Seg8_ok, small6Seg9_ok, small6Seg10_ok, small6Seg11_ok, small6Seg12_ok, small6Seg13_ok, small6Seg14_ok, small6Seg15_ok, small6Seg16_ok, small6Seg17_ok, small6Seg18_ok, small6Seg19_ok, small6Seg20_ok, small6Seg21_ok, small6Seg22_ok, small6Seg23_ok, small6Seg24_ok, small6Seg25_ok, small6Seg26_ok, small6Seg27_ok, small6Seg28_ok, small6Seg29_ok, small6Seg30_ok, small6Seg31_ok, small6Seg32_ok, small6Seg33_ok, small6Seg34_ok, small6Seg35_ok, small6Seg36_ok, small6Seg37_ok, small6Seg38_ok, small6Seg39_ok, small6Seg40_ok, small6Seg41_ok, small6Seg42_ok, small6Seg43_ok, small6Seg44_ok, small6Seg45_ok, small6Seg46_ok, small6Seg47_ok, small6Seg48_ok, small6Seg49_ok, small6Seg50_ok, small6Seg51_ok, small6Seg52_ok, small6Seg53_ok, small6Seg54_ok, small6Seg55_ok, small6Seg56_ok, small6Seg57_ok, small6Seg58_ok, small6Seg59_ok, small6Seg60_ok, trivial⟩

theorem small6Segs_empty : small6Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem small6_unsat (v : Nat → Bool) : ∃ c ∈ small6CNF, clauseEval v c = false := by
  have h := segsOKF_iff small6Segs small6Db0 small6Segs_okF
  rw [show small6Db0 = buildDB .leaf 1 small6CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs small6CNF small6Segs h small6Segs_empty v

theorem small6_ids : idsInRange 334 small6Edges [1] [] = true := by decide +kernel
theorem small6_edges : edgesOK 6 small6Edges = true := by decide +kernel

theorem small6_case (c : Nat → Fin 3) (h1 : c 1 = 0) : WeakMono 6 (F 6) c :=
  direct_case 6 small6Edges (by decide) small6_ids small6_edges small6_unsat c h1

end RSN
