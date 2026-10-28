module

public import RSN.UniCase
public import RSN.Top2Unsat

/-! # Case `a = k - 2` (`uni_top2`) -/

@[expose] public section

namespace RSN

def top2A : List Int := [6, 1]

theorem top2_ids : idsInRange top2N top2Edges top2Reds top2Blues = true := by decide +kernel
theorem top2_verts : vertsOK top2N top2Verts = true := by decide +kernel
theorem top2_ident : identOK top2Verts top2Edges = true := by decide +kernel
theorem top2_dist : distOK top2Verts top2Edges = true := by decide +kernel
theorem top2_red : redOK top2Verts top2A top2Reds = true := by decide +kernel
theorem top2_blue : blueOK top2Verts top2A top2Blues = true := by decide +kernel

/-- **Case `a = k - 2`.** For every `k ≥ 8` and every 3-colouring `c` with `[1, k - 2]` of colour 0 and `k - 2 + 1` of colour 1,
there is a weak monochromatic solution in `[1, F k]`. -/
theorem top2_case (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ k - 2 → c j = 0) (hB : c (k - 2 + 1) = 1) : WeakMono k (F k) c := by
  obtain ⟨t, rfl⟩ : ∃ t, k = t + 8 := ⟨k - 8, by omega⟩
  refine uni_case top2N top2Verts top2Edges top2Reds top2Blues top2A top2_ids top2_verts top2_ident
    top2_dist top2_red top2_blue top2_unsat t c ?_ ?_
  · intro j h1 h2
    simp only [top2A, peval] at h2
    exact hR j h1 (by omega)
  · intro j h
    simp only [top2A, peval] at h
    have : j = t + 8 - 2 + 1 := by omega
    rw [this]; exact hB

end RSN
