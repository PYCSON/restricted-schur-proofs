module

public import OQ64.Final
public import OQ64.L7
public import OQ64.Q5
public import OQ64.Q6

/-!
# ℓ = 7, and the exact values S₂(5;5) = 101, S₂(6;6) = 166

* `K7` : `S₂(k;7) = F(k,7)` for all `k ≥ 8`, but not for `k = 7`; so the smallest `K` is `8`.
* `S2_5_5`, `S2_6_6` : `S₂(5;5) = 101` and `S₂(6;6) = 166`. Upper bounds come from kernels
  proving `S₂(k;ℓ) ≤ F(k,ℓ) + (ℓ−1)(ℓ−2)/2` for all `k ≥ ℓ` (`q5_upper`, `q6_upper`); lower bounds
  from `propA`.
-/

@[expose] public section

namespace OQ64

/-- `S₂(k;ℓ) = n`. -/
def ValueIs (k l n : Nat) : Prop := ∀ M : Nat, (∀ c : Nat → Bool, ExactSol k l M c) ↔ n ≤ M

theorem valueIs_of (k l n : Nat) (hup : ∀ c, ExactSol k l n c) (c0 : Nat → Bool)
    (hlow : ¬ ExactSol k l (n - 1) c0) (hn : 1 ≤ n) : ValueIs k l n := by
  intro M
  constructor
  · intro h
    apply Classical.byContradiction
    intro hM
    exact hlow (exactSol_mono (h c0) (by omega))
  · intro hM c
    exact exactSol_mono (hup c) hM

theorem S2_7_upper (k : Nat) (hk : 8 ≤ k) (c : Nat → Bool) : ExactSol k 7 (F k 7) c := by
  have h := l7_upper k hk c
  have e : natv l7F k = F k 7 := by
    rw [show l7F = [((35 : Nat) : Int), ((22 : Nat) : Int), 1] from rfl, natv_F]; simp [F]
  rwa [e] at h

theorem K7 : (∀ k, 8 ≤ k → FormulaHolds k 7) ∧ ¬ FormulaHolds 7 7 := by
  refine ⟨fun k hk => ?_, ?_⟩
  · apply formulaHolds_of k 7 (S2_7_upper k hk) _ (F_pos k 7 (by omega))
    apply lower_l k 7 21 15 (by decide) (by omega) (by decide) (by decide)
    simp only [F, Nat.mul_add]; omega
  · exact not_formulaHolds_of 7 7 252 (colA 34 225)
      (propA 7 21 15 28 34 225 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide))
      (by decide)

theorem S2_5_5 : ValueIs 5 5 101 := by
  apply valueIs_of 5 5 101 _ (colA 19 86) ?_ (by decide)
  · intro c
    have h := q5_upper 5 (Nat.le_refl _) c
    have e : natv q5F 5 = 101 := by decide
    rwa [e] at h
  · exact propA 5 10 6 15 19 86 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

theorem S2_6_6 : ValueIs 6 6 166 := by
  apply valueIs_of 6 6 166 _ (colA 26 145) ?_ (by decide)
  · intro c
    have h := q6_upper 6 (Nat.le_refl _) c
    have e : natv q6F 6 = 166 := by decide
    rwa [e] at h
  · exact propA 6 15 10 21 26 145 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

end OQ64
