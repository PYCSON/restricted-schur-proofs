module

public import RSN.CaseCNF
public import RSN.Fast
public import RSN.Data.Const2
public import RSN.Data.Const2Seg0
public import RSN.Data.Const2Seg1
public import RSN.Data.Const2Seg2
public import RSN.Data.Const2Seg3
public import RSN.Data.Const2Seg4

/-! # Kernel check of the LRAT proof for `const2` (generated) -/

@[expose] public section

namespace RSN

def const2CNF : List Clause := caseCNF const2N const2Edges const2Reds const2Blues

noncomputable def const2Db0 : Trie := buildDBF const2CNF .leaf 1
noncomputable def const2Db1 : Trie := insertStepsF const2Seg0 const2Db0
noncomputable def const2Db2 : Trie := insertStepsF const2Seg1 const2Db1
noncomputable def const2Db3 : Trie := insertStepsF const2Seg2 const2Db2
noncomputable def const2Db4 : Trie := insertStepsF const2Seg3 const2Db3
noncomputable def const2Db5 : Trie := insertStepsF const2Seg4 const2Db4
noncomputable def const2Db6 : Trie := insertStepsF const2Seg5 const2Db5
noncomputable def const2Db7 : Trie := insertStepsF const2Seg6 const2Db6
noncomputable def const2Db8 : Trie := insertStepsF const2Seg7 const2Db7
noncomputable def const2Db9 : Trie := insertStepsF const2Seg8 const2Db8
noncomputable def const2Db10 : Trie := insertStepsF const2Seg9 const2Db9
noncomputable def const2Db11 : Trie := insertStepsF const2Seg10 const2Db10
noncomputable def const2Db12 : Trie := insertStepsF const2Seg11 const2Db11
noncomputable def const2Db13 : Trie := insertStepsF const2Seg12 const2Db12
noncomputable def const2Db14 : Trie := insertStepsF const2Seg13 const2Db13
noncomputable def const2Db15 : Trie := insertStepsF const2Seg14 const2Db14
noncomputable def const2Db16 : Trie := insertStepsF const2Seg15 const2Db15
noncomputable def const2Db17 : Trie := insertStepsF const2Seg16 const2Db16
noncomputable def const2Db18 : Trie := insertStepsF const2Seg17 const2Db17
noncomputable def const2Db19 : Trie := insertStepsF const2Seg18 const2Db18
noncomputable def const2Db20 : Trie := insertStepsF const2Seg19 const2Db19
noncomputable def const2Db21 : Trie := insertStepsF const2Seg20 const2Db20
noncomputable def const2Db22 : Trie := insertStepsF const2Seg21 const2Db21
noncomputable def const2Db23 : Trie := insertStepsF const2Seg22 const2Db22
noncomputable def const2Db24 : Trie := insertStepsF const2Seg23 const2Db23
noncomputable def const2Db25 : Trie := insertStepsF const2Seg24 const2Db24
noncomputable def const2Db26 : Trie := insertStepsF const2Seg25 const2Db25
noncomputable def const2Db27 : Trie := insertStepsF const2Seg26 const2Db26
noncomputable def const2Db28 : Trie := insertStepsF const2Seg27 const2Db27
noncomputable def const2Db29 : Trie := insertStepsF const2Seg28 const2Db28
noncomputable def const2Db30 : Trie := insertStepsF const2Seg29 const2Db29
noncomputable def const2Db31 : Trie := insertStepsF const2Seg30 const2Db30
noncomputable def const2Db32 : Trie := insertStepsF const2Seg31 const2Db31
noncomputable def const2Db33 : Trie := insertStepsF const2Seg32 const2Db32
noncomputable def const2Db34 : Trie := insertStepsF const2Seg33 const2Db33
noncomputable def const2Db35 : Trie := insertStepsF const2Seg34 const2Db34
noncomputable def const2Db36 : Trie := insertStepsF const2Seg35 const2Db35
noncomputable def const2Db37 : Trie := insertStepsF const2Seg36 const2Db36
noncomputable def const2Db38 : Trie := insertStepsF const2Seg37 const2Db37
noncomputable def const2Db39 : Trie := insertStepsF const2Seg38 const2Db38
noncomputable def const2Db40 : Trie := insertStepsF const2Seg39 const2Db39
noncomputable def const2Db41 : Trie := insertStepsF const2Seg40 const2Db40
noncomputable def const2Db42 : Trie := insertStepsF const2Seg41 const2Db41
noncomputable def const2Db43 : Trie := insertStepsF const2Seg42 const2Db42
noncomputable def const2Db44 : Trie := insertStepsF const2Seg43 const2Db43
noncomputable def const2Db45 : Trie := insertStepsF const2Seg44 const2Db44
noncomputable def const2Db46 : Trie := insertStepsF const2Seg45 const2Db45
theorem const2Seg0_ok : checkSegF const2Seg0 const2Db0 = true := by decide +kernel
theorem const2Seg1_ok : checkSegF const2Seg1 const2Db1 = true := by decide +kernel
theorem const2Seg2_ok : checkSegF const2Seg2 const2Db2 = true := by decide +kernel
theorem const2Seg3_ok : checkSegF const2Seg3 const2Db3 = true := by decide +kernel
theorem const2Seg4_ok : checkSegF const2Seg4 const2Db4 = true := by decide +kernel
theorem const2Seg5_ok : checkSegF const2Seg5 const2Db5 = true := by decide +kernel
theorem const2Seg6_ok : checkSegF const2Seg6 const2Db6 = true := by decide +kernel
theorem const2Seg7_ok : checkSegF const2Seg7 const2Db7 = true := by decide +kernel
theorem const2Seg8_ok : checkSegF const2Seg8 const2Db8 = true := by decide +kernel
theorem const2Seg9_ok : checkSegF const2Seg9 const2Db9 = true := by decide +kernel
theorem const2Seg10_ok : checkSegF const2Seg10 const2Db10 = true := by decide +kernel
theorem const2Seg11_ok : checkSegF const2Seg11 const2Db11 = true := by decide +kernel
theorem const2Seg12_ok : checkSegF const2Seg12 const2Db12 = true := by decide +kernel
theorem const2Seg13_ok : checkSegF const2Seg13 const2Db13 = true := by decide +kernel
theorem const2Seg14_ok : checkSegF const2Seg14 const2Db14 = true := by decide +kernel
theorem const2Seg15_ok : checkSegF const2Seg15 const2Db15 = true := by decide +kernel
theorem const2Seg16_ok : checkSegF const2Seg16 const2Db16 = true := by decide +kernel
theorem const2Seg17_ok : checkSegF const2Seg17 const2Db17 = true := by decide +kernel
theorem const2Seg18_ok : checkSegF const2Seg18 const2Db18 = true := by decide +kernel
theorem const2Seg19_ok : checkSegF const2Seg19 const2Db19 = true := by decide +kernel
theorem const2Seg20_ok : checkSegF const2Seg20 const2Db20 = true := by decide +kernel
theorem const2Seg21_ok : checkSegF const2Seg21 const2Db21 = true := by decide +kernel
theorem const2Seg22_ok : checkSegF const2Seg22 const2Db22 = true := by decide +kernel
theorem const2Seg23_ok : checkSegF const2Seg23 const2Db23 = true := by decide +kernel
theorem const2Seg24_ok : checkSegF const2Seg24 const2Db24 = true := by decide +kernel
theorem const2Seg25_ok : checkSegF const2Seg25 const2Db25 = true := by decide +kernel
theorem const2Seg26_ok : checkSegF const2Seg26 const2Db26 = true := by decide +kernel
theorem const2Seg27_ok : checkSegF const2Seg27 const2Db27 = true := by decide +kernel
theorem const2Seg28_ok : checkSegF const2Seg28 const2Db28 = true := by decide +kernel
theorem const2Seg29_ok : checkSegF const2Seg29 const2Db29 = true := by decide +kernel
theorem const2Seg30_ok : checkSegF const2Seg30 const2Db30 = true := by decide +kernel
theorem const2Seg31_ok : checkSegF const2Seg31 const2Db31 = true := by decide +kernel
theorem const2Seg32_ok : checkSegF const2Seg32 const2Db32 = true := by decide +kernel
theorem const2Seg33_ok : checkSegF const2Seg33 const2Db33 = true := by decide +kernel
theorem const2Seg34_ok : checkSegF const2Seg34 const2Db34 = true := by decide +kernel
theorem const2Seg35_ok : checkSegF const2Seg35 const2Db35 = true := by decide +kernel
theorem const2Seg36_ok : checkSegF const2Seg36 const2Db36 = true := by decide +kernel
theorem const2Seg37_ok : checkSegF const2Seg37 const2Db37 = true := by decide +kernel
theorem const2Seg38_ok : checkSegF const2Seg38 const2Db38 = true := by decide +kernel
theorem const2Seg39_ok : checkSegF const2Seg39 const2Db39 = true := by decide +kernel
theorem const2Seg40_ok : checkSegF const2Seg40 const2Db40 = true := by decide +kernel
theorem const2Seg41_ok : checkSegF const2Seg41 const2Db41 = true := by decide +kernel
theorem const2Seg42_ok : checkSegF const2Seg42 const2Db42 = true := by decide +kernel
theorem const2Seg43_ok : checkSegF const2Seg43 const2Db43 = true := by decide +kernel
theorem const2Seg44_ok : checkSegF const2Seg44 const2Db44 = true := by decide +kernel
theorem const2Seg45_ok : checkSegF const2Seg45 const2Db45 = true := by decide +kernel

def const2Segs : List (List Step) := [const2Seg0, const2Seg1, const2Seg2, const2Seg3, const2Seg4, const2Seg5, const2Seg6, const2Seg7, const2Seg8, const2Seg9, const2Seg10, const2Seg11, const2Seg12, const2Seg13, const2Seg14, const2Seg15, const2Seg16, const2Seg17, const2Seg18, const2Seg19, const2Seg20, const2Seg21, const2Seg22, const2Seg23, const2Seg24, const2Seg25, const2Seg26, const2Seg27, const2Seg28, const2Seg29, const2Seg30, const2Seg31, const2Seg32, const2Seg33, const2Seg34, const2Seg35, const2Seg36, const2Seg37, const2Seg38, const2Seg39, const2Seg40, const2Seg41, const2Seg42, const2Seg43, const2Seg44, const2Seg45]

theorem const2Segs_okF : SegsOKF const2Db0 const2Segs := by
  simp only [const2Segs, SegsOKF]
  exact ⟨const2Seg0_ok, const2Seg1_ok, const2Seg2_ok, const2Seg3_ok, const2Seg4_ok, const2Seg5_ok, const2Seg6_ok, const2Seg7_ok, const2Seg8_ok, const2Seg9_ok, const2Seg10_ok, const2Seg11_ok, const2Seg12_ok, const2Seg13_ok, const2Seg14_ok, const2Seg15_ok, const2Seg16_ok, const2Seg17_ok, const2Seg18_ok, const2Seg19_ok, const2Seg20_ok, const2Seg21_ok, const2Seg22_ok, const2Seg23_ok, const2Seg24_ok, const2Seg25_ok, const2Seg26_ok, const2Seg27_ok, const2Seg28_ok, const2Seg29_ok, const2Seg30_ok, const2Seg31_ok, const2Seg32_ok, const2Seg33_ok, const2Seg34_ok, const2Seg35_ok, const2Seg36_ok, const2Seg37_ok, const2Seg38_ok, const2Seg39_ok, const2Seg40_ok, const2Seg41_ok, const2Seg42_ok, const2Seg43_ok, const2Seg44_ok, const2Seg45_ok, trivial⟩

theorem const2Segs_empty : const2Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem const2_unsat (v : Nat → Bool) : ∃ c ∈ const2CNF, clauseEval v c = false := by
  have h := segsOKF_iff const2Segs const2Db0 const2Segs_okF
  rw [show const2Db0 = buildDB .leaf 1 const2CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs const2CNF const2Segs h const2Segs_empty v

end RSN
