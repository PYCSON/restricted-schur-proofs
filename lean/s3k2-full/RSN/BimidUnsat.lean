module

public import RSN.CaseCNF
public import RSN.Fast
public import RSN.Data.Bimid
public import RSN.Data.BimidSeg0
public import RSN.Data.BimidSeg1
public import RSN.Data.BimidSeg2
public import RSN.Data.BimidSeg3
public import RSN.Data.BimidSeg4
public import RSN.Data.BimidSeg5
public import RSN.Data.BimidSeg6
public import RSN.Data.BimidSeg7

/-! # Kernel check of the LRAT proof for `bimid` (generated) -/

@[expose] public section

namespace RSN

def bimidCNF : List Clause := caseCNF bimidN bimidEdges bimidReds bimidBlues

noncomputable def bimidDb0 : Trie := buildDBF bimidCNF .leaf 1
noncomputable def bimidDb1 : Trie := insertStepsF bimidSeg0 bimidDb0
noncomputable def bimidDb2 : Trie := insertStepsF bimidSeg1 bimidDb1
noncomputable def bimidDb3 : Trie := insertStepsF bimidSeg2 bimidDb2
noncomputable def bimidDb4 : Trie := insertStepsF bimidSeg3 bimidDb3
noncomputable def bimidDb5 : Trie := insertStepsF bimidSeg4 bimidDb4
noncomputable def bimidDb6 : Trie := insertStepsF bimidSeg5 bimidDb5
noncomputable def bimidDb7 : Trie := insertStepsF bimidSeg6 bimidDb6
noncomputable def bimidDb8 : Trie := insertStepsF bimidSeg7 bimidDb7
noncomputable def bimidDb9 : Trie := insertStepsF bimidSeg8 bimidDb8
noncomputable def bimidDb10 : Trie := insertStepsF bimidSeg9 bimidDb9
noncomputable def bimidDb11 : Trie := insertStepsF bimidSeg10 bimidDb10
noncomputable def bimidDb12 : Trie := insertStepsF bimidSeg11 bimidDb11
noncomputable def bimidDb13 : Trie := insertStepsF bimidSeg12 bimidDb12
noncomputable def bimidDb14 : Trie := insertStepsF bimidSeg13 bimidDb13
noncomputable def bimidDb15 : Trie := insertStepsF bimidSeg14 bimidDb14
noncomputable def bimidDb16 : Trie := insertStepsF bimidSeg15 bimidDb15
noncomputable def bimidDb17 : Trie := insertStepsF bimidSeg16 bimidDb16
noncomputable def bimidDb18 : Trie := insertStepsF bimidSeg17 bimidDb17
noncomputable def bimidDb19 : Trie := insertStepsF bimidSeg18 bimidDb18
noncomputable def bimidDb20 : Trie := insertStepsF bimidSeg19 bimidDb19
noncomputable def bimidDb21 : Trie := insertStepsF bimidSeg20 bimidDb20
noncomputable def bimidDb22 : Trie := insertStepsF bimidSeg21 bimidDb21
noncomputable def bimidDb23 : Trie := insertStepsF bimidSeg22 bimidDb22
noncomputable def bimidDb24 : Trie := insertStepsF bimidSeg23 bimidDb23
noncomputable def bimidDb25 : Trie := insertStepsF bimidSeg24 bimidDb24
noncomputable def bimidDb26 : Trie := insertStepsF bimidSeg25 bimidDb25
noncomputable def bimidDb27 : Trie := insertStepsF bimidSeg26 bimidDb26
noncomputable def bimidDb28 : Trie := insertStepsF bimidSeg27 bimidDb27
noncomputable def bimidDb29 : Trie := insertStepsF bimidSeg28 bimidDb28
noncomputable def bimidDb30 : Trie := insertStepsF bimidSeg29 bimidDb29
noncomputable def bimidDb31 : Trie := insertStepsF bimidSeg30 bimidDb30
noncomputable def bimidDb32 : Trie := insertStepsF bimidSeg31 bimidDb31
noncomputable def bimidDb33 : Trie := insertStepsF bimidSeg32 bimidDb32
noncomputable def bimidDb34 : Trie := insertStepsF bimidSeg33 bimidDb33
noncomputable def bimidDb35 : Trie := insertStepsF bimidSeg34 bimidDb34
noncomputable def bimidDb36 : Trie := insertStepsF bimidSeg35 bimidDb35
noncomputable def bimidDb37 : Trie := insertStepsF bimidSeg36 bimidDb36
noncomputable def bimidDb38 : Trie := insertStepsF bimidSeg37 bimidDb37
noncomputable def bimidDb39 : Trie := insertStepsF bimidSeg38 bimidDb38
noncomputable def bimidDb40 : Trie := insertStepsF bimidSeg39 bimidDb39
noncomputable def bimidDb41 : Trie := insertStepsF bimidSeg40 bimidDb40
noncomputable def bimidDb42 : Trie := insertStepsF bimidSeg41 bimidDb41
noncomputable def bimidDb43 : Trie := insertStepsF bimidSeg42 bimidDb42
noncomputable def bimidDb44 : Trie := insertStepsF bimidSeg43 bimidDb43
noncomputable def bimidDb45 : Trie := insertStepsF bimidSeg44 bimidDb44
noncomputable def bimidDb46 : Trie := insertStepsF bimidSeg45 bimidDb45
noncomputable def bimidDb47 : Trie := insertStepsF bimidSeg46 bimidDb46
noncomputable def bimidDb48 : Trie := insertStepsF bimidSeg47 bimidDb47
noncomputable def bimidDb49 : Trie := insertStepsF bimidSeg48 bimidDb48
noncomputable def bimidDb50 : Trie := insertStepsF bimidSeg49 bimidDb49
noncomputable def bimidDb51 : Trie := insertStepsF bimidSeg50 bimidDb50
noncomputable def bimidDb52 : Trie := insertStepsF bimidSeg51 bimidDb51
noncomputable def bimidDb53 : Trie := insertStepsF bimidSeg52 bimidDb52
noncomputable def bimidDb54 : Trie := insertStepsF bimidSeg53 bimidDb53
noncomputable def bimidDb55 : Trie := insertStepsF bimidSeg54 bimidDb54
noncomputable def bimidDb56 : Trie := insertStepsF bimidSeg55 bimidDb55
noncomputable def bimidDb57 : Trie := insertStepsF bimidSeg56 bimidDb56
noncomputable def bimidDb58 : Trie := insertStepsF bimidSeg57 bimidDb57
noncomputable def bimidDb59 : Trie := insertStepsF bimidSeg58 bimidDb58
noncomputable def bimidDb60 : Trie := insertStepsF bimidSeg59 bimidDb59
noncomputable def bimidDb61 : Trie := insertStepsF bimidSeg60 bimidDb60
noncomputable def bimidDb62 : Trie := insertStepsF bimidSeg61 bimidDb61
noncomputable def bimidDb63 : Trie := insertStepsF bimidSeg62 bimidDb62
noncomputable def bimidDb64 : Trie := insertStepsF bimidSeg63 bimidDb63
noncomputable def bimidDb65 : Trie := insertStepsF bimidSeg64 bimidDb64
noncomputable def bimidDb66 : Trie := insertStepsF bimidSeg65 bimidDb65
noncomputable def bimidDb67 : Trie := insertStepsF bimidSeg66 bimidDb66
noncomputable def bimidDb68 : Trie := insertStepsF bimidSeg67 bimidDb67
noncomputable def bimidDb69 : Trie := insertStepsF bimidSeg68 bimidDb68
noncomputable def bimidDb70 : Trie := insertStepsF bimidSeg69 bimidDb69
noncomputable def bimidDb71 : Trie := insertStepsF bimidSeg70 bimidDb70
theorem bimidSeg0_ok : checkSegF bimidSeg0 bimidDb0 = true := by decide +kernel
theorem bimidSeg1_ok : checkSegF bimidSeg1 bimidDb1 = true := by decide +kernel
theorem bimidSeg2_ok : checkSegF bimidSeg2 bimidDb2 = true := by decide +kernel
theorem bimidSeg3_ok : checkSegF bimidSeg3 bimidDb3 = true := by decide +kernel
theorem bimidSeg4_ok : checkSegF bimidSeg4 bimidDb4 = true := by decide +kernel
theorem bimidSeg5_ok : checkSegF bimidSeg5 bimidDb5 = true := by decide +kernel
theorem bimidSeg6_ok : checkSegF bimidSeg6 bimidDb6 = true := by decide +kernel
theorem bimidSeg7_ok : checkSegF bimidSeg7 bimidDb7 = true := by decide +kernel
theorem bimidSeg8_ok : checkSegF bimidSeg8 bimidDb8 = true := by decide +kernel
theorem bimidSeg9_ok : checkSegF bimidSeg9 bimidDb9 = true := by decide +kernel
theorem bimidSeg10_ok : checkSegF bimidSeg10 bimidDb10 = true := by decide +kernel
theorem bimidSeg11_ok : checkSegF bimidSeg11 bimidDb11 = true := by decide +kernel
theorem bimidSeg12_ok : checkSegF bimidSeg12 bimidDb12 = true := by decide +kernel
theorem bimidSeg13_ok : checkSegF bimidSeg13 bimidDb13 = true := by decide +kernel
theorem bimidSeg14_ok : checkSegF bimidSeg14 bimidDb14 = true := by decide +kernel
theorem bimidSeg15_ok : checkSegF bimidSeg15 bimidDb15 = true := by decide +kernel
theorem bimidSeg16_ok : checkSegF bimidSeg16 bimidDb16 = true := by decide +kernel
theorem bimidSeg17_ok : checkSegF bimidSeg17 bimidDb17 = true := by decide +kernel
theorem bimidSeg18_ok : checkSegF bimidSeg18 bimidDb18 = true := by decide +kernel
theorem bimidSeg19_ok : checkSegF bimidSeg19 bimidDb19 = true := by decide +kernel
theorem bimidSeg20_ok : checkSegF bimidSeg20 bimidDb20 = true := by decide +kernel
theorem bimidSeg21_ok : checkSegF bimidSeg21 bimidDb21 = true := by decide +kernel
theorem bimidSeg22_ok : checkSegF bimidSeg22 bimidDb22 = true := by decide +kernel
theorem bimidSeg23_ok : checkSegF bimidSeg23 bimidDb23 = true := by decide +kernel
theorem bimidSeg24_ok : checkSegF bimidSeg24 bimidDb24 = true := by decide +kernel
theorem bimidSeg25_ok : checkSegF bimidSeg25 bimidDb25 = true := by decide +kernel
theorem bimidSeg26_ok : checkSegF bimidSeg26 bimidDb26 = true := by decide +kernel
theorem bimidSeg27_ok : checkSegF bimidSeg27 bimidDb27 = true := by decide +kernel
theorem bimidSeg28_ok : checkSegF bimidSeg28 bimidDb28 = true := by decide +kernel
theorem bimidSeg29_ok : checkSegF bimidSeg29 bimidDb29 = true := by decide +kernel
theorem bimidSeg30_ok : checkSegF bimidSeg30 bimidDb30 = true := by decide +kernel
theorem bimidSeg31_ok : checkSegF bimidSeg31 bimidDb31 = true := by decide +kernel
theorem bimidSeg32_ok : checkSegF bimidSeg32 bimidDb32 = true := by decide +kernel
theorem bimidSeg33_ok : checkSegF bimidSeg33 bimidDb33 = true := by decide +kernel
theorem bimidSeg34_ok : checkSegF bimidSeg34 bimidDb34 = true := by decide +kernel
theorem bimidSeg35_ok : checkSegF bimidSeg35 bimidDb35 = true := by decide +kernel
theorem bimidSeg36_ok : checkSegF bimidSeg36 bimidDb36 = true := by decide +kernel
theorem bimidSeg37_ok : checkSegF bimidSeg37 bimidDb37 = true := by decide +kernel
theorem bimidSeg38_ok : checkSegF bimidSeg38 bimidDb38 = true := by decide +kernel
theorem bimidSeg39_ok : checkSegF bimidSeg39 bimidDb39 = true := by decide +kernel
theorem bimidSeg40_ok : checkSegF bimidSeg40 bimidDb40 = true := by decide +kernel
theorem bimidSeg41_ok : checkSegF bimidSeg41 bimidDb41 = true := by decide +kernel
theorem bimidSeg42_ok : checkSegF bimidSeg42 bimidDb42 = true := by decide +kernel
theorem bimidSeg43_ok : checkSegF bimidSeg43 bimidDb43 = true := by decide +kernel
theorem bimidSeg44_ok : checkSegF bimidSeg44 bimidDb44 = true := by decide +kernel
theorem bimidSeg45_ok : checkSegF bimidSeg45 bimidDb45 = true := by decide +kernel
theorem bimidSeg46_ok : checkSegF bimidSeg46 bimidDb46 = true := by decide +kernel
theorem bimidSeg47_ok : checkSegF bimidSeg47 bimidDb47 = true := by decide +kernel
theorem bimidSeg48_ok : checkSegF bimidSeg48 bimidDb48 = true := by decide +kernel
theorem bimidSeg49_ok : checkSegF bimidSeg49 bimidDb49 = true := by decide +kernel
theorem bimidSeg50_ok : checkSegF bimidSeg50 bimidDb50 = true := by decide +kernel
theorem bimidSeg51_ok : checkSegF bimidSeg51 bimidDb51 = true := by decide +kernel
theorem bimidSeg52_ok : checkSegF bimidSeg52 bimidDb52 = true := by decide +kernel
theorem bimidSeg53_ok : checkSegF bimidSeg53 bimidDb53 = true := by decide +kernel
theorem bimidSeg54_ok : checkSegF bimidSeg54 bimidDb54 = true := by decide +kernel
theorem bimidSeg55_ok : checkSegF bimidSeg55 bimidDb55 = true := by decide +kernel
theorem bimidSeg56_ok : checkSegF bimidSeg56 bimidDb56 = true := by decide +kernel
theorem bimidSeg57_ok : checkSegF bimidSeg57 bimidDb57 = true := by decide +kernel
theorem bimidSeg58_ok : checkSegF bimidSeg58 bimidDb58 = true := by decide +kernel
theorem bimidSeg59_ok : checkSegF bimidSeg59 bimidDb59 = true := by decide +kernel
theorem bimidSeg60_ok : checkSegF bimidSeg60 bimidDb60 = true := by decide +kernel
theorem bimidSeg61_ok : checkSegF bimidSeg61 bimidDb61 = true := by decide +kernel
theorem bimidSeg62_ok : checkSegF bimidSeg62 bimidDb62 = true := by decide +kernel
theorem bimidSeg63_ok : checkSegF bimidSeg63 bimidDb63 = true := by decide +kernel
theorem bimidSeg64_ok : checkSegF bimidSeg64 bimidDb64 = true := by decide +kernel
theorem bimidSeg65_ok : checkSegF bimidSeg65 bimidDb65 = true := by decide +kernel
theorem bimidSeg66_ok : checkSegF bimidSeg66 bimidDb66 = true := by decide +kernel
theorem bimidSeg67_ok : checkSegF bimidSeg67 bimidDb67 = true := by decide +kernel
theorem bimidSeg68_ok : checkSegF bimidSeg68 bimidDb68 = true := by decide +kernel
theorem bimidSeg69_ok : checkSegF bimidSeg69 bimidDb69 = true := by decide +kernel
theorem bimidSeg70_ok : checkSegF bimidSeg70 bimidDb70 = true := by decide +kernel

def bimidSegs : List (List Step) := [bimidSeg0, bimidSeg1, bimidSeg2, bimidSeg3, bimidSeg4, bimidSeg5, bimidSeg6, bimidSeg7, bimidSeg8, bimidSeg9, bimidSeg10, bimidSeg11, bimidSeg12, bimidSeg13, bimidSeg14, bimidSeg15, bimidSeg16, bimidSeg17, bimidSeg18, bimidSeg19, bimidSeg20, bimidSeg21, bimidSeg22, bimidSeg23, bimidSeg24, bimidSeg25, bimidSeg26, bimidSeg27, bimidSeg28, bimidSeg29, bimidSeg30, bimidSeg31, bimidSeg32, bimidSeg33, bimidSeg34, bimidSeg35, bimidSeg36, bimidSeg37, bimidSeg38, bimidSeg39, bimidSeg40, bimidSeg41, bimidSeg42, bimidSeg43, bimidSeg44, bimidSeg45, bimidSeg46, bimidSeg47, bimidSeg48, bimidSeg49, bimidSeg50, bimidSeg51, bimidSeg52, bimidSeg53, bimidSeg54, bimidSeg55, bimidSeg56, bimidSeg57, bimidSeg58, bimidSeg59, bimidSeg60, bimidSeg61, bimidSeg62, bimidSeg63, bimidSeg64, bimidSeg65, bimidSeg66, bimidSeg67, bimidSeg68, bimidSeg69, bimidSeg70]

theorem bimidSegs_okF : SegsOKF bimidDb0 bimidSegs := by
  simp only [bimidSegs, SegsOKF]
  exact ⟨bimidSeg0_ok, bimidSeg1_ok, bimidSeg2_ok, bimidSeg3_ok, bimidSeg4_ok, bimidSeg5_ok, bimidSeg6_ok, bimidSeg7_ok, bimidSeg8_ok, bimidSeg9_ok, bimidSeg10_ok, bimidSeg11_ok, bimidSeg12_ok, bimidSeg13_ok, bimidSeg14_ok, bimidSeg15_ok, bimidSeg16_ok, bimidSeg17_ok, bimidSeg18_ok, bimidSeg19_ok, bimidSeg20_ok, bimidSeg21_ok, bimidSeg22_ok, bimidSeg23_ok, bimidSeg24_ok, bimidSeg25_ok, bimidSeg26_ok, bimidSeg27_ok, bimidSeg28_ok, bimidSeg29_ok, bimidSeg30_ok, bimidSeg31_ok, bimidSeg32_ok, bimidSeg33_ok, bimidSeg34_ok, bimidSeg35_ok, bimidSeg36_ok, bimidSeg37_ok, bimidSeg38_ok, bimidSeg39_ok, bimidSeg40_ok, bimidSeg41_ok, bimidSeg42_ok, bimidSeg43_ok, bimidSeg44_ok, bimidSeg45_ok, bimidSeg46_ok, bimidSeg47_ok, bimidSeg48_ok, bimidSeg49_ok, bimidSeg50_ok, bimidSeg51_ok, bimidSeg52_ok, bimidSeg53_ok, bimidSeg54_ok, bimidSeg55_ok, bimidSeg56_ok, bimidSeg57_ok, bimidSeg58_ok, bimidSeg59_ok, bimidSeg60_ok, bimidSeg61_ok, bimidSeg62_ok, bimidSeg63_ok, bimidSeg64_ok, bimidSeg65_ok, bimidSeg66_ok, bimidSeg67_ok, bimidSeg68_ok, bimidSeg69_ok, bimidSeg70_ok, trivial⟩

theorem bimidSegs_empty : bimidSegs.flatten.any (fun s => s.clause.isEmpty) = true := by decide +kernel

/-- **The CNF is unsatisfiable** (kernel-checked LRAT proof). -/
theorem bimid_unsat (v : Nat → Bool) : ∃ c ∈ bimidCNF, clauseEval v c = false := by
  have h := segsOKF_iff bimidSegs bimidDb0 bimidSegs_okF
  rw [show bimidDb0 = buildDB .leaf 1 bimidCNF from buildDBF_eq _ _ _] at h
  exact unsat_of_segs bimidCNF bimidSegs h bimidSegs_empty v

end RSN
