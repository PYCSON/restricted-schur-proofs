module

public import RSN.UniCase
public import RSN.Top0Unsat

/-! # Case `a = k` (`uni_top0`): pilot of the end-to-end formalisation -/

@[expose] public section

namespace RSN

def top0A : List Int := [8, 1]   -- a = k = t + 8

theorem top0_ids : idsInRange top0N top0Edges top0Reds top0Blues = true := by decide +kernel
theorem top0_verts : vertsOK top0N top0Verts = true := by decide +kernel
theorem top0_ident : identOK top0Verts top0Edges = true := by decide +kernel
theorem top0_dist : distOK top0Verts top0Edges = true := by decide +kernel
theorem top0_red : redOK top0Verts top0A top0Reds = true := by decide +kernel
theorem top0_blue : blueOK top0Verts top0A top0Blues = true := by decide +kernel

/-- **Case `a = k`.** For every `k ≥ 8` and every 3-colouring `c` with `[1, k]` of colour 0 and
`k + 1` of colour 1, there is a weak monochromatic solution in `[1, F k]`. -/
theorem top0_case (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ k → c j = 0) (hB : c (k + 1) = 1) : WeakMono k (F k) c := by
  obtain ⟨t, rfl⟩ : ∃ t, k = t + 8 := ⟨k - 8, by omega⟩
  refine uni_case top0N top0Verts top0Edges top0Reds top0Blues top0A top0_ids top0_verts top0_ident
    top0_dist top0_red top0_blue top0_unsat t c ?_ ?_
  · intro j h1 h2
    simp only [top0A, peval] at h2
    exact hR j h1 (by omega)
  · intro j h
    simp only [top0A, peval] at h
    have : j = t + 8 + 1 := by omega
    rw [this]; exact hB

end RSN
