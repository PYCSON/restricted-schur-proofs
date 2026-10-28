module

public import RSN.CaseCNF
public import RSN.Fast
public import RSN.Data.Const3
public import RSN.Data.Const3Seg0
public import RSN.Data.Const3Seg1
public import RSN.Data.Const3Seg2
public import RSN.Data.Const3Seg3
public import RSN.Data.Const3Seg4
public import RSN.Data.Const3Seg5
public import RSN.Data.Const3Seg6
public import RSN.Data.Const3Seg7
public import RSN.Data.Const3Seg8

/-! # Kernel check of the LRAT proof for `const3` (generated) -/

@[expose] public section

namespace RSN

def const3CNF : List Clause := caseCNF const3N const3Edges const3Reds const3Blues

noncomputable def const3Db0 : Trie := buildDBF const3CNF .leaf 1
noncomputable def const3Db1 : Trie := insertStepsF const3Seg0 const3Db0
noncomputable def const3Db2 : Trie := insertStepsF const3Seg1 const3Db1
noncomputable def const3Db3 : Trie := insertStepsF const3Seg2 const3Db2
noncomputable def const3Db4 : Trie := insertStepsF const3Seg3 const3Db3
noncomputable def const3Db5 : Trie := insertStepsF const3Seg4 const3Db4
noncomputable def const3Db6 : Trie := insertStepsF const3Seg5 const3Db5
noncomputable def const3Db7 : Trie := insertStepsF const3Seg6 const3Db6
noncomputable def const3Db8 : Trie := insertStepsF const3Seg7 const3Db7
noncomputable def const3Db9 : Trie := insertStepsF const3Seg8 const3Db8
noncomputable def const3Db10 : Trie := insertStepsF const3Seg9 const3Db9
noncomputable def const3Db11 : Trie := insertStepsF const3Seg10 const3Db10
noncomputable def const3Db12 : Trie := insertStepsF const3Seg11 const3Db11
noncomputable def const3Db13 : Trie := insertStepsF const3Seg12 const3Db12
noncomputable def const3Db14 : Trie := insertStepsF const3Seg13 const3Db13
noncomputable def const3Db15 : Trie := insertStepsF const3Seg14 const3Db14
noncomputable def const3Db16 : Trie := insertStepsF const3Seg15 const3Db15
noncomputable def const3Db17 : Trie := insertStepsF const3Seg16 const3Db16
noncomputable def const3Db18 : Trie := insertStepsF const3Seg17 const3Db17
noncomputable def const3Db19 : Trie := insertStepsF const3Seg18 const3Db18
noncomputable def const3Db20 : Trie := insertStepsF const3Seg19 const3Db19
noncomputable def const3Db21 : Trie := insertStepsF const3Seg20 const3Db20
noncomputable def const3Db22 : Trie := insertStepsF const3Seg21 const3Db21
noncomputable def const3Db23 : Trie := insertStepsF const3Seg22 const3Db22
noncomputable def const3Db24 : Trie := insertStepsF const3Seg23 const3Db23
noncomputable def const3Db25 : Trie := insertStepsF const3Seg24 const3Db24
noncomputable def const3Db26 : Trie := insertStepsF const3Seg25 const3Db25
noncomputable def const3Db27 : Trie := insertStepsF const3Seg26 const3Db26
noncomputable def const3Db28 : Trie := insertStepsF const3Seg27 const3Db27
noncomputable def const3Db29 : Trie := insertStepsF const3Seg28 const3Db28
noncomputable def const3Db30 : Trie := insertStepsF const3Seg29 const3Db29
noncomputable def const3Db31 : Trie := insertStepsF const3Seg30 const3Db30
noncomputable def const3Db32 : Trie := insertStepsF const3Seg31 const3Db31
noncomputable def const3Db33 : Trie := insertStepsF const3Seg32 const3Db32
noncomputable def const3Db34 : Trie := insertStepsF const3Seg33 const3Db33
noncomputable def const3Db35 : Trie := insertStepsF const3Seg34 const3Db34
noncomputable def const3Db36 : Trie := insertStepsF const3Seg35 const3Db35
noncomputable def const3Db37 : Trie := insertStepsF const3Seg36 const3Db36
noncomputable def const3Db38 : Trie := insertStepsF const3Seg37 const3Db37
noncomputable def const3Db39 : Trie := insertStepsF const3Seg38 const3Db38
noncomputable def const3Db40 : Trie := insertStepsF const3Seg39 const3Db39
noncomputable def const3Db41 : Trie := insertStepsF const3Seg40 const3Db40
noncomputable def const3Db42 : Trie := insertStepsF const3Seg41 const3Db41
noncomputable def const3Db43 : Trie := insertStepsF const3Seg42 const3Db42
noncomputable def const3Db44 : Trie := insertStepsF const3Seg43 const3Db43
noncomputable def const3Db45 : Trie := insertStepsF const3Seg44 const3Db44
noncomputable def const3Db46 : Trie := insertStepsF const3Seg45 const3Db45
noncomputable def const3Db47 : Trie := insertStepsF const3Seg46 const3Db46
noncomputable def const3Db48 : Trie := insertStepsF const3Seg47 const3Db47
noncomputable def const3Db49 : Trie := insertStepsF const3Seg48 const3Db48
noncomputable def const3Db50 : Trie := insertStepsF const3Seg49 const3Db49
noncomputable def const3Db51 : Trie := insertStepsF const3Seg50 const3Db50
noncomputable def const3Db52 : Trie := insertStepsF const3Seg51 const3Db51
noncomputable def const3Db53 : Trie := insertStepsF const3Seg52 const3Db52
noncomputable def const3Db54 : Trie := insertStepsF const3Seg53 const3Db53
noncomputable def const3Db55 : Trie := insertStepsF const3Seg54 const3Db54
noncomputable def const3Db56 : Trie := insertStepsF const3Seg55 const3Db55
noncomputable def const3Db57 : Trie := insertStepsF const3Seg56 const3Db56
noncomputable def const3Db58 : Trie := insertStepsF const3Seg57 const3Db57
noncomputable def const3Db59 : Trie := insertStepsF const3Seg58 const3Db58
noncomputable def const3Db60 : Trie := insertStepsF const3Seg59 const3Db59
noncomputable def const3Db61 : Trie := insertStepsF const3Seg60 const3Db60
noncomputable def const3Db62 : Trie := insertStepsF const3Seg61 const3Db61
noncomputable def const3Db63 : Trie := insertStepsF const3Seg62 const3Db62
noncomputable def const3Db64 : Trie := insertStepsF const3Seg63 const3Db63
noncomputable def const3Db65 : Trie := insertStepsF const3Seg64 const3Db64
noncomputable def const3Db66 : Trie := insertStepsF const3Seg65 const3Db65
noncomputable def const3Db67 : Trie := insertStepsF const3Seg66 const3Db66
noncomputable def const3Db68 : Trie := insertStepsF const3Seg67 const3Db67
noncomputable def const3Db69 : Trie := insertStepsF const3Seg68 const3Db68
noncomputable def const3Db70 : Trie := insertStepsF const3Seg69 const3Db69
noncomputable def const3Db71 : Trie := insertStepsF const3Seg70 const3Db70
noncomputable def const3Db72 : Trie := insertStepsF const3Seg71 const3Db71
noncomputable def const3Db73 : Trie := insertStepsF const3Seg72 const3Db72
noncomputable def const3Db74 : Trie := insertStepsF const3Seg73 const3Db73
noncomputable def const3Db75 : Trie := insertStepsF const3Seg74 const3Db74
noncomputable def const3Db76 : Trie := insertStepsF const3Seg75 const3Db75
noncomputable def const3Db77 : Trie := insertStepsF const3Seg76 const3Db76
noncomputable def const3Db78 : Trie := insertStepsF const3Seg77 const3Db77
noncomputable def const3Db79 : Trie := insertStepsF const3Seg78 const3Db78
noncomputable def const3Db80 : Trie := insertStepsF const3Seg79 const3Db79
noncomputable def const3Db81 : Trie := insertStepsF const3Seg80 const3Db80
noncomputable def const3Db82 : Trie := insertStepsF const3Seg81 const3Db81
theorem const3Seg0_ok : checkSegF const3Seg0 const3Db0 = true := by decide +kernel
theorem const3Seg1_ok : checkSegF const3Seg1 const3Db1 = true := by decide +kernel
theorem const3Seg2_ok : checkSegF const3Seg2 const3Db2 = true := by decide +kernel
theorem const3Seg3_ok : checkSegF const3Seg3 const3Db3 = true := by decide +kernel
theorem const3Seg4_ok : checkSegF const3Seg4 const3Db4 = true := by decide +kernel
theorem const3Seg5_ok : checkSegF const3Seg5 const3Db5 = true := by decide +kernel
theorem const3Seg6_ok : checkSegF const3Seg6 const3Db6 = true := by decide +kernel
theorem const3Seg7_ok : checkSegF const3Seg7 const3Db7 = true := by decide +kernel
theorem const3Seg8_ok : checkSegF const3Seg8 const3Db8 = true := by decide +kernel
theorem const3Seg9_ok : checkSegF const3Seg9 const3Db9 = true := by decide +kernel
theorem const3Seg10_ok : checkSegF const3Seg10 const3Db10 = true := by decide +kernel
theorem const3Seg11_ok : checkSegF const3Seg11 const3Db11 = true := by decide +kernel
theorem const3Seg12_ok : checkSegF const3Seg12 const3Db12 = true := by decide +kernel
theorem const3Seg13_ok : checkSegF const3Seg13 const3Db13 = true := by decide +kernel
theorem const3Seg14_ok : checkSegF const3Seg14 const3Db14 = true := by decide +kernel
theorem const3Seg15_ok : checkSegF const3Seg15 const3Db15 = true := by decide +kernel
theorem const3Seg16_ok : checkSegF const3Seg16 const3Db16 = true := by decide +kernel
theorem const3Seg17_ok : checkSegF const3Seg17 const3Db17 = true := by decide +kernel
theorem const3Seg18_ok : checkSegF const3Seg18 const3Db18 = true := by decide +kernel
theorem const3Seg19_ok : checkSegF const3Seg19 const3Db19 = true := by decide +kernel
theorem const3Seg20_ok : checkSegF const3Seg20 const3Db20 = true := by decide +kernel
theorem const3Seg21_ok : checkSegF const3Seg21 const3Db21 = true := by decide +kernel
theorem const3Seg22_ok : checkSegF const3Seg22 const3Db22 = true := by decide +kernel
theorem const3Seg23_ok : checkSegF const3Seg23 const3Db23 = true := by decide +kernel
theorem const3Seg24_ok : checkSegF const3Seg24 const3Db24 = true := by decide +kernel
theorem const3Seg25_ok : checkSegF const3Seg25 const3Db25 = true := by decide +kernel
theorem const3Seg26_ok : checkSegF const3Seg26 const3Db26 = true := by decide +kernel
theorem const3Seg27_ok : checkSegF const3Seg27 const3Db27 = true := by decide +kernel
theorem const3Seg28_ok : checkSegF const3Seg28 const3Db28 = true := by decide +kernel
theorem const3Seg29_ok : checkSegF const3Seg29 const3Db29 = true := by decide +kernel
theorem const3Seg30_ok : checkSegF const3Seg30 const3Db30 = true := by decide +kernel
theorem const3Seg31_ok : checkSegF const3Seg31 const3Db31 = true := by decide +kernel
theorem const3Seg32_ok : checkSegF const3Seg32 const3Db32 = true := by decide +kernel
theorem const3Seg33_ok : checkSegF const3Seg33 const3Db33 = true := by decide +kernel
theorem const3Seg34_ok : checkSegF const3Seg34 const3Db34 = true := by decide +kernel
theorem const3Seg35_ok : checkSegF const3Seg35 const3Db35 = true := by decide +kernel
theorem const3Seg36_ok : checkSegF const3Seg36 const3Db36 = true := by decide +kernel
theorem const3Seg37_ok : checkSegF const3Seg37 const3Db37 = true := by decide +kernel
theorem const3Seg38_ok : checkSegF const3Seg38 const3Db38 = true := by decide +kernel
theorem const3Seg39_ok : checkSegF const3Seg39 const3Db39 = true := by decide +kernel
theorem const3Seg40_ok : checkSegF const3Seg40 const3Db40 = true := by decide +kernel
theorem const3Seg41_ok : checkSegF const3Seg41 const3Db41 = true := by decide +kernel
theorem const3Seg42_ok : checkSegF const3Seg42 const3Db42 = true := by decide +kernel
theorem const3Seg43_ok : checkSegF const3Seg43 const3Db43 = true := by decide +kernel
theorem const3Seg44_ok : checkSegF const3Seg44 const3Db44 = true := by decide +kernel
theorem const3Seg45_ok : checkSegF const3Seg45 const3Db45 = true := by decide +kernel
theorem const3Seg46_ok : checkSegF const3Seg46 const3Db46 = true := by decide +kernel
theorem const3Seg47_ok : checkSegF const3Seg47 const3Db47 = true := by decide +kernel
theorem const3Seg48_ok : checkSegF const3Seg48 const3Db48 = true := by decide +kernel
theorem const3Seg49_ok : checkSegF const3Seg49 const3Db49 = true := by decide +kernel
theorem const3Seg50_ok : checkSegF const3Seg50 const3Db50 = true := by decide +kernel
theorem const3Seg51_ok : checkSegF const3Seg51 const3Db51 = true := by decide +kernel
theorem const3Seg52_ok : checkSegF const3Seg52 const3Db52 = true := by decide +kernel
theorem const3Seg53_ok : checkSegF const3Seg53 const3Db53 = true := by decide +kernel
theorem const3Seg54_ok : checkSegF const3Seg54 const3Db54 = true := by decide +kernel
theorem const3Seg55_ok : checkSegF const3Seg55 const3Db55 = true := by decide +kernel
theorem const3Seg56_ok : checkSegF const3Seg56 const3Db56 = true := by decide +kernel
theorem const3Seg57_ok : checkSegF const3Seg57 const3Db57 = true := by decide +kernel
theorem const3Seg58_ok : checkSegF const3Seg58 const3Db58 = true := by decide +kernel
theorem const3Seg59_ok : checkSegF const3Seg59 const3Db59 = true := by decide +kernel
theorem const3Seg60_ok : checkSegF const3Seg60 const3Db60 = true := by decide +kernel
theorem const3Seg61_ok : checkSegF const3Seg61 const3Db61 = true := by decide +kernel
theorem const3Seg62_ok : checkSegF const3Seg62 const3Db62 = true := by decide +kernel
theorem const3Seg63_ok : checkSegF const3Seg63 const3Db63 = true := by decide +kernel
theorem const3Seg64_ok : checkSegF const3Seg64 const3Db64 = true := by decide +kernel
theorem const3Seg65_ok : checkSegF const3Seg65 const3Db65 = true := by decide +kernel
theorem const3Seg66_ok : checkSegF const3Seg66 const3Db66 = true := by decide +kernel
theorem const3Seg67_ok : checkSegF const3Seg67 const3Db67 = true := by decide +kernel
theorem const3Seg68_ok : checkSegF const3Seg68 const3Db68 = true := by decide +kernel
theorem const3Seg69_ok : checkSegF const3Seg69 const3Db69 = true := by decide +kernel
theorem const3Seg70_ok : checkSegF const3Seg70 const3Db70 = true := by decide +kernel
theorem const3Seg71_ok : checkSegF const3Seg71 const3Db71 = true := by decide +kernel
theorem const3Seg72_ok : checkSegF const3Seg72 const3Db72 = true := by decide +kernel
theorem const3Seg73_ok : checkSegF const3Seg73 const3Db73 = true := by decide +kernel
theorem const3Seg74_ok : checkSegF const3Seg74 const3Db74 = true := by decide +kernel
theorem const3Seg75_ok : checkSegF const3Seg75 const3Db75 = true := by decide +kernel
theorem const3Seg76_ok : checkSegF const3Seg76 const3Db76 = true := by decide +kernel
theorem const3Seg77_ok : checkSegF const3Seg77 const3Db77 = true := by decide +kernel
theorem const3Seg78_ok : checkSegF const3Seg78 const3Db78 = true := by decide +kernel
theorem const3Seg79_ok : checkSegF const3Seg79 const3Db79 = true := by decide +kernel
theorem const3Seg80_ok : checkSegF const3Seg80 const3Db80 = true := by decide +kernel
theorem const3Seg81_ok : checkSegF const3Seg81 const3Db81 = true := by decide +kernel

def const3Segs : List (List Step) := [const3Seg0, const3Seg1, const3Seg2, const3Seg3, const3Seg4, const3Seg5, const3Seg6, const3Seg7, const3Seg8, const3Seg9, const3Seg10, const3Seg11, const3Seg12, const3Seg13, const3Seg14, const3Seg15, const3Seg16, const3Seg17, const3Seg18, const3Seg19, const3Seg20, const3Seg21, const3Seg22, const3Seg23, const3Seg24, const3Seg25, const3Seg26, const3Seg27, const3Seg28, const3Seg29, const3Seg30, const3Seg31, const3Seg32, const3Seg33, const3Seg34, const3Seg35, const3Seg36, const3Seg37, const3Seg38, const3Seg39, const3Seg40, const3Seg41, const3Seg42, const3Seg43, const3Seg44, const3Seg45, const3Seg46, const3Seg47, const3Seg48, const3Seg49, const3Seg50, const3Seg51, const3Seg52, const3Seg53, const3Seg54, const3Seg55, const3Seg56, const3Seg57, const3Seg58, const3Seg59, const3Seg60, const3Seg61, const3Seg62, const3Seg63, const3Seg64, const3Seg65, const3Seg66, const3Seg67, const3Seg68, const3Seg69, const3Seg70, const3Seg71, const3Seg72, const3Seg73, const3Seg74, const3Seg75, const3Seg76, const3Seg77, const3Seg78, const3Seg79, const3Seg80, const3Seg81]

theorem const3Segs_okF : SegsOKF const3Db0 const3Segs := by
  simp only [const3Segs, SegsOKF]
  exact ⟨const3Seg0_ok, const3Seg1_ok, const3Seg2_ok, const3Seg3_ok, const3Seg4_ok, const3Seg5_ok, const3Seg6_ok, const3Seg7_ok, const3Seg8_ok, const3Seg9_ok, const3Seg10_ok, const3Seg11_ok, const3Seg12_ok, const3Seg13_ok, const3Seg14_ok, const3Seg15_ok, const3Seg16_ok, const3Seg17_ok, const3Seg18_ok, const3Seg19_ok, const3Seg20_ok, const3Seg21_ok, const3Seg22_ok, const3Seg23_ok, const3Seg24_ok, const3Seg25_ok, const3Seg26_ok, const3Seg27_ok, const3Seg28_ok, const3Seg29_ok, const3Seg30_ok, const3Seg31_ok, const3Seg32_ok, const3Seg33_ok, const3Seg34_ok, const3Seg35_ok, const3Seg36_ok, const3Seg37_ok, const3Seg38_ok, const3Seg39_ok, const3Seg40_ok, const3Seg41_ok, const3Seg42_ok, const3Seg43_ok, const3Seg44_ok, const3Seg45_ok, const3Seg46_ok, const3Seg47_ok, const3Seg48_ok, const3Seg49_ok, const3Seg50_ok, const3Seg51_ok, const3Seg52_ok, const3Seg53_ok, const3Seg54_ok, const3Seg55_ok, const3Seg56_ok, const3Seg57_ok, const3Seg58_ok, const3Seg59_ok, const3Seg60_ok, const3Seg61_ok, const3Seg62_ok, const3Seg63_ok, const3Seg64_ok, const3Seg65_ok, const3Seg66_ok, const3Seg67_ok, const3Seg68_ok, const3Seg69_ok, const3Seg70_ok, const3Seg71_ok, const3Seg72_ok, const3Seg73_ok, const3Seg74_ok, const3Seg75_ok, const3Seg76_ok, const3Seg77_ok, const3Seg78_ok, const3Seg79_ok, const3Seg80_ok, const3Seg81_ok, trivial⟩

theorem const3Segs_empty : const3Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem const3_unsat (v : Nat → Bool) : ∃ c ∈ const3CNF, clauseEval v c = false := by
  have h := segsOKF_iff const3Segs const3Db0 const3Segs_okF
  rw [show const3Db0 = buildDB .leaf 1 const3CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs const3CNF const3Segs h const3Segs_empty v

end RSN
