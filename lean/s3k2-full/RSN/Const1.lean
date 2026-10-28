module

public import RSN.UniCase
public import RSN.Const1Unsat

/-! # Case `a = 1` (`uni_const1`) -/

@[expose] public section

namespace RSN

def const1A : List Int := [1]

theorem const1_ids : idsInRange const1N const1Edges const1Reds const1Blues = true := by decide +kernel
theorem const1_verts : vertsOK const1N const1Verts = true := by decide +kernel
theorem const1_ident : identOK const1Verts const1Edges = true := by decide +kernel
theorem const1_dist : distOK const1Verts const1Edges = true := by decide +kernel
theorem const1_red : redOK const1Verts const1A const1Reds = true := by decide +kernel
theorem const1_blue : blueOK const1Verts const1A const1Blues = true := by decide +kernel

/-- **Case `a = 1`.** For every `k ≥ 8` and every 3-colouring `c` with `[1, 1]` of colour 0 and `2` of colour 1,
there is a weak monochromatic solution in `[1, F k]`. -/
theorem const1_case (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ 1 → c j = 0) (hB : c 2 = 1) : WeakMono k (F k) c := by
  obtain ⟨t, rfl⟩ : ∃ t, k = t + 8 := ⟨k - 8, by omega⟩
  refine uni_case const1N const1Verts const1Edges const1Reds const1Blues const1A const1_ids const1_verts const1_ident
    const1_dist const1_red const1_blue const1_unsat t c ?_ ?_
  · intro j h1 h2
    simp only [const1A, peval] at h2
    exact hR j h1 (by omega)
  · intro j h
    simp only [const1A, peval] at h
    have : j = 2 := by omega
    rw [this]; exact hB

end RSN
