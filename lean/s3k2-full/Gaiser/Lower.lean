module

public import Init

/-!
# A lower bound for the restricted generalized Schur number `S₃(k;2)`

`S_r(k;ℓ)` (C. Gaiser, *Restricted generalized Schur numbers*, arXiv:2608.08789) is the least `n` such
that every `r`-colouring of `[1,n]` has a monochromatic solution of `x₁+⋯+x_k = x_{k+1}` using exactly
`ℓ+1` distinct integers. For `ℓ = 2` such a solution consists of two distinct integers `u ≠ v` on the
left (`i` copies of `u`, `k-i` copies of `v`, `1 ≤ i ≤ k-1`) and `w = i u + (k-i) v` on the right.

Gaiser (Prop. 6.1) shows `S₃(k;2) ≥ k³+3k²+k-1` and asks (Open Question 6.2) whether equality holds for
all large `k`. We give an explicit 3-colouring of `[1, k³+3k²+2k-3]` with no such monochromatic solution,
so `S₃(k;2) ≥ k³+3k²+2k-2 > k³+3k²+k-1` for every `k ≥ 2`: the answer to Open Question 6.2 is *no*.
-/

@[expose] public section

namespace Gaiser

/-- `c` has a monochromatic solution in `[1,N]` of `x₁+⋯+x_k = x_{k+1}` with exactly three distinct
integers: `i` copies of `u`, `k-i` copies of `v` (`u ≠ v`, `1 ≤ i ≤ k-1`), and `w = i u + (k-i) v`. -/
def MonoSol (k N : Nat) (c : Nat → Fin 3) : Prop :=
  ∃ i u v w : Nat, 1 ≤ i ∧ i < k ∧ 1 ≤ u ∧ u ≤ N ∧ 1 ≤ v ∧ v ≤ N ∧ 1 ≤ w ∧ w ≤ N ∧ u ≠ v ∧
    i * u + (k - i) * v = w ∧ c u = c v ∧ c v = c w

/-- The explicit colouring (`0 = R`, `1 = B`, `2 = G`), with `T = k³ + 2k²`:
`R = [1,k] ∪ [k²+k+1, k²+2k-1] ∪ [T+1, T+k-1] ∪ [T+k+k²-1, ∞)`, `B = [k+1, k²+k] ∪ [T+k, T+k+k²-2]`,
`G = [k²+2k, T]`. -/
def col (k n : Nat) : Fin 3 :=
  if n ≤ k then 0
  else if n ≤ k * k + k then 1
  else if n ≤ k * k + 2 * k - 1 then 0
  else if n ≤ k * (k * k) + 2 * (k * k) then 2
  else if n ≤ k * (k * k) + 2 * (k * k) + k - 1 then 0
  else if n ≤ k * (k * k) + 2 * (k * k) + k + k * k - 2 then 1
  else 0

theorem col_R (k n : Nat) (hk : 2 ≤ k) (h : col k n = 0) :
    n ≤ k ∨ (k * k + k + 1 ≤ n ∧ n ≤ k * k + 2 * k - 1) ∨
      (k * (k * k) + 2 * (k * k) + 1 ≤ n ∧ n ≤ k * (k * k) + 2 * (k * k) + k - 1) ∨
      k * (k * k) + 2 * (k * k) + k + k * k - 1 ≤ n := by
  unfold col at h
  split at h; · omega
  split at h; · exact absurd h (by decide)
  split at h; · omega
  split at h; · exact absurd h (by decide)
  split at h; · omega
  split at h; · exact absurd h (by decide)
  omega

theorem col_B (k n : Nat) (h : col k n = 1) :
    (k + 1 ≤ n ∧ n ≤ k * k + k) ∨
      (k * (k * k) + 2 * (k * k) + k ≤ n ∧ n ≤ k * (k * k) + 2 * (k * k) + k + k * k - 2) := by
  unfold col at h
  split at h; · exact absurd h (by decide)
  split at h; · omega
  split at h; · exact absurd h (by decide)
  split at h; · exact absurd h (by decide)
  split at h; · exact absurd h (by decide)
  split at h; · omega
  exact absurd h (by decide)

theorem col_G (k n : Nat) (h : col k n = 2) :
    k * k + 2 * k ≤ n ∧ n ≤ k * (k * k) + 2 * (k * k) := by
  unfold col at h
  split at h; · exact absurd h (by decide)
  split at h; · exact absurd h (by decide)
  split at h; · exact absurd h (by decide)
  split at h; · omega
  split at h; · exact absurd h (by decide)
  split at h; · exact absurd h (by decide)
  exact absurd h (by decide)

/-- `(k-1)·x` is monotone: for `x ≤ y`, `k x + y ≤ k y + x` (when `k ≥ 1`). -/
theorem mono (k x y : Nat) (hk : 1 ≤ k) (h : x ≤ y) : k * x + y ≤ k * y + x := by
  obtain ⟨e, rfl⟩ : ∃ e, y = x + e := ⟨y - x, by omega⟩
  have : e ≤ k * e := Nat.le_mul_of_pos_left e (by omega)
  rw [Nat.mul_add]
  omega

/-- The core inequalities for a solution with `u < v`, `d = v - u`: `w = k u + j d` and `k v = w + i d`
with `i, j ≥ 1`. -/
theorem shape (k i u v w : Nat) (hi : 1 ≤ i) (hik : i < k) (huv : u < v)
    (h : i * u + (k - i) * v = w) :
    ∃ d j, v = u + d ∧ 1 ≤ d ∧ i + j = k ∧ 1 ≤ j ∧ w = k * u + j * d ∧ k * v = w + i * d ∧
      d ≤ j * d ∧ d ≤ i * d ∧ (j = 1 ∨ 2 * d ≤ j * d) := by
  obtain ⟨d, rfl⟩ : ∃ d, v = u + d := ⟨v - u, by omega⟩
  refine ⟨d, k - i, rfl, by omega, by omega, by omega, ?_, ?_, ?_, ?_, ?_⟩
  · rw [← h, Nat.mul_add]
    have : k * u = i * u + (k - i) * u := by
      rw [← Nat.add_mul]; congr 1; omega
    omega
  · rw [← h, Nat.mul_add, Nat.mul_add]
    have hk : k = i + (k - i) := by omega
    have : k * u = i * u + (k - i) * u := by rw [← Nat.add_mul]; congr 1
    have : k * d = i * d + (k - i) * d := by rw [← Nat.add_mul]; congr 1
    omega
  · exact Nat.le_mul_of_pos_left d (by omega)
  · exact Nat.le_mul_of_pos_left d (by omega)
  · by_cases hj : k - i = 1
    · left; exact hj
    · right; exact Nat.mul_le_mul_right d (by omega)

/-- The colouring has no monochromatic solution with `u < v` in `[1, N]`, `N = k³+3k²+2k-3`. -/
theorem no_mono_lt (k : Nat) (hk : 2 ≤ k) (i u v w : Nat) (hi : 1 ≤ i) (hik : i < k) (hu : 1 ≤ u)
    (huv : u < v) (hw : w ≤ k * (k * k) + 3 * (k * k) + 2 * k - 3)
    (h : i * u + (k - i) * v = w) (c1 : col k u = col k v) (c2 : col k v = col k w) : False := by
  obtain ⟨d, j, rfl, hd, hij, hj, hwu, hkv, hjd, hid, hj2⟩ := shape k i u v w hi hik huv h
  -- products needed: k*u and k*v bounded by block ends
  have e1 : k * (k * k + k) = k * (k * k) + k * k := by rw [Nat.mul_add]
  have e2 : k * (k * k + k + 1) = k * (k * k) + k * k + k := by rw [Nat.mul_add, Nat.mul_add, Nat.mul_one]
  have e3 : k * (k * k + 2 * k - 1) + k = k * (k * k) + 2 * (k * k) := by
    have hm : k * k + 2 * k - 1 + 1 = k * k + 2 * k := by omega
    have := congrArg (k * ·) hm
    simp only [Nat.mul_add, Nat.mul_one] at this
    rw [Nat.mul_left_comm k 2 k] at this
    omega
  have e4 : k * (k * k + 2 * k) = k * (k * k) + 2 * (k * k) := by
    rw [Nat.mul_add, Nat.mul_left_comm k 2 k]
  have hk1 : k * 1 = k := Nat.mul_one k
  have hkk : 2 * k ≤ k * k := Nat.mul_le_mul_right k hk
  have hkkk : 2 * (k * k) ≤ k * (k * k) := Nat.mul_le_mul_right (k * k) hk
  have hku1 : k * 1 ≤ k * u := Nat.mul_le_mul_left k hu
  have hku2 : 2 * u ≤ k * u := Nat.mul_le_mul_right u hk
  have m0 := mono k 1 u (by omega) hu
  have hc : col k u = 0 ∨ col k u = 1 ∨ col k u = 2 := by
    rcases col k u with ⟨x, hx⟩
    have : x = 0 ∨ x = 1 ∨ x = 2 := by omega
    rcases this with rfl | rfl | rfl <;> simp
  rcases hc with hc | hc | hc
  · -- colour R
    have rw' := col_R k w hk (by rw [← c2, ← c1, hc])
    have rv := col_R k (u + d) hk (by rw [← c1, hc])
    have ru := col_R k u hk hc
    rcases ru with ru | ru | ru | ru
    · -- u ∈ [1,k]
      have m1 := mono k u k (by omega) ru
      have hkuk : k * u ≤ k * k := Nat.mul_le_mul_left k ru
      rcases rv with rv | rv | rv | rv
      · -- v ∈ [1,k]: w ∈ [k+1, k²-1]
        have hkv : k * (u + d) ≤ k * k := Nat.mul_le_mul_left k rv
        omega
      · -- v ∈ R2: w ∈ G
        have hkv : k * (u + d) ≤ k * (k * k + 2 * k - 1) := Nat.mul_le_mul_left k rv.2
        omega
      · -- v ∈ R3: j = 1 forced, then w ∈ B2
        rcases hj2 with rfl | hj2
        · omega
        · omega
      · omega
    · -- u ∈ R2
      have hku : k * (k * k + k + 1) ≤ k * u := Nat.mul_le_mul_left k ru.1
      have m2 := mono k (k * k + k + 1) u (by omega) ru.1
      rcases rv with rv | rv | rv | rv
      · omega
      · have hkv : k * (u + d) ≤ k * (k * k + 2 * k - 1) := Nat.mul_le_mul_left k rv.2
        omega
      · rcases hj2 with rfl | hj2 <;> omega
      · rcases hj2 with rfl | hj2 <;> omega
    · rcases rv with rv | rv | rv | rv <;> (rcases hj2 with rfl | hj2 <;> omega)
    · omega
  · -- colour B
    have bw := col_B k w (by rw [← c2, ← c1, hc])
    have bv := col_B k (u + d) (by rw [← c1, hc])
    have bu := col_B k u hc
    rcases bu with bu | bu
    · have hku : k * (k + 1) ≤ k * u := Nat.mul_le_mul_left k bu.1
      have ek : k * (k + 1) = k * k + k := by rw [Nat.mul_add, Nat.mul_one]
      have m2 := mono k (k + 1) u (by omega) bu.1
      rcases bv with bv | bv
      · have hkv : k * (u + d) ≤ k * (k * k + k) := Nat.mul_le_mul_left k bv.2
        omega
      · omega
    · omega
  · -- colour G: w ≥ k u + 1 ≥ k (k² + 2k) + 1 > T
    have gw := col_G k w (by rw [← c2, ← c1, hc])
    have gu := col_G k u hc
    have hku : k * (k * k + 2 * k) ≤ k * u := Nat.mul_le_mul_left k gu.1
    omega

/-- **Main theorem.** For every `k ≥ 2` the colouring `col k` of `[1, k³+3k²+2k-3]` has no monochromatic
solution with exactly three distinct integers. Hence `S₃(k;2) ≥ k³+3k²+2k-2`. -/
theorem lower (k : Nat) (hk : 2 ≤ k) :
    ¬ MonoSol k (k * (k * k) + 3 * (k * k) + 2 * k - 3) (col k) := by
  rintro ⟨i, u, v, w, hi, hik, hu, _, hv, _, _, hw, huv, h, c1, c2⟩
  rcases Nat.lt_or_gt_of_ne huv with huv | huv
  · exact no_mono_lt k hk i u v w hi hik hu huv hw h c1 c2
  · -- swap the roles: (k - i) copies of v and i copies of u
    have h' : (k - i) * v + (k - (k - i)) * u = w := by
      have : k - (k - i) = i := by omega
      rw [this, Nat.add_comm]; exact h
    exact no_mono_lt k hk (k - i) v u w (by omega) (by omega) hv huv hw h' c1.symm (c1.trans c2)

/-- The bound exceeds Gaiser's conjectured value `k³+3k²+k-1` by `k-1 ≥ 1`. -/
theorem exceeds (k : Nat) (hk : 2 ≤ k) :
    k * (k * k) + 3 * (k * k) + k - 1 < k * (k * k) + 3 * (k * k) + 2 * k - 2 := by omega

end Gaiser
