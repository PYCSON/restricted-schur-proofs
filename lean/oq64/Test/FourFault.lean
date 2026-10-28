

import OQ64.Statement
import OQ64.SumBound
import OQ64.Lower

/-!
# Four-block colourings with a short blue block

* `four_block`: let `2 ≤ ℓ ≤ k`, `j ≥ 0`, `T = ℓ(ℓ+1)/2`, `D = ℓ(ℓ−1)/2`,
  `m = (k − ℓ) + (ℓ−1)·j + T − 1` and `V = 2ℓ + D + (m − j − 1)(ℓ − j) + 2(k − ℓ)`.
  The colouring `colA (j+1) m` (red on `{1} ∪ [j+2, m]`, blue elsewhere) has no exact
  monochromatic solution in `[1, V − 1]`; hence `S₂(k;ℓ) ≥ V`.
  For `1 ≤ j ≤ ℓ − 1` this `V` equals `j(j+3)/2 + (ℓ−j)·m + (ℓ−j)(ℓ−j+1)/2 + 2(k−ℓ)`.
* Instances: `S₂(25;24) > F(25,24)`, `S₂(26;25) > F(26,25)` (so Gaiser's formula fails at
  `k = ℓ + 1` for `ℓ = 24, 25`), and `S₂(22;22) ≥ 6242`.
-/



namespace OQ64

/-- Shift values above `m` down by `c`. -/
def shiftDown (m c : Nat) (v : Nat) : Nat := if v ≤ m then v else v - c

theorem sum_shift (m c : Nat) : ∀ (vs : List Nat), (∀ v ∈ vs, v ≤ m ∨ c ≤ v) →
    vs.sum = (vs.map (shiftDown m c)).sum + c * vs.countP (fun v => decide (m < v))
  | [], _ => by simp
  | v :: vs, h => by
    have ih := sum_shift m c vs (fun x hx => h x (List.mem_cons_of_mem _ hx))
    have hv := h v List.mem_cons_self
    rw [List.sum_cons, List.map_cons, List.sum_cons, List.countP_cons]
    by_cases hvm : v ≤ m
    · have h1 : shiftDown m c v = v := by simp [shiftDown, hvm]
      have h2 : decide (m < v) = false := by simp; omega
      rw [h1, h2]
      simp only [Bool.false_eq_true, ite_false, Nat.add_zero]
      omega
    · have h1 : shiftDown m c v = v - c := by simp [shiftDown, hvm]
      have h2 : decide (m < v) = true := by simp; omega
      rw [h1, h2]
      simp only [ite_true, Nat.mul_add, Nat.mul_one]
      omega

theorem length_small_big (m : Nat) : ∀ (vs : List Nat),
    vs.length = (vs.filter (fun v => decide (v ≤ m))).length + vs.countP (fun v => decide (m < v))
  | [] => by simp
  | v :: vs => by
    have ih := length_small_big m vs
    rw [List.filter_cons, List.countP_cons, List.length_cons]
    by_cases hvm : v ≤ m
    · have h1 : decide (v ≤ m) = true := by simp; omega
      have h2 : decide (m < v) = false := by simp; omega
      rw [h1, h2]
      simp only [ite_true, Bool.false_eq_true, ite_false, List.length_cons, Nat.add_zero]
      omega
    · have h1 : decide (v ≤ m) = false := by simp; omega
      have h2 : decide (m < v) = true := by simp; omega
      rw [h1, h2]
      simp only [Bool.false_eq_true, ite_false, ite_true]
      omega

theorem exactSol_mono {k l N N' : Nat} {c : Nat → Bool} (hN : N ≤ N') (h : ExactSol k l N c) :
    ExactSol k l N' c := by
  obtain ⟨x, vals, hr, hsum, hnd, hlen, hin, hatt, hcol⟩ := h
  exact ⟨x, vals, fun i hi => ⟨(hr i hi).1, Nat.le_trans (hr i hi).2 hN⟩, hsum, hnd, hlen, hin,
    hatt, hcol⟩

theorem four_block (k l j m V D E T : Nat) (hl : 2 ≤ l) (hk : l ≤ k)
    (hD : 2 * D = l * (l - 1)) (hE : 2 * E = (l - 1) * (l - 2)) (hT : 2 * T = l * (l + 1))
    (hm : m = (k - l) + (l - 1) * j + T - 1)
    (hV : V = 2 * l + D + (m - (j + 1)) * (l - j) + 2 * (k - l) + 1) :
    ¬ ExactSol k l (V - 1) (colA (j + 1) m) := by
  intro h
  obtain ⟨L, vs, w, hLlen, hLsum, hw1, hwN, hL, hnd, hvlen, hvsub, hLsub⟩ := solFacts (by omega) h
  have hDtri : l * (l - 1) / 2 = D := by omega
  have hEtri : (l - 1) * (l - 1 - 1) / 2 = E := by
    have : l - 1 - 1 = l - 2 := by omega
    rw [this]; omega
  have key : T = E + 2 * l - 1 ∧ D = E + (l - 1) := by
    obtain ⟨x, rfl⟩ : ∃ x, l = x + 2 := ⟨l - 2, by omega⟩
    have e1 : x + 2 - 1 = x + 1 := by omega
    have e2 : x + 2 - 2 = x := by omega
    rw [e1] at hD; rw [e1, e2] at hE
    simp only [Nat.add_mul, Nat.mul_add] at hD hE hT
    omega
  obtain ⟨hTE, hDE⟩ := key
  have hlj : j ≤ (l - 1) * j := Nat.le_mul_of_pos_left j (by omega)
  have hmj : j + 2 ≤ m := by omega
  have hcw : ∀ y ∈ L, colA (j + 1) m y = colA (j + 1) m w := fun y hy => (hL y hy).2.2
  have hw2 : 2 ≤ w := by
    obtain ⟨y, hy⟩ : ∃ y, y ∈ L := by
      cases L with
      | nil => simp at hLlen; omega
      | cons y _ => exact ⟨y, List.mem_cons_self⟩
    have := hL y hy; omega
  cases hcolw : colA (j + 1) m w
  · -- w blue: every summand lies in [2, j+1] ∪ (m, ∞)
    have hblue : ∀ y ∈ L, 2 ≤ y ∧ (y ≤ j + 1 ∨ m < y) := by
      intro y hy
      have hc := hcw y hy; rw [hcolw] at hc
      have := (hL y hy).1
      simp only [colA, Bool.or_eq_false_iff, decide_eq_false_iff_not, Bool.and_eq_false_iff] at hc
      omega
    have hvb : ∀ v ∈ vs, 2 ≤ v ∧ (v ≤ j + 1 ∨ m < v) := fun v hv => hblue v (hvsub v hv)
    -- shifting the large values down by m-(j+1) keeps them distinct and ≥ j+2
    have hnd' : (vs.map (shiftDown m (m - (j + 1)))).Nodup := by
      unfold List.Nodup
      rw [List.pairwise_map]
      refine List.Pairwise.imp_of_mem ?_ hnd
      intro a b ha hb hab
      have h1 := hvb a ha
      have h2 := hvb b hb
      unfold shiftDown
      split <;> split <;> omega
    have hlo : ∀ v ∈ vs.map (shiftDown m (m - (j + 1))), 2 ≤ v := by
      intro v hv
      obtain ⟨a, ha, rfl⟩ := List.mem_map.1 hv
      have := hvb a ha
      unfold shiftDown
      split <;> omega
    have hsumφ := sum_ge_of_nodup 2 l (vs.map (shiftDown m (m - (j + 1)))) hnd'
      (by rw [List.length_map]; exact hvlen) hlo
    rw [hDtri] at hsumφ
    have hsplit := sum_shift m (m - (j + 1)) vs (fun v hv => by have := hvb v hv; omega)
    -- at most j distinct values lie in [2, j+1], so at least l - j values exceed m
    have hsmall : (vs.filter (fun v => decide (v ≤ m))).length ≤ j := by
      apply nodup_length_le_of_range 2 j
      · exact List.Pairwise.filter _ hnd
      · intro v hv
        rw [List.mem_filter] at hv
        have := hvb v hv.1
        have hv2 : v ≤ m := by simpa using hv.2
        omega
    have hparts := length_small_big m vs
    have hcnt : l - j ≤ vs.countP (fun v => decide (m < v)) := by omega
    have hmul : (m - (j + 1)) * (l - j) ≤ (m - (j + 1)) * vs.countP (fun v => decide (m < v)) :=
      Nat.mul_le_mul_left _ hcnt
    have hLb := sum_ge_sub 2 vs L hnd hvsub (fun y hy => (hblue y hy).1)
    rw [hLlen, hvlen] at hLb
    omega
  · -- w red: w ∈ [j+2, m]; every summand is 1 or in [j+2, m]
    simp only [colA, Bool.or_eq_true, decide_eq_true_eq, Bool.and_eq_true] at hcolw
    have hwm : w ≤ m := by omega
    have hred : ∀ y ∈ L, y = 1 ∨ (j + 2 ≤ y ∧ y ≤ m) := by
      intro y hy
      have hc := hcw y hy
      simp only [colA] at hc
      have : (decide (w = 1) || (decide (j + 1 + 1 ≤ w) && decide (w ≤ m))) = true := by
        simp only [Bool.or_eq_true, decide_eq_true_eq, Bool.and_eq_true]; omega
      rw [this] at hc
      simp only [Bool.or_eq_true, decide_eq_true_eq, Bool.and_eq_true] at hc
      omega
    have hvr : ∀ v ∈ vs, v = 1 ∨ j + 2 ≤ v := by
      intro v hv; have := hred v (hvsub v hv); omega
    have hLb := sum_ge_sub 1 vs L hnd hvsub (fun y hy => (hL y hy).1)
    rw [hLlen, hvlen] at hLb
    have e1 : (l - 1) * (j + 2) = (l - 1) * j + (l - 1) * 2 := Nat.mul_add _ _ _
    by_cases h1 : (1 : Nat) ∈ vs
    · have hs := sum_erase_add h1
      have h2 := sum_ge_of_nodup (j + 2) (l - 1) (vs.erase 1) (hnd.erase 1)
        (by rw [List.length_erase_of_mem h1]; omega)
        (fun v hv => by
          have hv' := (List.Nodup.mem_erase_iff hnd).1 hv
          have := hvr v hv'.2; omega)
      rw [hEtri] at h2
      omega
    · have h2 := sum_ge_of_nodup (j + 2) l vs hnd hvlen
        (fun v hv => by
          have := hvr v hv
          have : v ≠ 1 := fun e => h1 (e ▸ hv)
          omega)
      rw [hDtri] at h2
      have e2 : l * (j + 2) = (l - 1) * (j + 2) + (j + 2) := by
        have : l = (l - 1) + 1 := by omega
        conv => lhs; rw [this]
        rw [Nat.succ_mul]
      omega

/-- `S₂(25;24) > F(25,24) = 8078`: the formula fails at `k = ℓ + 1` for `ℓ = 24`. -/
theorem S2_25_24_gt_F : ∃ c : Nat → Bool, ¬ ExactSol 25 24 (F 25 24) c := by
  refine ⟨colA (5 + 1) 415, fun h => four_block 25 24 5 415 8097 276 253 300
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ?_⟩
  exact exactSol_mono (by decide) h

/-- `S₂(26;25) > F(26,25) = 9077`. -/
theorem S2_26_25_gt_F : ∃ c : Nat → Bool, ¬ ExactSol 26 25 (F 26 25) c := by
  refine ⟨colA (5 + 1) 445, fun h => four_block 26 25 5 445 9132 300 276 325
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ?_⟩
  exact exactSol_mono (by decide) h

/-- Diagonal: a good colouring of `[1, 6241]` for `k = ℓ = 22`, so `S₂(22;22) ≥ 6242`,
which exceeds `(k³+4k²−5k+2)/2 = 6238` at `k = 22`. -/
theorem S2_22_22_ge : ¬ ExactSol 22 22 6241 (colA (5 + 1) 357) :=
  four_block 22 22 5 357 6242 231 210 253
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)

end OQ64
