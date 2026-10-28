module

public import RSN.CaseCNF
public import RSN.Fast
public import RSN.Data.Const1
public import RSN.Data.Const1Seg0
public import RSN.Data.Const1Seg1
public import RSN.Data.Const1Seg2
public import RSN.Data.Const1Seg3
public import RSN.Data.Const1Seg4
public import RSN.Data.Const1Seg5
public import RSN.Data.Const1Seg6
public import RSN.Data.Const1Seg7
public import RSN.Data.Const1Seg8

/-! # Kernel check of the LRAT proof for `const1` (generated) -/

@[expose] public section

namespace RSN

def const1CNF : List Clause := caseCNF const1N const1Edges const1Reds const1Blues

noncomputable def const1Db0 : Trie := buildDBF const1CNF .leaf 1
noncomputable def const1Db1 : Trie := insertStepsF const1Seg0 const1Db0
noncomputable def const1Db2 : Trie := insertStepsF const1Seg1 const1Db1
noncomputable def const1Db3 : Trie := insertStepsF const1Seg2 const1Db2
noncomputable def const1Db4 : Trie := insertStepsF const1Seg3 const1Db3
noncomputable def const1Db5 : Trie := insertStepsF const1Seg4 const1Db4
noncomputable def const1Db6 : Trie := insertStepsF const1Seg5 const1Db5
noncomputable def const1Db7 : Trie := insertStepsF const1Seg6 const1Db6
noncomputable def const1Db8 : Trie := insertStepsF const1Seg7 const1Db7
noncomputable def const1Db9 : Trie := insertStepsF const1Seg8 const1Db8
noncomputable def const1Db10 : Trie := insertStepsF const1Seg9 const1Db9
noncomputable def const1Db11 : Trie := insertStepsF const1Seg10 const1Db10
noncomputable def const1Db12 : Trie := insertStepsF const1Seg11 const1Db11
noncomputable def const1Db13 : Trie := insertStepsF const1Seg12 const1Db12
noncomputable def const1Db14 : Trie := insertStepsF const1Seg13 const1Db13
noncomputable def const1Db15 : Trie := insertStepsF const1Seg14 const1Db14
noncomputable def const1Db16 : Trie := insertStepsF const1Seg15 const1Db15
noncomputable def const1Db17 : Trie := insertStepsF const1Seg16 const1Db16
noncomputable def const1Db18 : Trie := insertStepsF const1Seg17 const1Db17
noncomputable def const1Db19 : Trie := insertStepsF const1Seg18 const1Db18
noncomputable def const1Db20 : Trie := insertStepsF const1Seg19 const1Db19
noncomputable def const1Db21 : Trie := insertStepsF const1Seg20 const1Db20
noncomputable def const1Db22 : Trie := insertStepsF const1Seg21 const1Db21
noncomputable def const1Db23 : Trie := insertStepsF const1Seg22 const1Db22
noncomputable def const1Db24 : Trie := insertStepsF const1Seg23 const1Db23
noncomputable def const1Db25 : Trie := insertStepsF const1Seg24 const1Db24
noncomputable def const1Db26 : Trie := insertStepsF const1Seg25 const1Db25
noncomputable def const1Db27 : Trie := insertStepsF const1Seg26 const1Db26
noncomputable def const1Db28 : Trie := insertStepsF const1Seg27 const1Db27
noncomputable def const1Db29 : Trie := insertStepsF const1Seg28 const1Db28
noncomputable def const1Db30 : Trie := insertStepsF const1Seg29 const1Db29
noncomputable def const1Db31 : Trie := insertStepsF const1Seg30 const1Db30
noncomputable def const1Db32 : Trie := insertStepsF const1Seg31 const1Db31
noncomputable def const1Db33 : Trie := insertStepsF const1Seg32 const1Db32
noncomputable def const1Db34 : Trie := insertStepsF const1Seg33 const1Db33
noncomputable def const1Db35 : Trie := insertStepsF const1Seg34 const1Db34
noncomputable def const1Db36 : Trie := insertStepsF const1Seg35 const1Db35
noncomputable def const1Db37 : Trie := insertStepsF const1Seg36 const1Db36
noncomputable def const1Db38 : Trie := insertStepsF const1Seg37 const1Db37
noncomputable def const1Db39 : Trie := insertStepsF const1Seg38 const1Db38
noncomputable def const1Db40 : Trie := insertStepsF const1Seg39 const1Db39
noncomputable def const1Db41 : Trie := insertStepsF const1Seg40 const1Db40
noncomputable def const1Db42 : Trie := insertStepsF const1Seg41 const1Db41
noncomputable def const1Db43 : Trie := insertStepsF const1Seg42 const1Db42
noncomputable def const1Db44 : Trie := insertStepsF const1Seg43 const1Db43
noncomputable def const1Db45 : Trie := insertStepsF const1Seg44 const1Db44
noncomputable def const1Db46 : Trie := insertStepsF const1Seg45 const1Db45
noncomputable def const1Db47 : Trie := insertStepsF const1Seg46 const1Db46
noncomputable def const1Db48 : Trie := insertStepsF const1Seg47 const1Db47
noncomputable def const1Db49 : Trie := insertStepsF const1Seg48 const1Db48
noncomputable def const1Db50 : Trie := insertStepsF const1Seg49 const1Db49
noncomputable def const1Db51 : Trie := insertStepsF const1Seg50 const1Db50
noncomputable def const1Db52 : Trie := insertStepsF const1Seg51 const1Db51
noncomputable def const1Db53 : Trie := insertStepsF const1Seg52 const1Db52
noncomputable def const1Db54 : Trie := insertStepsF const1Seg53 const1Db53
noncomputable def const1Db55 : Trie := insertStepsF const1Seg54 const1Db54
noncomputable def const1Db56 : Trie := insertStepsF const1Seg55 const1Db55
noncomputable def const1Db57 : Trie := insertStepsF const1Seg56 const1Db56
noncomputable def const1Db58 : Trie := insertStepsF const1Seg57 const1Db57
noncomputable def const1Db59 : Trie := insertStepsF const1Seg58 const1Db58
noncomputable def const1Db60 : Trie := insertStepsF const1Seg59 const1Db59
noncomputable def const1Db61 : Trie := insertStepsF const1Seg60 const1Db60
noncomputable def const1Db62 : Trie := insertStepsF const1Seg61 const1Db61
noncomputable def const1Db63 : Trie := insertStepsF const1Seg62 const1Db62
noncomputable def const1Db64 : Trie := insertStepsF const1Seg63 const1Db63
noncomputable def const1Db65 : Trie := insertStepsF const1Seg64 const1Db64
noncomputable def const1Db66 : Trie := insertStepsF const1Seg65 const1Db65
noncomputable def const1Db67 : Trie := insertStepsF const1Seg66 const1Db66
noncomputable def const1Db68 : Trie := insertStepsF const1Seg67 const1Db67
noncomputable def const1Db69 : Trie := insertStepsF const1Seg68 const1Db68
noncomputable def const1Db70 : Trie := insertStepsF const1Seg69 const1Db69
noncomputable def const1Db71 : Trie := insertStepsF const1Seg70 const1Db70
noncomputable def const1Db72 : Trie := insertStepsF const1Seg71 const1Db71
noncomputable def const1Db73 : Trie := insertStepsF const1Seg72 const1Db72
noncomputable def const1Db74 : Trie := insertStepsF const1Seg73 const1Db73
noncomputable def const1Db75 : Trie := insertStepsF const1Seg74 const1Db74
noncomputable def const1Db76 : Trie := insertStepsF const1Seg75 const1Db75
noncomputable def const1Db77 : Trie := insertStepsF const1Seg76 const1Db76
noncomputable def const1Db78 : Trie := insertStepsF const1Seg77 const1Db77
noncomputable def const1Db79 : Trie := insertStepsF const1Seg78 const1Db78
noncomputable def const1Db80 : Trie := insertStepsF const1Seg79 const1Db79
noncomputable def const1Db81 : Trie := insertStepsF const1Seg80 const1Db80
noncomputable def const1Db82 : Trie := insertStepsF const1Seg81 const1Db81
theorem const1Seg0_ok : checkSegF const1Seg0 const1Db0 = true := by decide +kernel
theorem const1Seg1_ok : checkSegF const1Seg1 const1Db1 = true := by decide +kernel
theorem const1Seg2_ok : checkSegF const1Seg2 const1Db2 = true := by decide +kernel
theorem const1Seg3_ok : checkSegF const1Seg3 const1Db3 = true := by decide +kernel
theorem const1Seg4_ok : checkSegF const1Seg4 const1Db4 = true := by decide +kernel
theorem const1Seg5_ok : checkSegF const1Seg5 const1Db5 = true := by decide +kernel
theorem const1Seg6_ok : checkSegF const1Seg6 const1Db6 = true := by decide +kernel
theorem const1Seg7_ok : checkSegF const1Seg7 const1Db7 = true := by decide +kernel
theorem const1Seg8_ok : checkSegF const1Seg8 const1Db8 = true := by decide +kernel
theorem const1Seg9_ok : checkSegF const1Seg9 const1Db9 = true := by decide +kernel
theorem const1Seg10_ok : checkSegF const1Seg10 const1Db10 = true := by decide +kernel
theorem const1Seg11_ok : checkSegF const1Seg11 const1Db11 = true := by decide +kernel
theorem const1Seg12_ok : checkSegF const1Seg12 const1Db12 = true := by decide +kernel
theorem const1Seg13_ok : checkSegF const1Seg13 const1Db13 = true := by decide +kernel
theorem const1Seg14_ok : checkSegF const1Seg14 const1Db14 = true := by decide +kernel
theorem const1Seg15_ok : checkSegF const1Seg15 const1Db15 = true := by decide +kernel
theorem const1Seg16_ok : checkSegF const1Seg16 const1Db16 = true := by decide +kernel
theorem const1Seg17_ok : checkSegF const1Seg17 const1Db17 = true := by decide +kernel
theorem const1Seg18_ok : checkSegF const1Seg18 const1Db18 = true := by decide +kernel
theorem const1Seg19_ok : checkSegF const1Seg19 const1Db19 = true := by decide +kernel
theorem const1Seg20_ok : checkSegF const1Seg20 const1Db20 = true := by decide +kernel
theorem const1Seg21_ok : checkSegF const1Seg21 const1Db21 = true := by decide +kernel
theorem const1Seg22_ok : checkSegF const1Seg22 const1Db22 = true := by decide +kernel
theorem const1Seg23_ok : checkSegF const1Seg23 const1Db23 = true := by decide +kernel
theorem const1Seg24_ok : checkSegF const1Seg24 const1Db24 = true := by decide +kernel
theorem const1Seg25_ok : checkSegF const1Seg25 const1Db25 = true := by decide +kernel
theorem const1Seg26_ok : checkSegF const1Seg26 const1Db26 = true := by decide +kernel
theorem const1Seg27_ok : checkSegF const1Seg27 const1Db27 = true := by decide +kernel
theorem const1Seg28_ok : checkSegF const1Seg28 const1Db28 = true := by decide +kernel
theorem const1Seg29_ok : checkSegF const1Seg29 const1Db29 = true := by decide +kernel
theorem const1Seg30_ok : checkSegF const1Seg30 const1Db30 = true := by decide +kernel
theorem const1Seg31_ok : checkSegF const1Seg31 const1Db31 = true := by decide +kernel
theorem const1Seg32_ok : checkSegF const1Seg32 const1Db32 = true := by decide +kernel
theorem const1Seg33_ok : checkSegF const1Seg33 const1Db33 = true := by decide +kernel
theorem const1Seg34_ok : checkSegF const1Seg34 const1Db34 = true := by decide +kernel
theorem const1Seg35_ok : checkSegF const1Seg35 const1Db35 = true := by decide +kernel
theorem const1Seg36_ok : checkSegF const1Seg36 const1Db36 = true := by decide +kernel
theorem const1Seg37_ok : checkSegF const1Seg37 const1Db37 = true := by decide +kernel
theorem const1Seg38_ok : checkSegF const1Seg38 const1Db38 = true := by decide +kernel
theorem const1Seg39_ok : checkSegF const1Seg39 const1Db39 = true := by decide +kernel
theorem const1Seg40_ok : checkSegF const1Seg40 const1Db40 = true := by decide +kernel
theorem const1Seg41_ok : checkSegF const1Seg41 const1Db41 = true := by decide +kernel
theorem const1Seg42_ok : checkSegF const1Seg42 const1Db42 = true := by decide +kernel
theorem const1Seg43_ok : checkSegF const1Seg43 const1Db43 = true := by decide +kernel
theorem const1Seg44_ok : checkSegF const1Seg44 const1Db44 = true := by decide +kernel
theorem const1Seg45_ok : checkSegF const1Seg45 const1Db45 = true := by decide +kernel
theorem const1Seg46_ok : checkSegF const1Seg46 const1Db46 = true := by decide +kernel
theorem const1Seg47_ok : checkSegF const1Seg47 const1Db47 = true := by decide +kernel
theorem const1Seg48_ok : checkSegF const1Seg48 const1Db48 = true := by decide +kernel
theorem const1Seg49_ok : checkSegF const1Seg49 const1Db49 = true := by decide +kernel
theorem const1Seg50_ok : checkSegF const1Seg50 const1Db50 = true := by decide +kernel
theorem const1Seg51_ok : checkSegF const1Seg51 const1Db51 = true := by decide +kernel
theorem const1Seg52_ok : checkSegF const1Seg52 const1Db52 = true := by decide +kernel
theorem const1Seg53_ok : checkSegF const1Seg53 const1Db53 = true := by decide +kernel
theorem const1Seg54_ok : checkSegF const1Seg54 const1Db54 = true := by decide +kernel
theorem const1Seg55_ok : checkSegF const1Seg55 const1Db55 = true := by decide +kernel
theorem const1Seg56_ok : checkSegF const1Seg56 const1Db56 = true := by decide +kernel
theorem const1Seg57_ok : checkSegF const1Seg57 const1Db57 = true := by decide +kernel
theorem const1Seg58_ok : checkSegF const1Seg58 const1Db58 = true := by decide +kernel
theorem const1Seg59_ok : checkSegF const1Seg59 const1Db59 = true := by decide +kernel
theorem const1Seg60_ok : checkSegF const1Seg60 const1Db60 = true := by decide +kernel
theorem const1Seg61_ok : checkSegF const1Seg61 const1Db61 = true := by decide +kernel
theorem const1Seg62_ok : checkSegF const1Seg62 const1Db62 = true := by decide +kernel
theorem const1Seg63_ok : checkSegF const1Seg63 const1Db63 = true := by decide +kernel
theorem const1Seg64_ok : checkSegF const1Seg64 const1Db64 = true := by decide +kernel
theorem const1Seg65_ok : checkSegF const1Seg65 const1Db65 = true := by decide +kernel
theorem const1Seg66_ok : checkSegF const1Seg66 const1Db66 = true := by decide +kernel
theorem const1Seg67_ok : checkSegF const1Seg67 const1Db67 = true := by decide +kernel
theorem const1Seg68_ok : checkSegF const1Seg68 const1Db68 = true := by decide +kernel
theorem const1Seg69_ok : checkSegF const1Seg69 const1Db69 = true := by decide +kernel
theorem const1Seg70_ok : checkSegF const1Seg70 const1Db70 = true := by decide +kernel
theorem const1Seg71_ok : checkSegF const1Seg71 const1Db71 = true := by decide +kernel
theorem const1Seg72_ok : checkSegF const1Seg72 const1Db72 = true := by decide +kernel
theorem const1Seg73_ok : checkSegF const1Seg73 const1Db73 = true := by decide +kernel
theorem const1Seg74_ok : checkSegF const1Seg74 const1Db74 = true := by decide +kernel
theorem const1Seg75_ok : checkSegF const1Seg75 const1Db75 = true := by decide +kernel
theorem const1Seg76_ok : checkSegF const1Seg76 const1Db76 = true := by decide +kernel
theorem const1Seg77_ok : checkSegF const1Seg77 const1Db77 = true := by decide +kernel
theorem const1Seg78_ok : checkSegF const1Seg78 const1Db78 = true := by decide +kernel
theorem const1Seg79_ok : checkSegF const1Seg79 const1Db79 = true := by decide +kernel
theorem const1Seg80_ok : checkSegF const1Seg80 const1Db80 = true := by decide +kernel
theorem const1Seg81_ok : checkSegF const1Seg81 const1Db81 = true := by decide +kernel

def const1Segs : List (List Step) := [const1Seg0, const1Seg1, const1Seg2, const1Seg3, const1Seg4, const1Seg5, const1Seg6, const1Seg7, const1Seg8, const1Seg9, const1Seg10, const1Seg11, const1Seg12, const1Seg13, const1Seg14, const1Seg15, const1Seg16, const1Seg17, const1Seg18, const1Seg19, const1Seg20, const1Seg21, const1Seg22, const1Seg23, const1Seg24, const1Seg25, const1Seg26, const1Seg27, const1Seg28, const1Seg29, const1Seg30, const1Seg31, const1Seg32, const1Seg33, const1Seg34, const1Seg35, const1Seg36, const1Seg37, const1Seg38, const1Seg39, const1Seg40, const1Seg41, const1Seg42, const1Seg43, const1Seg44, const1Seg45, const1Seg46, const1Seg47, const1Seg48, const1Seg49, const1Seg50, const1Seg51, const1Seg52, const1Seg53, const1Seg54, const1Seg55, const1Seg56, const1Seg57, const1Seg58, const1Seg59, const1Seg60, const1Seg61, const1Seg62, const1Seg63, const1Seg64, const1Seg65, const1Seg66, const1Seg67, const1Seg68, const1Seg69, const1Seg70, const1Seg71, const1Seg72, const1Seg73, const1Seg74, const1Seg75, const1Seg76, const1Seg77, const1Seg78, const1Seg79, const1Seg80, const1Seg81]

theorem const1Segs_okF : SegsOKF const1Db0 const1Segs := by
  simp only [const1Segs, SegsOKF]
  exact ⟨const1Seg0_ok, const1Seg1_ok, const1Seg2_ok, const1Seg3_ok, const1Seg4_ok, const1Seg5_ok, const1Seg6_ok, const1Seg7_ok, const1Seg8_ok, const1Seg9_ok, const1Seg10_ok, const1Seg11_ok, const1Seg12_ok, const1Seg13_ok, const1Seg14_ok, const1Seg15_ok, const1Seg16_ok, const1Seg17_ok, const1Seg18_ok, const1Seg19_ok, const1Seg20_ok, const1Seg21_ok, const1Seg22_ok, const1Seg23_ok, const1Seg24_ok, const1Seg25_ok, const1Seg26_ok, const1Seg27_ok, const1Seg28_ok, const1Seg29_ok, const1Seg30_ok, const1Seg31_ok, const1Seg32_ok, const1Seg33_ok, const1Seg34_ok, const1Seg35_ok, const1Seg36_ok, const1Seg37_ok, const1Seg38_ok, const1Seg39_ok, const1Seg40_ok, const1Seg41_ok, const1Seg42_ok, const1Seg43_ok, const1Seg44_ok, const1Seg45_ok, const1Seg46_ok, const1Seg47_ok, const1Seg48_ok, const1Seg49_ok, const1Seg50_ok, const1Seg51_ok, const1Seg52_ok, const1Seg53_ok, const1Seg54_ok, const1Seg55_ok, const1Seg56_ok, const1Seg57_ok, const1Seg58_ok, const1Seg59_ok, const1Seg60_ok, const1Seg61_ok, const1Seg62_ok, const1Seg63_ok, const1Seg64_ok, const1Seg65_ok, const1Seg66_ok, const1Seg67_ok, const1Seg68_ok, const1Seg69_ok, const1Seg70_ok, const1Seg71_ok, const1Seg72_ok, const1Seg73_ok, const1Seg74_ok, const1Seg75_ok, const1Seg76_ok, const1Seg77_ok, const1Seg78_ok, const1Seg79_ok, const1Seg80_ok, const1Seg81_ok, trivial⟩

theorem const1Segs_empty : const1Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem const1_unsat (v : Nat → Bool) : ∃ c ∈ const1CNF, clauseEval v c = false := by
  have h := segsOKF_iff const1Segs const1Db0 const1Segs_okF
  rw [show const1Db0 = buildDB .leaf 1 const1CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs const1CNF const1Segs h const1Segs_empty v

end RSN
