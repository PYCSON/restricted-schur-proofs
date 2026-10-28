module

public import RSN.Top0
public import RSN.Top1
public import RSN.Top2
public import RSN.Const1
public import RSN.Const2
public import RSN.Const3
public import RSN.BiMid
public import RSN.Small3Unsat
public import RSN.Small4Unsat
public import RSN.Small5Unsat
public import RSN.Small6Unsat
public import RSN.Small7Unsat
public import Gaiser.Lower

/-!
# Main theorem: `S₃(k;2) = k³ + 3k² + 2k − 2` for every `k ≥ 3`

Upper bound: every 3-colouring of `[1, F k]` has a weak monochromatic solution
(`u ≠ v`, `w = (k-1) u + v`), which is a solution of `x₁+⋯+x_k = x_{k+1}` with exactly three
distinct integers (Gaiser's `MonoSol` with `i = k - 1`). Lower bound: `Gaiser.lower`.
-/

@[expose] public section

namespace RSN

/-! ## Colour normalisation -/

def swap01 (p : Fin 3) (x : Fin 3) : Fin 3 := if x = p then 0 else if x = 0 then p else x
def swap12 (x : Fin 3) : Fin 3 := if x = 1 then 2 else if x = 2 then 1 else x
def perm (p q : Fin 3) (x : Fin 3) : Fin 3 :=
  if swap01 p q = 2 then swap12 (swap01 p x) else swap01 p x

theorem perm_inj : ∀ p q x y : Fin 3, perm p q x = perm p q y → x = y := by decide
theorem perm_p : ∀ p q : Fin 3, perm p q p = 0 := by decide
theorem perm_q : ∀ p q : Fin 3, q ≠ p → perm p q q = 1 := by decide

theorem weakMono_of_perm (k N : Nat) (σ : Fin 3 → Fin 3) (hσ : ∀ x y, σ x = σ y → x = y)
    (c : Nat → Fin 3) (h : WeakMono k N (fun n => σ (c n))) : WeakMono k N c := by
  obtain ⟨u, v, hu, hv, huv, hw, h1, h2⟩ := h
  exact ⟨u, v, hu, hv, huv, hw, hσ _ _ h1, hσ _ _ h2⟩

/-- Dispatch on the length `a` of the initial run, after normalisation (`k ≥ 8`). -/
theorem case_split (k a : Nat) (hk : 8 ≤ k) (ha1 : 1 ≤ a) (hak : a ≤ k) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → j ≤ a → c j = 0) (hB : c (a + 1) = 1) : WeakMono k (F k) c := by
  by_cases h1 : a = 1
  · subst h1; exact const1_case k hk c hR hB
  by_cases h2 : a = 2
  · subst h2; exact const2_case k hk c hR hB
  by_cases h3 : a = 3
  · subst h3; exact const3_case k hk c hR hB
  by_cases hm : a + 3 ≤ k
  · exact bimid_case k a (by omega) hm c hR hB
  by_cases t2 : a = k - 2
  · subst t2; exact top2_case k hk c hR hB
  by_cases t1 : a = k - 1
  · subst t1; exact top1_case k hk c hR hB
  have t0 : a = k := by omega
  subst t0
  exact top0_case a hk c hR hB

/-- Induction on the initial run of the colour of `1`. -/
theorem run_induction (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3) :
    ∀ d a : Nat, d = k + 1 - a → 1 ≤ a → a ≤ k + 1 → (∀ j : Nat, 1 ≤ j → j ≤ a → c j = c 1) →
      WeakMono k (F k) c := by
  intro d
  induction d with
  | zero =>
    intro a hd ha1 hak hrun
    -- `[1, k+1]` has one colour: `(1, 2, k+1)` is monochromatic
    have hF : k + 1 ≤ F k := by
      simp only [F]
      have : k ≤ k ^ 3 := by
        have := Nat.pow_le_pow_left (show 1 ≤ k by omega) 3
        have := Nat.le_self_pow (show 3 ≠ 0 by decide) k
        omega
      omega
    refine ⟨1, 2, by omega, by omega, by omega, ?_, ?_, ?_⟩
    · have : (k - 1) * 1 + 2 = k + 1 := by omega
      rw [this]; exact hF
    · rw [hrun 2 (by omega) (by omega)]
    · have : (k - 1) * 1 + 2 = k + 1 := by omega
      rw [this, hrun 2 (by omega) (by omega), hrun (k + 1) (by omega) (by omega)]
  | succ d ih =>
    intro a hd ha1 hak hrun
    by_cases hc : c (a + 1) = c 1
    · apply ih (a + 1) (by omega) (by omega) (by omega)
      intro j hj1 hj2
      by_cases hja : j ≤ a
      · exact hrun j hj1 hja
      · have : j = a + 1 := by omega
        rw [this]; exact hc
    · let σ := perm (c 1) (c (a + 1))
      apply weakMono_of_perm k (F k) σ (perm_inj _ _) c
      apply case_split k a hk ha1 (by omega) (fun n => σ (c n))
      · intro j hj1 hj2
        show perm (c 1) (c (a + 1)) (c j) = 0
        rw [hrun j hj1 hj2]; exact perm_p _ _
      · exact perm_q _ _ hc

theorem weak_upper_large (k : Nat) (hk : 8 ≤ k) (c : Nat → Fin 3) : WeakMono k (F k) c :=
  run_induction k hk c (k + 1 - 1) 1 rfl (by omega) (by omega) (fun j h1 h2 => by
    have : j = 1 := by omega
    rw [this])

theorem weak_upper_small (k : Nat) (h3 : 3 ≤ k) (h7 : k ≤ 7) (c : Nat → Fin 3) : WeakMono k (F k) c := by
  let σ := perm (c 1) (c 1)
  apply weakMono_of_perm k (F k) σ (perm_inj _ _) c
  have h1 : σ (c 1) = 0 := perm_p _ _
  have hk : k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7 := by omega
  rcases hk with rfl | rfl | rfl | rfl | rfl
  · exact small3_case (fun n => σ (c n)) h1
  · exact small4_case (fun n => σ (c n)) h1
  · exact small5_case (fun n => σ (c n)) h1
  · exact small6_case (fun n => σ (c n)) h1
  · exact small7_case (fun n => σ (c n)) h1

theorem weak_upper (k : Nat) (hk : 3 ≤ k) (c : Nat → Fin 3) : WeakMono k (F k) c := by
  by_cases h : 8 ≤ k
  · exact weak_upper_large k h c
  · exact weak_upper_small k hk (by omega) c

/-! ## Back to Gaiser's definition -/

theorem monoSol_of_weak (k N : Nat) (hk : 2 ≤ k) (c : Nat → Fin 3) (h : WeakMono k N c) :
    Gaiser.MonoSol k N c := by
  obtain ⟨u, v, hu, hv, huv, hw, h1, h2⟩ := h
  have hku : u ≤ (k - 1) * u := Nat.le_mul_of_pos_left u (by omega)
  refine ⟨k - 1, u, v, (k - 1) * u + v, by omega, by omega, hu, by omega, hv, by omega, by omega, hw,
    huv, ?_, h1, h2⟩
  have : k - (k - 1) = 1 := by omega
  rw [this, Nat.one_mul]

/-- **Upper bound.** For every `k ≥ 3`, every 3-colouring of `[1, k³+3k²+2k−2]` has a monochromatic
solution of `x₁+⋯+x_k = x_{k+1}` with exactly three distinct integers. -/
theorem upper (k : Nat) (hk : 3 ≤ k) (c : Nat → Fin 3) : Gaiser.MonoSol k (F k) c :=
  monoSol_of_weak k (F k) (by omega) c (weak_upper k hk c)

theorem monoSol_mono (k M M' : Nat) (h : M ≤ M') (c : Nat → Fin 3) (hc : Gaiser.MonoSol k M c) :
    Gaiser.MonoSol k M' c := by
  obtain ⟨i, u, v, w, hi, hik, hu, hu2, hv, hv2, hw, hw2, huv, he, h1, h2⟩ := hc
  exact ⟨i, u, v, w, hi, hik, hu, by omega, hv, by omega, hw, by omega, huv, he, h1, h2⟩

theorem F_sub_one (k : Nat) (hk : 2 ≤ k) : F k - 1 = k * (k * k) + 3 * (k * k) + 2 * k - 3 := by
  have h3 : k ^ 3 = k * (k * k) := by
    rw [show (3 : Nat) = 2 + 1 from rfl, Nat.pow_succ, Nat.pow_two, Nat.mul_comm]
  have h2 : k ^ 2 = k * k := Nat.pow_two k
  simp only [F, h3, h2]
  omega

/-- **Main theorem (Gaiser, Open Question 6.2).** For every `k ≥ 3`, a number `M` has the property
"every 3-colouring of `[1, M]` has a monochromatic solution of `x₁+⋯+x_k = x_{k+1}` with exactly three
distinct integers" if and only if `M ≥ k³ + 3k² + 2k − 2`. That is, `S₃(k;2) = k³ + 3k² + 2k − 2`. -/
theorem S3_two_eq (k : Nat) (hk : 3 ≤ k) (M : Nat) :
    (∀ c : Nat → Fin 3, Gaiser.MonoSol k M c) ↔ k ^ 3 + 3 * k ^ 2 + 2 * k - 2 ≤ M := by
  constructor
  · intro h
    apply Decidable.byContradiction
    intro hlt
    have hM : M ≤ F k - 1 := by simp only [F]; omega
    have := monoSol_mono k M (F k - 1) hM (Gaiser.col k) (h (Gaiser.col k))
    rw [F_sub_one k (by omega)] at this
    exact Gaiser.lower k (by omega) this
  · intro hM c
    exact monoSol_mono k (F k) M (by simp only [F]; omega) c (upper k hk c)

end RSN
