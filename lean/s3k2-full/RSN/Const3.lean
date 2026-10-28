module

public import RSN.UniCase
public import RSN.Const3Unsat

/-! # Case `a = 3` (`uni_const3`) -/

@[expose] public section

namespace RSN

def const3A : List Int := [3]

theorem const3_ids : idsInRange const3N const3Edges const3Reds const3Blues = true := by decide +kernel
theorem const3_verts : vertsOK const3N const3Verts = true := by decide +kernel
theorem const3_ident : identOK const3Verts const3Edges = true := by decide +kernel
theorem const3_dist : distOK const3Verts const3Edges = true := by decide +kernel
theorem const3_red : redOK const3Verts const3A const3Reds = true := by decide +kernel
theorem const3_blue : blueOK const3Verts const3A const3Blues = true := by decide +kernel

/-- **Case `a = 3`.** For every `k ≥ 8` and every 3-colouring `c` with `[1, 3]` of colour 0 and `4` of colour 1,
there is a weak monochromatic solution in `[1, F k]`. -/
theorem const3_case (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ 3 → c j = 0) (hB : c 4 = 1) : WeakMono k (F k) c := by
  obtain ⟨t, rfl⟩ : ∃ t, k = t + 8 := ⟨k - 8, by omega⟩
  refine uni_case const3N const3Verts const3Edges const3Reds const3Blues const3A const3_ids const3_verts const3_ident
    const3_dist const3_red const3_blue const3_unsat t c ?_ ?_
  · intro j h1 h2
    simp only [const3A, peval] at h2
    exact hR j h1 (by omega)
  · intro j h
    simp only [const3A, peval] at h
    have : j = 4 := by omega
    rw [this]; exact hB

end RSN
