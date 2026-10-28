module

public import RSN.UniCase
public import RSN.Top1Unsat

/-! # Case `a = k - 1` (`uni_top1`) -/

@[expose] public section

namespace RSN

def top1A : List Int := [7, 1]

theorem top1_ids : idsInRange top1N top1Edges top1Reds top1Blues = true := by decide +kernel
theorem top1_verts : vertsOK top1N top1Verts = true := by decide +kernel
theorem top1_ident : identOK top1Verts top1Edges = true := by decide +kernel
theorem top1_dist : distOK top1Verts top1Edges = true := by decide +kernel
theorem top1_red : redOK top1Verts top1A top1Reds = true := by decide +kernel
theorem top1_blue : blueOK top1Verts top1A top1Blues = true := by decide +kernel

/-- **Case `a = k - 1`.** For every `k ≥ 8` and every 3-colouring `c` with `[1, k - 1]` of colour 0 and `k - 1 + 1` of colour 1,
there is a weak monochromatic solution in `[1, F k]`. -/
theorem top1_case (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ k - 1 → c j = 0) (hB : c (k - 1 + 1) = 1) : WeakMono k (F k) c := by
  obtain ⟨t, rfl⟩ : ∃ t, k = t + 8 := ⟨k - 8, by omega⟩
  refine uni_case top1N top1Verts top1Edges top1Reds top1Blues top1A top1_ids top1_verts top1_ident
    top1_dist top1_red top1_blue top1_unsat t c ?_ ?_
  · intro j h1 h2
    simp only [top1A, peval] at h2
    exact hR j h1 (by omega)
  · intro j h
    simp only [top1A, peval] at h
    have : j = t + 8 - 1 + 1 := by omega
    rw [this]; exact hB

end RSN
