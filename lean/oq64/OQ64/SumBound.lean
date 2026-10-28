module

public import Init

/-!
# Sums of lists with many distinct values

* `nodup_length_le_of_range`: a duplicate-free list of naturals inside `[m, m + B)` has length `≤ B`.
* `sum_ge_of_nodup` / `sum_le_of_nodup`: a duplicate-free list of `n` naturals that are all `≥ m`
  (resp. `≤ M`) has sum `≥ n·m + n(n−1)/2` (resp. `≤ n·M − n(n−1)/2`).
* `sum_ge_sub` / `sum_le_sub`: if a duplicate-free `vs` is contained in `L`, then
  `L.sum ≥ vs.sum + (|L| − |vs|)·m` when all entries of `L` are `≥ m`, and `L.sum ≤ vs.sum + (|L| − |vs|)·M`
  when all are `≤ M`.
-/

@[expose] public section

namespace OQ64

theorem sum_erase_add : ∀ {L : List Nat} {v : Nat}, v ∈ L → (L.erase v).sum + v = L.sum
  | [], _, h => by simp at h
  | y :: L, v, h => by
    by_cases hv : y = v
    · subst hv; simp [List.erase_cons_head]; omega
    · rw [List.erase_cons_tail (by simpa using hv), List.sum_cons, List.sum_cons]
      have h' : v ∈ L := by
        rcases List.mem_cons.1 h with h | h
        · exact absurd h.symm hv
        · exact h
      have := sum_erase_add h'
      omega

theorem mem_erase_of_ne_mem {L : List Nat} {a b : Nat} (hb : b ∈ L) (hne : b ≠ a) : b ∈ L.erase a :=
  (List.mem_erase_of_ne hne).2 hb

theorem tri_succ (n : Nat) : (n + 1) * (n + 1 - 1) / 2 = n * (n - 1) / 2 + n := by
  have h : (n + 1) * (n + 1 - 1) = n * (n - 1) + 2 * n := by
    cases n with
    | zero => rfl
    | succ m =>
      simp only [Nat.add_sub_cancel, Nat.add_mul, Nat.mul_add, Nat.mul_one, Nat.one_mul]
      omega
  rw [h, Nat.add_mul_div_left _ _ (by decide)]

theorem len_mul_le_sum (m : Nat) : ∀ (L : List Nat), (∀ y ∈ L, m ≤ y) → L.length * m ≤ L.sum
  | [], _ => by simp
  | y :: L, h => by
    rw [List.length_cons, Nat.succ_mul, List.sum_cons]
    have := len_mul_le_sum m L (fun z hz => h z (List.mem_cons_of_mem _ hz))
    have := h y List.mem_cons_self
    omega

theorem sum_le_len_mul (M : Nat) : ∀ (L : List Nat), (∀ y ∈ L, y ≤ M) → L.sum ≤ L.length * M
  | [], _ => by simp
  | y :: L, h => by
    rw [List.length_cons, Nat.succ_mul, List.sum_cons]
    have := sum_le_len_mul M L (fun z hz => h z (List.mem_cons_of_mem _ hz))
    have := h y List.mem_cons_self
    omega

theorem nodup_length_le_of_range (m : Nat) :
    ∀ (B : Nat) (vs : List Nat), vs.Nodup → (∀ v ∈ vs, m ≤ v ∧ v < m + B) → vs.length ≤ B
  | 0, vs, _, h => by
    cases vs with
    | nil => simp
    | cons v _ => have := h v List.mem_cons_self; omega
  | B + 1, vs, hnd, h => by
    by_cases hB : (m + B) ∈ vs
    · have h1 := List.length_erase_of_mem hB
      have h2 : ∀ v ∈ vs.erase (m + B), m ≤ v ∧ v < m + B := by
        intro v hv
        have hvs := List.mem_of_mem_erase hv
        have hne : v ≠ m + B := by
          intro e; subst e
          exact (List.Nodup.not_mem_erase hnd) hv
        have := h v hvs; omega
      have := nodup_length_le_of_range m B _ (hnd.erase _) h2
      omega
    · have h2 : ∀ v ∈ vs, m ≤ v ∧ v < m + B := by
        intro v hv
        have := h v hv
        have : v ≠ m + B := fun e => hB (e ▸ hv)
        omega
      have := nodup_length_le_of_range m B vs hnd h2
      omega

theorem sum_ge_of_nodup (m : Nat) :
    ∀ (n : Nat) (vs : List Nat), vs.Nodup → vs.length = n → (∀ v ∈ vs, m ≤ v) → n * m + n * (n - 1) / 2 ≤ vs.sum
  | 0, _, _, _, _ => by simp
  | n + 1, vs, hnd, hlen, hm => by
    -- some element is ≥ m + n
    have hbig : ∃ v ∈ vs, m + n ≤ v := by
      apply Classical.byContradiction
      intro hno
      have h2 : ∀ v ∈ vs, m ≤ v ∧ v < m + n := by
        intro v hv
        refine ⟨hm v hv, ?_⟩
        apply Classical.byContradiction
        intro hlt
        exact hno ⟨v, hv, by omega⟩
      have := nodup_length_le_of_range m n vs hnd h2
      omega
    obtain ⟨v, hv, hvn⟩ := hbig
    have hlen' : (vs.erase v).length = n := by rw [List.length_erase_of_mem hv]; omega
    have ih := sum_ge_of_nodup m n (vs.erase v) (hnd.erase v) hlen'
      (fun x hx => hm x (List.mem_of_mem_erase hx))
    have hs := sum_erase_add hv
    have e1 : (n + 1) * m = n * m + m := by rw [Nat.succ_mul]
    have e2 := tri_succ n
    rw [e1, e2]; omega

theorem sum_le_of_nodup (M : Nat) :
    ∀ (n : Nat) (vs : List Nat), vs.Nodup → vs.length = n → (∀ v ∈ vs, v ≤ M) → vs.sum + n * (n - 1) / 2 ≤ n * M
  | 0, vs, _, hlen, _ => by rw [List.length_eq_zero_iff.1 hlen]; simp
  | n + 1, vs, hnd, hlen, hM => by
    -- some element is ≤ M - n
    have hsmall : ∃ v ∈ vs, v + n ≤ M := by
      apply Classical.byContradiction
      intro hno
      have h2 : ∀ v ∈ vs, (M + 1 - n) ≤ v ∧ v < (M + 1 - n) + n := by
        intro v hv
        have := hM v hv
        refine ⟨?_, by omega⟩
        apply Classical.byContradiction
        intro hlt
        exact hno ⟨v, hv, by omega⟩
      have := nodup_length_le_of_range (M + 1 - n) n vs hnd h2
      omega
    obtain ⟨v, hv, hvn⟩ := hsmall
    have hlen' : (vs.erase v).length = n := by rw [List.length_erase_of_mem hv]; omega
    have ih := sum_le_of_nodup M n (vs.erase v) (hnd.erase v) hlen'
      (fun x hx => hM x (List.mem_of_mem_erase hx))
    have hs := sum_erase_add hv
    have e1 : (n + 1) * M = n * M + M := by rw [Nat.succ_mul]
    have e2 := tri_succ n
    rw [e1, e2]; omega

theorem sum_ge_sub (m : Nat) :
    ∀ (vs L : List Nat), vs.Nodup → (∀ v ∈ vs, v ∈ L) → (∀ y ∈ L, m ≤ y) →
      vs.sum + (L.length - vs.length) * m ≤ L.sum
  | [], L, _, _, hL => by
    simp only [List.sum_nil, List.length_nil, Nat.sub_zero, Nat.zero_add]
    exact len_mul_le_sum m L hL
  | v :: vs, L, hnd, hsub, hL => by
    rw [List.nodup_cons] at hnd
    have hvL := hsub v List.mem_cons_self
    have hsub' : ∀ x ∈ vs, x ∈ L.erase v := by
      intro x hx
      have hxv : x ≠ v := fun e => hnd.1 (e ▸ hx)
      exact mem_erase_of_ne_mem (hsub x (List.mem_cons_of_mem _ hx)) hxv
    have ih := sum_ge_sub m vs (L.erase v) hnd.2 hsub' (fun y hy => hL y (List.mem_of_mem_erase hy))
    have hs := sum_erase_add hvL
    have hl := List.length_erase_of_mem hvL
    have hpos : 0 < L.length := List.length_pos_of_mem hvL
    rw [hl] at ih
    rw [List.sum_cons, List.length_cons]
    have e : L.length - (vs.length + 1) = L.length - 1 - vs.length := by omega
    rw [e]; omega

theorem sum_le_sub (M : Nat) :
    ∀ (vs L : List Nat), vs.Nodup → (∀ v ∈ vs, v ∈ L) → (∀ y ∈ L, y ≤ M) →
      L.sum ≤ vs.sum + (L.length - vs.length) * M
  | [], L, _, _, hL => by
    simp only [List.sum_nil, List.length_nil, Nat.sub_zero, Nat.zero_add]
    exact sum_le_len_mul M L hL
  | v :: vs, L, hnd, hsub, hL => by
    rw [List.nodup_cons] at hnd
    have hvL := hsub v List.mem_cons_self
    have hsub' : ∀ x ∈ vs, x ∈ L.erase v := by
      intro x hx
      have hxv : x ≠ v := fun e => hnd.1 (e ▸ hx)
      exact mem_erase_of_ne_mem (hsub x (List.mem_cons_of_mem _ hx)) hxv
    have ih := sum_le_sub M vs (L.erase v) hnd.2 hsub' (fun y hy => hL y (List.mem_of_mem_erase hy))
    have hs := sum_erase_add hvL
    have hl := List.length_erase_of_mem hvL
    have hpos : 0 < L.length := List.length_pos_of_mem hvL
    rw [hl] at ih
    rw [List.sum_cons, List.length_cons]
    have e : L.length - (vs.length + 1) = L.length - 1 - vs.length := by omega
    rw [e]; omega

theorem nodup_length_le_sub : ∀ (vs L : List Nat), vs.Nodup → (∀ v ∈ vs, v ∈ L) → vs.length ≤ L.length
  | [], L, _, _ => by simp
  | v :: vs, L, hnd, hsub => by
    rw [List.nodup_cons] at hnd
    have hvL := hsub v List.mem_cons_self
    have hsub' : ∀ x ∈ vs, x ∈ L.erase v := by
      intro x hx
      have hxv : x ≠ v := fun e => hnd.1 (e ▸ hx)
      exact mem_erase_of_ne_mem (hsub x (List.mem_cons_of_mem _ hx)) hxv
    have ih := nodup_length_le_sub vs (L.erase v) hnd.2 hsub'
    rw [List.length_erase_of_mem hvL] at ih
    have := List.length_pos_of_mem hvL
    rw [List.length_cons]; omega

end OQ64
