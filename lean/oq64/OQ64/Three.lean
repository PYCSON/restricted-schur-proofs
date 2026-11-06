module

public import OQ64.Statement
public import OQ64.SumBound
public import OQ64.Lower
public import OQ64.Four

/-!
# Three-block colourings (preprint v1.2, Proposition 19)

* `three_block`: let `2 ≤ ℓ ≤ k`, `j ≥ 0`, `T = ℓ(ℓ+1)/2`, `D = ℓ(ℓ−1)/2`,
  `m = (k − ℓ)(j+1) + ℓ·j + T − 1` and `V = T + (m − j)(ℓ − j) + (k − ℓ)`.
  The colouring `colB j m` (red on `[1, j] ∪ (m, ∞)`, blue on `[j+1, m]`) has no exact
  monochromatic solution in `[1, V − 1]`; hence `S₂(k;ℓ) ≥ V`.
* `three_V_eq`: for `1 ≤ j ≤ ℓ`, with `q = ℓ − j` and `e = k − ℓ`, this `V` is the `V₃` of the
  preprint: `2V = j(j+1) + 2q(m+1) + q(q−1) + 2e`.
* Instances: `S₂(20;19) > F(20,19)` and `S₂(21;20) > F(21,20)` (so Gaiser's formula fails at
  `k = ℓ + 1` for `ℓ = 19, 20`, i.e. `K(19) ≥ 21` and `K(20) ≥ 22`), and `S₂(20;20) ≥ 4770`.
-/

@[expose] public section

namespace OQ64

/-- Red (`true`) on `[1, j]` and on `(m, ∞)`, blue (`false`) on `[j+1, m]`. -/
def colB (j m : Nat) (x : Nat) : Bool := decide (x ≤ j) || decide (m < x)

theorem three_block (k l j m V D T : Nat) (hl : 2 ≤ l) (hk : l ≤ k)
    (hD : 2 * D = l * (l - 1)) (hT : 2 * T = l * (l + 1))
    (hm : m = (k - l) * (j + 1) + l * j + T - 1)
    (hV : V = T + (m - j) * (l - j) + (k - l)) :
    ¬ ExactSol k l (V - 1) (colB j m) := by
  intro h
  obtain ⟨L, vs, w, hLlen, hLsum, hw1, hwN, hL, hnd, hvlen, hvsub, hLsub⟩ := solFacts (by omega) h
  have hDtri : l * (l - 1) / 2 = D := by omega
  have hTD : T = D + l := by
    obtain ⟨x, rfl⟩ : ∃ x, l = x + 1 := ⟨l - 1, by omega⟩
    have e1 : x + 1 - 1 = x := by omega
    rw [e1] at hD
    simp only [Nat.add_mul, Nat.mul_add] at hD hT
    omega
  have hlj : j ≤ l * j := Nat.le_mul_of_pos_left j (by omega)
  have hmj : j ≤ m := by omega
  have hcw : ∀ y ∈ L, colB j m y = colB j m w := fun y hy => (hL y hy).2.2
  cases hcolw : colB j m w
  · -- w blue: w ∈ [j+1, m], and every summand lies in [j+1, m]
    simp only [colB, Bool.or_eq_false_iff, decide_eq_false_iff_not] at hcolw
    have hblue : ∀ y ∈ L, j + 1 ≤ y := by
      intro y hy
      have hc := hcw y hy
      have hwf : colB j m w = false := by
        simp only [colB, Bool.or_eq_false_iff, decide_eq_false_iff_not]; omega
      rw [hwf] at hc
      simp only [colB, Bool.or_eq_false_iff, decide_eq_false_iff_not] at hc
      omega
    have hvb : ∀ v ∈ vs, j + 1 ≤ v := fun v hv => hblue v (hvsub v hv)
    have h2 := sum_ge_of_nodup (j + 1) l vs hnd hvlen hvb
    rw [hDtri] at h2
    have hLb := sum_ge_sub (j + 1) vs L hnd hvsub hblue
    rw [hLlen, hvlen] at hLb
    have e1 : l * (j + 1) = l * j + l := Nat.mul_succ _ _
    omega
  · -- w red: every summand is ≤ j or > m; at most j distinct values are ≤ j
    have hred : ∀ y ∈ L, 1 ≤ y ∧ (y ≤ j ∨ m < y) := by
      intro y hy
      have hc := hcw y hy
      rw [hcolw] at hc
      simp only [colB, Bool.or_eq_true, decide_eq_true_eq] at hc
      exact ⟨(hL y hy).1, hc⟩
    have hvr : ∀ v ∈ vs, 1 ≤ v ∧ (v ≤ j ∨ m < v) := fun v hv => hred v (hvsub v hv)
    -- shifting the large values down by m - j keeps all values distinct and ≥ 1
    have hnd' : (vs.map (shiftDown m (m - j))).Nodup := by
      unfold List.Nodup
      rw [List.pairwise_map]
      refine List.Pairwise.imp_of_mem ?_ hnd
      intro a b ha hb hab
      have h1 := hvr a ha
      have h2 := hvr b hb
      unfold shiftDown
      split <;> split <;> omega
    have hlo : ∀ v ∈ vs.map (shiftDown m (m - j)), 1 ≤ v := by
      intro v hv
      obtain ⟨a, ha, rfl⟩ := List.mem_map.1 hv
      have := hvr a ha
      unfold shiftDown
      split <;> omega
    have hsumφ := sum_ge_of_nodup 1 l (vs.map (shiftDown m (m - j))) hnd'
      (by rw [List.length_map]; exact hvlen) hlo
    rw [hDtri] at hsumφ
    have hsplit := sum_shift m (m - j) vs (fun v hv => by have := hvr v hv; omega)
    have hsmall : (vs.filter (fun v => decide (v ≤ m))).length ≤ j := by
      apply nodup_length_le_of_range 1 j
      · exact List.Pairwise.filter _ hnd
      · intro v hv
        rw [List.mem_filter] at hv
        have := hvr v hv.1
        have hv2 : v ≤ m := by simpa using hv.2
        omega
    have hparts := length_small_big m vs
    have hcnt : l - j ≤ vs.countP (fun v => decide (m < v)) := by omega
    have hmul : (m - j) * (l - j) ≤ (m - j) * vs.countP (fun v => decide (m < v)) :=
      Nat.mul_le_mul_left _ hcnt
    have hLb := sum_ge_sub 1 vs L hnd hvsub (fun y hy => (hred y hy).1)
    rw [hLlen, hvlen] at hLb
    simp only [Nat.mul_one] at hsumφ hLb
    omega

/-- The bound of `three_block` is the preprint's `V₃`:
`2V₃ = j(j+1) + 2q(m+1) + q(q−1) + 2e` with `q = ℓ − j`, `e = k − ℓ`. -/
theorem three_V_eq (j q m e T : Nat) (hjm : j ≤ m)
    (hT : 2 * T = (j + q) * (j + q + 1)) :
    2 * (T + (m - j) * q + e) = j * (j + 1) + 2 * q * (m + 1) + q * (q - 1) + 2 * e := by
  obtain ⟨d, rfl⟩ : ∃ d, m = j + d := ⟨m - j, by omega⟩
  have e1 : j + d - j = d := by omega
  rw [e1]
  cases q with
  | zero =>
    simp only [Nat.add_zero, Nat.mul_zero, Nat.zero_mul, Nat.zero_sub] at hT ⊢
    omega
  | succ q =>
    have e2 : q + 1 - 1 = q := by omega
    rw [e2]
    simp only [Nat.add_mul, Nat.mul_add, Nat.mul_one, Nat.one_mul] at hT ⊢
    have c1 : q * j = j * q := Nat.mul_comm _ _
    have c2 : d * q = q * d := Nat.mul_comm _ _
    have c3 : q * j = j * q := Nat.mul_comm _ _
    have c4 : 2 * q * j = 2 * (j * q) := by rw [Nat.mul_assoc, Nat.mul_comm q j]
    have c5 : 2 * q * d = 2 * (q * d) := Nat.mul_assoc _ _ _
    have c6 : 2 * q * q = 2 * (q * q) := Nat.mul_assoc _ _ _
    have c7 : 2 * q = q + q := by omega
    omega

/-- `S₂(20;19) > F(20,19) = 4163`: the formula fails at `k = ℓ + 1` for `ℓ = 19`. -/
theorem S2_20_19_gt_F : ∃ c : Nat → Bool, ¬ ExactSol 20 19 (F 20 19) c := by
  refine ⟨colB 5 290, fun h => three_block 20 19 5 290 4181 171 190
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ?_⟩
  exact exactSol_mono (by decide) h

/-- `S₂(21;20) > F(21,20) = 4812`. -/
theorem S2_21_20_gt_F : ∃ c : Nat → Bool, ¬ ExactSol 21 20 (F 21 20) c := by
  refine ⟨colB 5 315, fun h => three_block 21 20 5 315 4861 190 210
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ?_⟩
  exact exactSol_mono (by decide) h

/-- Diagonal: a good colouring of `[1, 4769]` for `k = ℓ = 20`, so `S₂(20;20) ≥ 4770`,
which exceeds `(k³+4k²−5k+2)/2 = 4751` at `k = 20`. -/
theorem S2_20_20_ge : ¬ ExactSol 20 20 4769 (colB 4 289) :=
  three_block 20 20 4 289 4770 190 210
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

end OQ64
