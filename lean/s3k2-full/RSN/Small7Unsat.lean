module

public import RSN.Direct
public import RSN.Fast
public import RSN.Data.Small7
public import RSN.Data.Small7Seg0
public import RSN.Data.Small7Seg1
public import RSN.Data.Small7Seg2
public import RSN.Data.Small7Seg3
public import RSN.Data.Small7Seg4
public import RSN.Data.Small7Seg5
public import RSN.Data.Small7Seg6
public import RSN.Data.Small7Seg7
public import RSN.Data.Small7Seg8
public import RSN.Data.Small7Seg9
public import RSN.Data.Small7Seg10

/-! # Kernel check of the LRAT proof for `small7` (generated) -/

@[expose] public section

namespace RSN

def small7CNF : List Clause := caseCNF 502 small7Edges [1] []

noncomputable def small7Db0 : Trie := buildDBF small7CNF .leaf 1
noncomputable def small7Db1 : Trie := insertStepsF small7Seg0 small7Db0
noncomputable def small7Db2 : Trie := insertStepsF small7Seg1 small7Db1
noncomputable def small7Db3 : Trie := insertStepsF small7Seg2 small7Db2
noncomputable def small7Db4 : Trie := insertStepsF small7Seg3 small7Db3
noncomputable def small7Db5 : Trie := insertStepsF small7Seg4 small7Db4
noncomputable def small7Db6 : Trie := insertStepsF small7Seg5 small7Db5
noncomputable def small7Db7 : Trie := insertStepsF small7Seg6 small7Db6
noncomputable def small7Db8 : Trie := insertStepsF small7Seg7 small7Db7
noncomputable def small7Db9 : Trie := insertStepsF small7Seg8 small7Db8
noncomputable def small7Db10 : Trie := insertStepsF small7Seg9 small7Db9
noncomputable def small7Db11 : Trie := insertStepsF small7Seg10 small7Db10
noncomputable def small7Db12 : Trie := insertStepsF small7Seg11 small7Db11
noncomputable def small7Db13 : Trie := insertStepsF small7Seg12 small7Db12
noncomputable def small7Db14 : Trie := insertStepsF small7Seg13 small7Db13
noncomputable def small7Db15 : Trie := insertStepsF small7Seg14 small7Db14
noncomputable def small7Db16 : Trie := insertStepsF small7Seg15 small7Db15
noncomputable def small7Db17 : Trie := insertStepsF small7Seg16 small7Db16
noncomputable def small7Db18 : Trie := insertStepsF small7Seg17 small7Db17
noncomputable def small7Db19 : Trie := insertStepsF small7Seg18 small7Db18
noncomputable def small7Db20 : Trie := insertStepsF small7Seg19 small7Db19
noncomputable def small7Db21 : Trie := insertStepsF small7Seg20 small7Db20
noncomputable def small7Db22 : Trie := insertStepsF small7Seg21 small7Db21
noncomputable def small7Db23 : Trie := insertStepsF small7Seg22 small7Db22
noncomputable def small7Db24 : Trie := insertStepsF small7Seg23 small7Db23
noncomputable def small7Db25 : Trie := insertStepsF small7Seg24 small7Db24
noncomputable def small7Db26 : Trie := insertStepsF small7Seg25 small7Db25
noncomputable def small7Db27 : Trie := insertStepsF small7Seg26 small7Db26
noncomputable def small7Db28 : Trie := insertStepsF small7Seg27 small7Db27
noncomputable def small7Db29 : Trie := insertStepsF small7Seg28 small7Db28
noncomputable def small7Db30 : Trie := insertStepsF small7Seg29 small7Db29
noncomputable def small7Db31 : Trie := insertStepsF small7Seg30 small7Db30
noncomputable def small7Db32 : Trie := insertStepsF small7Seg31 small7Db31
noncomputable def small7Db33 : Trie := insertStepsF small7Seg32 small7Db32
noncomputable def small7Db34 : Trie := insertStepsF small7Seg33 small7Db33
noncomputable def small7Db35 : Trie := insertStepsF small7Seg34 small7Db34
noncomputable def small7Db36 : Trie := insertStepsF small7Seg35 small7Db35
noncomputable def small7Db37 : Trie := insertStepsF small7Seg36 small7Db36
noncomputable def small7Db38 : Trie := insertStepsF small7Seg37 small7Db37
noncomputable def small7Db39 : Trie := insertStepsF small7Seg38 small7Db38
noncomputable def small7Db40 : Trie := insertStepsF small7Seg39 small7Db39
noncomputable def small7Db41 : Trie := insertStepsF small7Seg40 small7Db40
noncomputable def small7Db42 : Trie := insertStepsF small7Seg41 small7Db41
noncomputable def small7Db43 : Trie := insertStepsF small7Seg42 small7Db42
noncomputable def small7Db44 : Trie := insertStepsF small7Seg43 small7Db43
noncomputable def small7Db45 : Trie := insertStepsF small7Seg44 small7Db44
noncomputable def small7Db46 : Trie := insertStepsF small7Seg45 small7Db45
noncomputable def small7Db47 : Trie := insertStepsF small7Seg46 small7Db46
noncomputable def small7Db48 : Trie := insertStepsF small7Seg47 small7Db47
noncomputable def small7Db49 : Trie := insertStepsF small7Seg48 small7Db48
noncomputable def small7Db50 : Trie := insertStepsF small7Seg49 small7Db49
noncomputable def small7Db51 : Trie := insertStepsF small7Seg50 small7Db50
noncomputable def small7Db52 : Trie := insertStepsF small7Seg51 small7Db51
noncomputable def small7Db53 : Trie := insertStepsF small7Seg52 small7Db52
noncomputable def small7Db54 : Trie := insertStepsF small7Seg53 small7Db53
noncomputable def small7Db55 : Trie := insertStepsF small7Seg54 small7Db54
noncomputable def small7Db56 : Trie := insertStepsF small7Seg55 small7Db55
noncomputable def small7Db57 : Trie := insertStepsF small7Seg56 small7Db56
noncomputable def small7Db58 : Trie := insertStepsF small7Seg57 small7Db57
noncomputable def small7Db59 : Trie := insertStepsF small7Seg58 small7Db58
noncomputable def small7Db60 : Trie := insertStepsF small7Seg59 small7Db59
noncomputable def small7Db61 : Trie := insertStepsF small7Seg60 small7Db60
noncomputable def small7Db62 : Trie := insertStepsF small7Seg61 small7Db61
noncomputable def small7Db63 : Trie := insertStepsF small7Seg62 small7Db62
noncomputable def small7Db64 : Trie := insertStepsF small7Seg63 small7Db63
noncomputable def small7Db65 : Trie := insertStepsF small7Seg64 small7Db64
noncomputable def small7Db66 : Trie := insertStepsF small7Seg65 small7Db65
noncomputable def small7Db67 : Trie := insertStepsF small7Seg66 small7Db66
noncomputable def small7Db68 : Trie := insertStepsF small7Seg67 small7Db67
noncomputable def small7Db69 : Trie := insertStepsF small7Seg68 small7Db68
noncomputable def small7Db70 : Trie := insertStepsF small7Seg69 small7Db69
noncomputable def small7Db71 : Trie := insertStepsF small7Seg70 small7Db70
noncomputable def small7Db72 : Trie := insertStepsF small7Seg71 small7Db71
noncomputable def small7Db73 : Trie := insertStepsF small7Seg72 small7Db72
noncomputable def small7Db74 : Trie := insertStepsF small7Seg73 small7Db73
noncomputable def small7Db75 : Trie := insertStepsF small7Seg74 small7Db74
noncomputable def small7Db76 : Trie := insertStepsF small7Seg75 small7Db75
noncomputable def small7Db77 : Trie := insertStepsF small7Seg76 small7Db76
noncomputable def small7Db78 : Trie := insertStepsF small7Seg77 small7Db77
noncomputable def small7Db79 : Trie := insertStepsF small7Seg78 small7Db78
noncomputable def small7Db80 : Trie := insertStepsF small7Seg79 small7Db79
noncomputable def small7Db81 : Trie := insertStepsF small7Seg80 small7Db80
noncomputable def small7Db82 : Trie := insertStepsF small7Seg81 small7Db81
noncomputable def small7Db83 : Trie := insertStepsF small7Seg82 small7Db82
noncomputable def small7Db84 : Trie := insertStepsF small7Seg83 small7Db83
noncomputable def small7Db85 : Trie := insertStepsF small7Seg84 small7Db84
noncomputable def small7Db86 : Trie := insertStepsF small7Seg85 small7Db85
noncomputable def small7Db87 : Trie := insertStepsF small7Seg86 small7Db86
noncomputable def small7Db88 : Trie := insertStepsF small7Seg87 small7Db87
noncomputable def small7Db89 : Trie := insertStepsF small7Seg88 small7Db88
noncomputable def small7Db90 : Trie := insertStepsF small7Seg89 small7Db89
noncomputable def small7Db91 : Trie := insertStepsF small7Seg90 small7Db90
noncomputable def small7Db92 : Trie := insertStepsF small7Seg91 small7Db91
noncomputable def small7Db93 : Trie := insertStepsF small7Seg92 small7Db92
noncomputable def small7Db94 : Trie := insertStepsF small7Seg93 small7Db93
noncomputable def small7Db95 : Trie := insertStepsF small7Seg94 small7Db94
noncomputable def small7Db96 : Trie := insertStepsF small7Seg95 small7Db95
noncomputable def small7Db97 : Trie := insertStepsF small7Seg96 small7Db96
noncomputable def small7Db98 : Trie := insertStepsF small7Seg97 small7Db97
noncomputable def small7Db99 : Trie := insertStepsF small7Seg98 small7Db98
noncomputable def small7Db100 : Trie := insertStepsF small7Seg99 small7Db99
noncomputable def small7Db101 : Trie := insertStepsF small7Seg100 small7Db100
noncomputable def small7Db102 : Trie := insertStepsF small7Seg101 small7Db101
noncomputable def small7Db103 : Trie := insertStepsF small7Seg102 small7Db102
noncomputable def small7Db104 : Trie := insertStepsF small7Seg103 small7Db103
noncomputable def small7Db105 : Trie := insertStepsF small7Seg104 small7Db104
theorem small7Seg0_ok : checkSegF small7Seg0 small7Db0 = true := by decide +kernel
theorem small7Seg1_ok : checkSegF small7Seg1 small7Db1 = true := by decide +kernel
theorem small7Seg2_ok : checkSegF small7Seg2 small7Db2 = true := by decide +kernel
theorem small7Seg3_ok : checkSegF small7Seg3 small7Db3 = true := by decide +kernel
theorem small7Seg4_ok : checkSegF small7Seg4 small7Db4 = true := by decide +kernel
theorem small7Seg5_ok : checkSegF small7Seg5 small7Db5 = true := by decide +kernel
theorem small7Seg6_ok : checkSegF small7Seg6 small7Db6 = true := by decide +kernel
theorem small7Seg7_ok : checkSegF small7Seg7 small7Db7 = true := by decide +kernel
theorem small7Seg8_ok : checkSegF small7Seg8 small7Db8 = true := by decide +kernel
theorem small7Seg9_ok : checkSegF small7Seg9 small7Db9 = true := by decide +kernel
theorem small7Seg10_ok : checkSegF small7Seg10 small7Db10 = true := by decide +kernel
theorem small7Seg11_ok : checkSegF small7Seg11 small7Db11 = true := by decide +kernel
theorem small7Seg12_ok : checkSegF small7Seg12 small7Db12 = true := by decide +kernel
theorem small7Seg13_ok : checkSegF small7Seg13 small7Db13 = true := by decide +kernel
theorem small7Seg14_ok : checkSegF small7Seg14 small7Db14 = true := by decide +kernel
theorem small7Seg15_ok : checkSegF small7Seg15 small7Db15 = true := by decide +kernel
theorem small7Seg16_ok : checkSegF small7Seg16 small7Db16 = true := by decide +kernel
theorem small7Seg17_ok : checkSegF small7Seg17 small7Db17 = true := by decide +kernel
theorem small7Seg18_ok : checkSegF small7Seg18 small7Db18 = true := by decide +kernel
theorem small7Seg19_ok : checkSegF small7Seg19 small7Db19 = true := by decide +kernel
theorem small7Seg20_ok : checkSegF small7Seg20 small7Db20 = true := by decide +kernel
theorem small7Seg21_ok : checkSegF small7Seg21 small7Db21 = true := by decide +kernel
theorem small7Seg22_ok : checkSegF small7Seg22 small7Db22 = true := by decide +kernel
theorem small7Seg23_ok : checkSegF small7Seg23 small7Db23 = true := by decide +kernel
theorem small7Seg24_ok : checkSegF small7Seg24 small7Db24 = true := by decide +kernel
theorem small7Seg25_ok : checkSegF small7Seg25 small7Db25 = true := by decide +kernel
theorem small7Seg26_ok : checkSegF small7Seg26 small7Db26 = true := by decide +kernel
theorem small7Seg27_ok : checkSegF small7Seg27 small7Db27 = true := by decide +kernel
theorem small7Seg28_ok : checkSegF small7Seg28 small7Db28 = true := by decide +kernel
theorem small7Seg29_ok : checkSegF small7Seg29 small7Db29 = true := by decide +kernel
theorem small7Seg30_ok : checkSegF small7Seg30 small7Db30 = true := by decide +kernel
theorem small7Seg31_ok : checkSegF small7Seg31 small7Db31 = true := by decide +kernel
theorem small7Seg32_ok : checkSegF small7Seg32 small7Db32 = true := by decide +kernel
theorem small7Seg33_ok : checkSegF small7Seg33 small7Db33 = true := by decide +kernel
theorem small7Seg34_ok : checkSegF small7Seg34 small7Db34 = true := by decide +kernel
theorem small7Seg35_ok : checkSegF small7Seg35 small7Db35 = true := by decide +kernel
theorem small7Seg36_ok : checkSegF small7Seg36 small7Db36 = true := by decide +kernel
theorem small7Seg37_ok : checkSegF small7Seg37 small7Db37 = true := by decide +kernel
theorem small7Seg38_ok : checkSegF small7Seg38 small7Db38 = true := by decide +kernel
theorem small7Seg39_ok : checkSegF small7Seg39 small7Db39 = true := by decide +kernel
theorem small7Seg40_ok : checkSegF small7Seg40 small7Db40 = true := by decide +kernel
theorem small7Seg41_ok : checkSegF small7Seg41 small7Db41 = true := by decide +kernel
theorem small7Seg42_ok : checkSegF small7Seg42 small7Db42 = true := by decide +kernel
theorem small7Seg43_ok : checkSegF small7Seg43 small7Db43 = true := by decide +kernel
theorem small7Seg44_ok : checkSegF small7Seg44 small7Db44 = true := by decide +kernel
theorem small7Seg45_ok : checkSegF small7Seg45 small7Db45 = true := by decide +kernel
theorem small7Seg46_ok : checkSegF small7Seg46 small7Db46 = true := by decide +kernel
theorem small7Seg47_ok : checkSegF small7Seg47 small7Db47 = true := by decide +kernel
theorem small7Seg48_ok : checkSegF small7Seg48 small7Db48 = true := by decide +kernel
theorem small7Seg49_ok : checkSegF small7Seg49 small7Db49 = true := by decide +kernel
theorem small7Seg50_ok : checkSegF small7Seg50 small7Db50 = true := by decide +kernel
theorem small7Seg51_ok : checkSegF small7Seg51 small7Db51 = true := by decide +kernel
theorem small7Seg52_ok : checkSegF small7Seg52 small7Db52 = true := by decide +kernel
theorem small7Seg53_ok : checkSegF small7Seg53 small7Db53 = true := by decide +kernel
theorem small7Seg54_ok : checkSegF small7Seg54 small7Db54 = true := by decide +kernel
theorem small7Seg55_ok : checkSegF small7Seg55 small7Db55 = true := by decide +kernel
theorem small7Seg56_ok : checkSegF small7Seg56 small7Db56 = true := by decide +kernel
theorem small7Seg57_ok : checkSegF small7Seg57 small7Db57 = true := by decide +kernel
theorem small7Seg58_ok : checkSegF small7Seg58 small7Db58 = true := by decide +kernel
theorem small7Seg59_ok : checkSegF small7Seg59 small7Db59 = true := by decide +kernel
theorem small7Seg60_ok : checkSegF small7Seg60 small7Db60 = true := by decide +kernel
theorem small7Seg61_ok : checkSegF small7Seg61 small7Db61 = true := by decide +kernel
theorem small7Seg62_ok : checkSegF small7Seg62 small7Db62 = true := by decide +kernel
theorem small7Seg63_ok : checkSegF small7Seg63 small7Db63 = true := by decide +kernel
theorem small7Seg64_ok : checkSegF small7Seg64 small7Db64 = true := by decide +kernel
theorem small7Seg65_ok : checkSegF small7Seg65 small7Db65 = true := by decide +kernel
theorem small7Seg66_ok : checkSegF small7Seg66 small7Db66 = true := by decide +kernel
theorem small7Seg67_ok : checkSegF small7Seg67 small7Db67 = true := by decide +kernel
theorem small7Seg68_ok : checkSegF small7Seg68 small7Db68 = true := by decide +kernel
theorem small7Seg69_ok : checkSegF small7Seg69 small7Db69 = true := by decide +kernel
theorem small7Seg70_ok : checkSegF small7Seg70 small7Db70 = true := by decide +kernel
theorem small7Seg71_ok : checkSegF small7Seg71 small7Db71 = true := by decide +kernel
theorem small7Seg72_ok : checkSegF small7Seg72 small7Db72 = true := by decide +kernel
theorem small7Seg73_ok : checkSegF small7Seg73 small7Db73 = true := by decide +kernel
theorem small7Seg74_ok : checkSegF small7Seg74 small7Db74 = true := by decide +kernel
theorem small7Seg75_ok : checkSegF small7Seg75 small7Db75 = true := by decide +kernel
theorem small7Seg76_ok : checkSegF small7Seg76 small7Db76 = true := by decide +kernel
theorem small7Seg77_ok : checkSegF small7Seg77 small7Db77 = true := by decide +kernel
theorem small7Seg78_ok : checkSegF small7Seg78 small7Db78 = true := by decide +kernel
theorem small7Seg79_ok : checkSegF small7Seg79 small7Db79 = true := by decide +kernel
theorem small7Seg80_ok : checkSegF small7Seg80 small7Db80 = true := by decide +kernel
theorem small7Seg81_ok : checkSegF small7Seg81 small7Db81 = true := by decide +kernel
theorem small7Seg82_ok : checkSegF small7Seg82 small7Db82 = true := by decide +kernel
theorem small7Seg83_ok : checkSegF small7Seg83 small7Db83 = true := by decide +kernel
theorem small7Seg84_ok : checkSegF small7Seg84 small7Db84 = true := by decide +kernel
theorem small7Seg85_ok : checkSegF small7Seg85 small7Db85 = true := by decide +kernel
theorem small7Seg86_ok : checkSegF small7Seg86 small7Db86 = true := by decide +kernel
theorem small7Seg87_ok : checkSegF small7Seg87 small7Db87 = true := by decide +kernel
theorem small7Seg88_ok : checkSegF small7Seg88 small7Db88 = true := by decide +kernel
theorem small7Seg89_ok : checkSegF small7Seg89 small7Db89 = true := by decide +kernel
theorem small7Seg90_ok : checkSegF small7Seg90 small7Db90 = true := by decide +kernel
theorem small7Seg91_ok : checkSegF small7Seg91 small7Db91 = true := by decide +kernel
theorem small7Seg92_ok : checkSegF small7Seg92 small7Db92 = true := by decide +kernel
theorem small7Seg93_ok : checkSegF small7Seg93 small7Db93 = true := by decide +kernel
theorem small7Seg94_ok : checkSegF small7Seg94 small7Db94 = true := by decide +kernel
theorem small7Seg95_ok : checkSegF small7Seg95 small7Db95 = true := by decide +kernel
theorem small7Seg96_ok : checkSegF small7Seg96 small7Db96 = true := by decide +kernel
theorem small7Seg97_ok : checkSegF small7Seg97 small7Db97 = true := by decide +kernel
theorem small7Seg98_ok : checkSegF small7Seg98 small7Db98 = true := by decide +kernel
theorem small7Seg99_ok : checkSegF small7Seg99 small7Db99 = true := by decide +kernel
theorem small7Seg100_ok : checkSegF small7Seg100 small7Db100 = true := by decide +kernel
theorem small7Seg101_ok : checkSegF small7Seg101 small7Db101 = true := by decide +kernel
theorem small7Seg102_ok : checkSegF small7Seg102 small7Db102 = true := by decide +kernel
theorem small7Seg103_ok : checkSegF small7Seg103 small7Db103 = true := by decide +kernel
theorem small7Seg104_ok : checkSegF small7Seg104 small7Db104 = true := by decide +kernel

def small7Segs : List (List Step) := [small7Seg0, small7Seg1, small7Seg2, small7Seg3, small7Seg4, small7Seg5, small7Seg6, small7Seg7, small7Seg8, small7Seg9, small7Seg10, small7Seg11, small7Seg12, small7Seg13, small7Seg14, small7Seg15, small7Seg16, small7Seg17, small7Seg18, small7Seg19, small7Seg20, small7Seg21, small7Seg22, small7Seg23, small7Seg24, small7Seg25, small7Seg26, small7Seg27, small7Seg28, small7Seg29, small7Seg30, small7Seg31, small7Seg32, small7Seg33, small7Seg34, small7Seg35, small7Seg36, small7Seg37, small7Seg38, small7Seg39, small7Seg40, small7Seg41, small7Seg42, small7Seg43, small7Seg44, small7Seg45, small7Seg46, small7Seg47, small7Seg48, small7Seg49, small7Seg50, small7Seg51, small7Seg52, small7Seg53, small7Seg54, small7Seg55, small7Seg56, small7Seg57, small7Seg58, small7Seg59, small7Seg60, small7Seg61, small7Seg62, small7Seg63, small7Seg64, small7Seg65, small7Seg66, small7Seg67, small7Seg68, small7Seg69, small7Seg70, small7Seg71, small7Seg72, small7Seg73, small7Seg74, small7Seg75, small7Seg76, small7Seg77, small7Seg78, small7Seg79, small7Seg80, small7Seg81, small7Seg82, small7Seg83, small7Seg84, small7Seg85, small7Seg86, small7Seg87, small7Seg88, small7Seg89, small7Seg90, small7Seg91, small7Seg92, small7Seg93, small7Seg94, small7Seg95, small7Seg96, small7Seg97, small7Seg98, small7Seg99, small7Seg100, small7Seg101, small7Seg102, small7Seg103, small7Seg104]

theorem small7Segs_okF : SegsOKF small7Db0 small7Segs := by
  simp only [small7Segs, SegsOKF]
  exact ⟨small7Seg0_ok, small7Seg1_ok, small7Seg2_ok, small7Seg3_ok, small7Seg4_ok, small7Seg5_ok, small7Seg6_ok, small7Seg7_ok, small7Seg8_ok, small7Seg9_ok, small7Seg10_ok, small7Seg11_ok, small7Seg12_ok, small7Seg13_ok, small7Seg14_ok, small7Seg15_ok, small7Seg16_ok, small7Seg17_ok, small7Seg18_ok, small7Seg19_ok, small7Seg20_ok, small7Seg21_ok, small7Seg22_ok, small7Seg23_ok, small7Seg24_ok, small7Seg25_ok, small7Seg26_ok, small7Seg27_ok, small7Seg28_ok, small7Seg29_ok, small7Seg30_ok, small7Seg31_ok, small7Seg32_ok, small7Seg33_ok, small7Seg34_ok, small7Seg35_ok, small7Seg36_ok, small7Seg37_ok, small7Seg38_ok, small7Seg39_ok, small7Seg40_ok, small7Seg41_ok, small7Seg42_ok, small7Seg43_ok, small7Seg44_ok, small7Seg45_ok, small7Seg46_ok, small7Seg47_ok, small7Seg48_ok, small7Seg49_ok, small7Seg50_ok, small7Seg51_ok, small7Seg52_ok, small7Seg53_ok, small7Seg54_ok, small7Seg55_ok, small7Seg56_ok, small7Seg57_ok, small7Seg58_ok, small7Seg59_ok, small7Seg60_ok, small7Seg61_ok, small7Seg62_ok, small7Seg63_ok, small7Seg64_ok, small7Seg65_ok, small7Seg66_ok, small7Seg67_ok, small7Seg68_ok, small7Seg69_ok, small7Seg70_ok, small7Seg71_ok, small7Seg72_ok, small7Seg73_ok, small7Seg74_ok, small7Seg75_ok, small7Seg76_ok, small7Seg77_ok, small7Seg78_ok, small7Seg79_ok, small7Seg80_ok, small7Seg81_ok, small7Seg82_ok, small7Seg83_ok, small7Seg84_ok, small7Seg85_ok, small7Seg86_ok, small7Seg87_ok, small7Seg88_ok, small7Seg89_ok, small7Seg90_ok, small7Seg91_ok, small7Seg92_ok, small7Seg93_ok, small7Seg94_ok, small7Seg95_ok, small7Seg96_ok, small7Seg97_ok, small7Seg98_ok, small7Seg99_ok, small7Seg100_ok, small7Seg101_ok, small7Seg102_ok, small7Seg103_ok, small7Seg104_ok, trivial⟩

theorem small7Segs_empty : small7Segs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem small7_unsat (v : Nat → Bool) : ∃ c ∈ small7CNF, clauseEval v c = false := by
  have h := segsOKF_iff small7Segs small7Db0 small7Segs_okF
  rw [show small7Db0 = buildDB .leaf 1 small7CNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs small7CNF small7Segs h small7Segs_empty v

theorem small7_ids : idsInRange 502 small7Edges [1] [] = true := by decide +kernel
theorem small7_edges : edgesOK 7 small7Edges = true := by decide +kernel

theorem small7_case (c : Nat → Fin 3) (h1 : c 1 = 0) : WeakMono 7 (F 7) c :=
  direct_case 7 small7Edges (by decide) small7_ids small7_edges small7_unsat c h1

end RSN
