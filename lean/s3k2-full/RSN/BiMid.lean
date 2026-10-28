module

public import RSN.BiCase
public import RSN.BimidUnsat

/-! # Case `4 ≤ a ≤ k - 3` (`bi_mid`) -/

@[expose] public section

namespace RSN

def bimidA : List (List Int) := [[4], [1]]   -- a = s + 4

theorem bimid_ids : idsInRange bimidN bimidEdges bimidReds bimidBlues = true := by decide +kernel
theorem bimid_verts : vertsOK2 bimidN bimidVerts = true := by decide +kernel
theorem bimid_ident : identOK2 bimidVerts bimidEdges = true := by decide +kernel
theorem bimid_dist : distOK2 bimidVerts bimidEdges = true := by decide +kernel
theorem bimid_red : redOK2 bimidVerts bimidA bimidReds = true := by decide +kernel
theorem bimid_blue : blueOK2 bimidVerts bimidA bimidBlues = true := by decide +kernel

/-- **Case `4 ≤ a ≤ k - 3`.** Every 3-colouring with `[1, a]` of colour 0 and `a + 1` of colour 1
has a weak monochromatic solution in `[1, F k]`. -/
theorem bimid_case (k a : Nat) (h4 : 4 ≤ a) (hak : a + 3 ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ a → c j = 0) (hB : c (a + 1) = 1) : WeakMono k (F k) c := by
  obtain ⟨s, rfl⟩ : ∃ s, a = s + 4 := ⟨a - 4, by omega⟩
  obtain ⟨t, rfl⟩ : ∃ t, k = s + t + 7 := ⟨k - s - 7, by omega⟩
  refine bi_case bimidN bimidVerts bimidEdges bimidReds bimidBlues bimidA bimid_ids bimid_verts bimid_ident
    bimid_dist bimid_red bimid_blue bimid_unsat s t c ?_ ?_
  · intro j h1 h2
    simp only [bimidA, peval2, peval] at h2
    exact hR j h1 (by omega)
  · intro j h
    simp only [bimidA, peval2, peval] at h
    have : j = s + 4 + 1 := by omega
    rw [this]; exact hB

end RSN
