module

public import RSN.UniCase
public import RSN.Const2Unsat

/-! # Case `a = 2` (`uni_const2`) -/

@[expose] public section

namespace RSN

def const2A : List Int := [2]

theorem const2_ids : idsInRange const2N const2Edges const2Reds const2Blues = true := by decide +kernel
theorem const2_verts : vertsOK const2N const2Verts = true := by decide +kernel
theorem const2_ident : identOK const2Verts const2Edges = true := by decide +kernel
theorem const2_dist : distOK const2Verts const2Edges = true := by decide +kernel
theorem const2_red : redOK const2Verts const2A const2Reds = true := by decide +kernel
theorem const2_blue : blueOK const2Verts const2A const2Blues = true := by decide +kernel

/-- **Case `a = 2`.** For every `k ≥ 8` and every 3-colouring `c` with `[1, 2]` of colour 0 and `3` of colour 1,
there is a weak monochromatic solution in `[1, F k]`. -/
theorem const2_case (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ 2 → c j = 0) (hB : c 3 = 1) : WeakMono k (F k) c := by
  obtain ⟨t, rfl⟩ : ∃ t, k = t + 8 := ⟨k - 8, by omega⟩
  refine uni_case const2N const2Verts const2Edges const2Reds const2Blues const2A const2_ids const2_verts const2_ident
    const2_dist const2_red const2_blue const2_unsat t c ?_ ?_
  · intro j h1 h2
    simp only [const2A, peval] at h2
    exact hR j h1 (by omega)
  · intro j h
    simp only [const2A, peval] at h
    have : j = 3 := by omega
    rw [this]; exact hB

end RSN
