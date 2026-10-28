module

public import OQ64.Statement
public import OQ64.SumBound

/-!
# Lower bounds (colourings without exact monochromatic solutions)

* `solFacts`: unpacks an `ExactSol` into the list `L` of the `k` summands, their sum `w`, and a
  duplicate-free list `vs` of length `ℓ` with the same elements as `L`.
* `gaiser_lower`: Gaiser's three-block colouring `R[1,s−1] B[s,t−1] R[t,F−1]`
  (`s = k + D`, `t = k·s + D`, `D = ℓ(ℓ−1)/2`) has no exact monochromatic solution in `[1, F−1]`,
  for all `2 ≤ ℓ ≤ k` (Gaiser, arXiv:2608.08789, Theorem 1.1, lower bound).
* `propA`: for `k = ℓ ≥ 5` the four-block colouring `R{1} B[2,a] R[a+1,b] B[b+1,n]` has no exact
  monochromatic solution in `[1, n]`, where `a = (ℓ²+3ℓ−2)/2`, `b = (ℓ−1)a + D`, `n = b + ℓ(ℓ+1)/2 − 1`.
  Hence `S₂(ℓ;ℓ) > n ≥ F(ℓ,ℓ)` for `ℓ ≥ 5`.
-/

@[expose] public section

namespace OQ64

theorem solFacts {k l N : Nat} {c : Nat → Bool} (hk : 2 ≤ k) (h : ExactSol k l N c) :
    ∃ (L vs : List Nat) (w : Nat), L.length = k ∧ L.sum = w ∧ 1 ≤ w ∧ w ≤ N ∧
      (∀ y ∈ L, 1 ≤ y ∧ y < w ∧ c y = c w) ∧
      vs.Nodup ∧ vs.length = l ∧ (∀ v ∈ vs, v ∈ L) ∧ (∀ y ∈ L, y ∈ vs) := by
  obtain ⟨x, vals, hr, hsum, hnd, hlen, hin, hatt, hcol⟩ := h
  let L := (List.range k).map x
  have hLlen : L.length = k := by simp [L]
  have hmemL : ∀ y, y ∈ L ↔ ∃ i, i < k ∧ x i = y := by
    intro y; simp [L, List.mem_map, List.mem_range]
  have hL1 : ∀ y ∈ L, 1 ≤ y := by
    intro y hy; obtain ⟨i, hi, rfl⟩ := (hmemL y).1 hy; exact (hr i (by omega)).1
  have hlt : ∀ y ∈ L, y < x k := by
    intro y hy
    have hs := sum_erase_add hy
    have h1 := len_mul_le_sum 1 (L.erase y) (fun z hz => hL1 z (List.mem_of_mem_erase hz))
    rw [List.length_erase_of_mem hy, hLlen] at h1
    have : L.sum = x k := hsum
    omega
  have hwv : x k ∈ vals := hin k (Nat.le_refl _)
  refine ⟨L, vals.erase (x k), x k, hLlen, hsum, (hr k (Nat.le_refl _)).1, (hr k (Nat.le_refl _)).2, ?_, hnd.erase _, ?_, ?_, ?_⟩
  · intro y hy
    refine ⟨hL1 y hy, hlt y hy, ?_⟩
    obtain ⟨i, hi, rfl⟩ := (hmemL y).1 hy
    exact hcol i (by omega)
  · rw [List.length_erase_of_mem hwv]; omega
  · intro v hv
    have hv' := (List.Nodup.mem_erase_iff hnd).1 hv
    obtain ⟨i, hi, hxi⟩ := hatt v hv'.2
    have hik : i ≠ k := by intro e; subst e; exact hv'.1 hxi.symm
    exact (hmemL v).2 ⟨i, by omega, hxi⟩
  · intro y hy
    obtain ⟨i, hi, rfl⟩ := (hmemL y).1 hy
    have hne : x i ≠ x k := by have := hlt (x i) hy; omega
    exact (List.Nodup.mem_erase_iff hnd).2 ⟨hne, hin i (by omega)⟩

/-- Gaiser's colouring: red on `[1, s)`, blue on `[s, t)`, red from `t` on. -/
def rbr (s t : Nat) (x : Nat) : Bool := decide (x < s) || decide (t ≤ x)

theorem gaiser_lower (k l D E : Nat) (hl : 2 ≤ l) (hk : l ≤ k)
    (hD : 2 * D = l * (l - 1)) (hE : 2 * E = (l - 1) * (l - 2)) :
    ¬ ExactSol k l ((k * (k + D) + D) + k - 2 + E) (rbr (k + D) (k * (k + D) + D)) := by
  intro h
  obtain ⟨L, vs, w, hLlen, hLsum, hw1, hwN, hL, hnd, hvlen, hvsub, hLsub⟩ := solFacts (by omega) h
  have hDtri : l * (l - 1) / 2 = D := by omega
  have hEtri : (l - 1) * (l - 1 - 1) / 2 = E := by
    have : l - 1 - 1 = l - 2 := by omega
    rw [this]; omega
  -- generic lower bound: all summands ≥ m
  have lowb : ∀ m, (∀ y ∈ L, m ≤ y) → k * m + D ≤ w := by
    intro m hm
    have h1 := sum_ge_sub m vs L hnd hvsub hm
    have h2 := sum_ge_of_nodup m l vs hnd hvlen (fun v hv => hm v (hvsub v hv))
    rw [hDtri] at h2
    rw [hLlen, hvlen] at h1
    have e : k * m = l * m + (k - l) * m := by rw [← Nat.add_mul]; congr 1; omega
    omega
  -- generic upper bound: all summands ≤ M
  have upb : ∀ M, (∀ y ∈ L, y ≤ M) → w + D ≤ k * M := by
    intro M hM
    have h1 := sum_le_sub M vs L hnd hvsub hM
    have h2 := sum_le_of_nodup M l vs hnd hvlen (fun v hv => hM v (hvsub v hv))
    rw [hDtri] at h2
    rw [hLlen, hvlen] at h1
    have e : k * M = l * M + (k - l) * M := by rw [← Nat.add_mul]; congr 1; omega
    omega
  have hcw : ∀ y ∈ L, rbr (k + D) (k * (k + D) + D) y = rbr (k + D) (k * (k + D) + D) w := fun y hy => (hL y hy).2.2
  by_cases hws : w < k + D
  · -- w red, summands red and < w < s: sum ≥ k + D
    have := lowb 1 (fun y hy => (hL y hy).1)
    omega
  · by_cases hwt : w < k * (k + D) + D
    · -- w blue: summands blue, in [s, t)
      have hwb : rbr (k + D) (k * (k + D) + D) w = false := by simp [rbr]; omega
      have hs : ∀ y ∈ L, k + D ≤ y := by
        intro y hy
        have := hcw y hy; rw [hwb] at this
        simp [rbr] at this; omega
      have := lowb (k + D) hs
      omega
    · -- w red with w ≥ t
      have hwr : rbr (k + D) (k * (k + D) + D) w = true := by simp [rbr]; omega
      by_cases hbig : ∃ y ∈ L, k * (k + D) + D ≤ y
      · obtain ⟨y, hy, hyt⟩ := hbig
        -- split off y; the other ℓ−1 distinct values are ≥ 1
        have hyv := hLsub y hy
        have hs := sum_erase_add hy
        have hsub2 : ∀ v ∈ vs.erase y, v ∈ L.erase y := by
          intro v hv
          have hv' := (List.Nodup.mem_erase_iff hnd).1 hv
          exact mem_erase_of_ne_mem (hvsub v hv'.2) hv'.1
        have h1 := sum_ge_sub 1 (vs.erase y) (L.erase y) (hnd.erase y) hsub2
          (fun z hz => (hL z (List.mem_of_mem_erase hz)).1)
        have h2 := sum_ge_of_nodup 1 (l - 1) (vs.erase y) (hnd.erase y)
          (by rw [List.length_erase_of_mem hyv]; omega)
          (fun v hv => (hL v (hvsub v (List.mem_of_mem_erase hv))).1)
        rw [hEtri] at h2
        rw [List.length_erase_of_mem hy, List.length_erase_of_mem hyv, hLlen, hvlen] at h1
        omega
      · -- all summands red and < t, hence < s
        have hsm : ∀ y ∈ L, y ≤ k + D - 1 := by
          intro y hy
          have hc := hcw y hy; rw [hwr] at hc
          have : ¬ (k * (k + D) + D ≤ y) := fun hh => hbig ⟨y, hy, hh⟩
          simp [rbr] at hc; omega
        have := upb (k + D - 1) hsm
        have e : k * (k + D - 1) + k = k * (k + D) := by
          rw [← Nat.mul_succ]; congr 1; omega
        omega

/-- The colouring of Proposition A: red on `{1} ∪ [a+1, b]`, blue elsewhere. -/
def colA (a b : Nat) (x : Nat) : Bool := decide (x = 1) || (decide (a + 1 ≤ x) && decide (x ≤ b))

theorem propA (l D E T a b : Nat) (hl : 5 ≤ l)
    (hD : 2 * D = l * (l - 1)) (hE : 2 * E = (l - 1) * (l - 2)) (hT : 2 * T = l * (l + 1))
    (ha : 2 * (a + 1) = l * (l + 3)) (hb : b = (l - 1) * a + D) :
    ¬ ExactSol l l (b + T - 1) (colA a b) := by
  intro h
  obtain ⟨L, vs, w, hLlen, hLsum, hw1, hwN, hL, hnd, hvlen, hvsub, hLsub⟩ := solFacts (by omega) h
  have hDtri : l * (l - 1) / 2 = D := by omega
  have hEtri : (l - 1) * (l - 1 - 1) / 2 = E := by
    have : l - 1 - 1 = l - 2 := by omega
    rw [this]; omega
  -- arithmetic facts (via l = x + 5)
  have key : D = E + (l - 1) ∧ T = E + 2 * l - 1 ∧ a + 1 = D + 2 * l ∧ a ≤ 2 * D := by
    obtain ⟨x, rfl⟩ : ∃ x, l = x + 5 := ⟨l - 5, by omega⟩
    have e1 : x + 5 - 1 = x + 4 := by omega
    have e2 : x + 5 - 2 = x + 3 := by omega
    rw [e1] at hD; rw [e1, e2] at hE
    simp only [Nat.add_mul, Nat.mul_add] at hD hE hT ha
    omega
  obtain ⟨hDE, hTE, ha1, haD⟩ := key
  have e_la : l * a = (l - 1) * a + a := by
    have h := Nat.succ_mul (l - 1) a
    have : (l - 1).succ = l := by omega
    rw [this] at h; exact h
  have e_la1 : (l - 1) * (a + 1) = (l - 1) * a + (l - 1) := Nat.mul_succ _ _
  have e_l1 : l * (a + 1) = l * a + l := Nat.mul_succ _ _
  -- the sum bounds
  have lowb : ∀ m, (∀ y ∈ L, m ≤ y) → l * m + D ≤ w := by
    intro m hm
    have h1 := sum_ge_sub m vs L hnd hvsub hm
    have h2 := sum_ge_of_nodup m l vs hnd hvlen (fun v hv => hm v (hvsub v hv))
    rw [hDtri] at h2
    rw [hLlen, hvlen, Nat.sub_self, Nat.zero_mul] at h1
    omega
  have upb : ∀ M, (∀ y ∈ L, y ≤ M) → w + D ≤ l * M := by
    intro M hM
    have h1 := sum_le_sub M vs L hnd hvsub hM
    have h2 := sum_le_of_nodup M l vs hnd hvlen (fun v hv => hM v (hvsub v hv))
    rw [hDtri] at h2
    rw [hLlen, hvlen, Nat.sub_self, Nat.zero_mul] at h1
    omega
  -- splitting off one summand y: the rest has l-1 distinct values ≥ m
  have splitb : ∀ y ∈ L, ∀ m, (∀ z ∈ L, z ≠ y → m ≤ z) → y + (l - 1) * m + E ≤ w := by
    intro y hy m hm
    have hyv := hLsub y hy
    have hs := sum_erase_add hy
    have hsub2 : ∀ v ∈ vs.erase y, v ∈ L.erase y := by
      intro v hv
      have hv' := (List.Nodup.mem_erase_iff hnd).1 hv
      exact mem_erase_of_ne_mem (hvsub v hv'.2) hv'.1
    have hm' : ∀ z ∈ L.erase y, m ≤ z := by
      intro z hz
      have hz' : z ∈ L := List.mem_of_mem_erase hz
      by_cases hzy : z = y
      · -- z = y would mean y occurs twice; but vs has the same elements as L and L has length l = |vs|
        subst hzy
        exfalso
        -- L has a repeated element y, so vs (duplicate-free, ⊆ L, length l = |L|) cannot cover L
        have hsub3 : ∀ v ∈ vs, v ∈ L.erase z := by
          intro v hv
          by_cases hvz : v = z
          · subst hvz; exact hz
          · exact mem_erase_of_ne_mem (hvsub v hv) hvz
        have := nodup_length_le_sub vs (L.erase z) hnd hsub3
        rw [List.length_erase_of_mem hy, hLlen, hvlen] at this
        omega
      · exact hm z hz' hzy
    have h1 := sum_ge_sub m (vs.erase y) (L.erase y) (hnd.erase y) hsub2 hm'
    have h2 := sum_ge_of_nodup m (l - 1) (vs.erase y) (hnd.erase y)
      (by rw [List.length_erase_of_mem hyv]; omega)
      (fun v hv => hm' v (hsub2 v hv))
    rw [hEtri] at h2
    rw [List.length_erase_of_mem hy, List.length_erase_of_mem hyv, hLlen, hvlen, Nat.sub_self, Nat.zero_mul] at h1
    omega
  have hcw : ∀ y ∈ L, colA a b y = colA a b w := fun y hy => (hL y hy).2.2
  have hw2 : 2 ≤ w := by
    obtain ⟨y, hy⟩ : ∃ y, y ∈ L := by
      cases L with
      | nil => simp at hLlen; omega
      | cons y _ => exact ⟨y, List.mem_cons_self⟩
    have := hL y hy; omega
  cases hcolw : colA a b w
  · -- w blue: w ∈ [2, a] ∪ [b+1, n]
    have hblue : ∀ y ∈ L, y ≠ 1 ∧ (y ≤ a ∨ b < y) := by
      intro y hy
      have hc := hcw y hy; rw [hcolw] at hc
      simp only [colA, Bool.or_eq_false_iff, decide_eq_false_iff_not, Bool.and_eq_false_iff] at hc
      omega
    by_cases hbig : ∃ y ∈ L, b < y
    · obtain ⟨y, hy, hyb⟩ := hbig
      have := splitb y hy 2 (fun z hz _ => by have := hblue z hz; have := (hL z hz).1; omega)
      omega
    · have hsm : ∀ y ∈ L, y ≤ a := by
        intro y hy
        have := hblue y hy
        have : ¬ b < y := fun hh => hbig ⟨y, hy, hh⟩
        omega
      have h2 : ∀ y ∈ L, 2 ≤ y := by
        intro y hy; have := hblue y hy; have := (hL y hy).1; omega
      have hlo := lowb 2 h2
      have hup := upb a hsm
      simp only [colA, Bool.or_eq_false_iff, decide_eq_false_iff_not, Bool.and_eq_false_iff] at hcolw
      omega
  · -- w red: w = 1 (impossible) or w ∈ [a+1, b]
    simp only [colA, Bool.or_eq_true, decide_eq_true_eq, Bool.and_eq_true] at hcolw
    have hwab : a + 1 ≤ w ∧ w ≤ b := by omega
    have hred : ∀ y ∈ L, y = 1 ∨ (a + 1 ≤ y ∧ y ≤ b) := by
      intro y hy
      have hc := hcw y hy
      simp only [colA] at hc
      have : (decide (w = 1) || (decide (a + 1 ≤ w) && decide (w ≤ b))) = true := by
        simp only [Bool.or_eq_true, decide_eq_true_eq, Bool.and_eq_true]; omega
      rw [this] at hc
      simp only [Bool.or_eq_true, decide_eq_true_eq, Bool.and_eq_true] at hc
      exact hc
    by_cases h1 : (1 : Nat) ∈ L
    · have := splitb 1 h1 (a + 1) (fun z hz hz1 => by have := hred z hz; omega)
      have e : (l - 1) * (a + 1) = (l - 1) * a + (l - 1) := by rw [Nat.mul_add, Nat.mul_one]
      omega
    · have hge : ∀ y ∈ L, a + 1 ≤ y := by
        intro y hy
        have := hred y hy
        have : y ≠ 1 := fun e => h1 (e ▸ hy)
        omega
      have := lowb (a + 1) hge
      have e : l * (a + 1) = l * a + l := by rw [Nat.mul_add, Nat.mul_one]
      have e2 : l * a = (l - 1) * a + a := by
        have : l = (l - 1) + 1 := by omega
        conv => lhs; rw [this]
        rw [Nat.succ_mul]
      omega

end OQ64
