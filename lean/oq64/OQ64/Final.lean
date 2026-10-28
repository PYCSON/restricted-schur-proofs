module

public import OQ64.Main
public import OQ64.Lower

/-!
# Gaiser's Open Question 6.4 (exact version) for ℓ = 3, 4, 5, 6

`FormulaHolds k l` : the least `M` such that every 2-colouring of `[1, M]` has an exact monochromatic
solution is `F k l`, i.e. `S₂(k;ℓ) = F(k,ℓ)`.

* `K3` : `S₂(k;3) = F(k,3)` for all `k ≥ 3`;
* `K4` : `S₂(k;4) = F(k,4)` for all `k ≥ 4`;
* `K5` : `S₂(k;5) = F(k,5)` for all `k ≥ 6`, but not for `k = 5`;
* `K6` : `S₂(k;6) = F(k,6)` for all `k ≥ 7`, but not for `k = 6`.

So the smallest `K` of Open Question 6.4 is `3, 4, 6, 7` for `ℓ = 3, 4, 5, 6`.
Lower bounds: `gaiser_lower` (Gaiser's Theorem 1.1, formalised here) and `propA` (for `k = ℓ`).
-/

@[expose] public section

namespace OQ64

theorem exactSol_mono {k l N N' : Nat} {c : Nat → Bool} (h : ExactSol k l N c) (hN : N ≤ N') :
    ExactSol k l N' c := by
  obtain ⟨x, vals, h1, h2, h3, h4, h5, h6, h7⟩ := h
  exact ⟨x, vals, fun i hi => ⟨(h1 i hi).1, Nat.le_trans (h1 i hi).2 hN⟩, h2, h3, h4, h5, h6, h7⟩

def FormulaHolds (k l : Nat) : Prop := ∀ M : Nat, (∀ c : Nat → Bool, ExactSol k l M c) ↔ F k l ≤ M

theorem formulaHolds_of (k l : Nat) (hup : ∀ c, ExactSol k l (F k l) c)
    (hlow : ∃ c, ¬ ExactSol k l (F k l - 1) c) (hF : 1 ≤ F k l) : FormulaHolds k l := by
  intro M
  constructor
  · intro h
    apply Classical.byContradiction
    intro hM
    obtain ⟨c, hc⟩ := hlow
    exact hc (exactSol_mono (h c) (by omega))
  · intro hM c
    exact exactSol_mono (hup c) hM

theorem not_formulaHolds_of (k l n : Nat) (c : Nat → Bool) (hc : ¬ ExactSol k l n c) (hn : F k l ≤ n) :
    ¬ FormulaHolds k l := by
  intro h
  exact hc ((h n).2 hn c)

theorem lower_l (k l D E : Nat) (hl : 2 ≤ l) (hk : l ≤ k) (hD : 2 * D = l * (l - 1))
    (hE : 2 * E = (l - 1) * (l - 2)) (hF : F k l - 1 = (k * (k + D) + D) + k - 2 + E) :
    ∃ c, ¬ ExactSol k l (F k l - 1) c :=
  ⟨rbr (k + D) (k * (k + D) + D), by rw [hF]; exact gaiser_lower k l D E hl hk hD hE⟩

theorem F_pos (k l : Nat) (hk : 1 ≤ k) : 1 ≤ F k l := by
  unfold F
  have : 1 ≤ k * k := Nat.mul_pos hk hk
  omega

theorem K3 (k : Nat) (hk : 3 ≤ k) : FormulaHolds k 3 := by
  apply formulaHolds_of k 3 (S2_3_upper k hk) _ (F_pos k 3 (by omega))
  apply lower_l k 3 3 1 (by decide) hk (by decide) (by decide)
  simp only [F, Nat.mul_add]; omega

theorem K4 (k : Nat) (hk : 4 ≤ k) : FormulaHolds k 4 := by
  apply formulaHolds_of k 4 (S2_4_upper k hk) _ (F_pos k 4 (by omega))
  apply lower_l k 4 6 3 (by decide) hk (by decide) (by decide)
  simp only [F, Nat.mul_add]; omega

theorem K5 : (∀ k, 6 ≤ k → FormulaHolds k 5) ∧ ¬ FormulaHolds 5 5 := by
  refine ⟨fun k hk => ?_, ?_⟩
  · apply formulaHolds_of k 5 (S2_5_upper k hk) _ (F_pos k 5 (by omega))
    apply lower_l k 5 10 6 (by decide) (by omega) (by decide) (by decide)
    simp only [F, Nat.mul_add]; omega
  · exact not_formulaHolds_of 5 5 100 (colA 19 86)
      (propA 5 10 6 15 19 86 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide))
      (by decide)

theorem K6 : (∀ k, 7 ≤ k → FormulaHolds k 6) ∧ ¬ FormulaHolds 6 6 := by
  refine ⟨fun k hk => ?_, ?_⟩
  · apply formulaHolds_of k 6 (S2_6_upper k hk) _ (F_pos k 6 (by omega))
    apply lower_l k 6 15 10 (by decide) (by omega) (by decide) (by decide)
    simp only [F, Nat.mul_add]; omega
  · exact not_formulaHolds_of 6 6 165 (colA 26 145)
      (propA 6 15 10 21 26 145 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide))
      (by decide)

end OQ64
