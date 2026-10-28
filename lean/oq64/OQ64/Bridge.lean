module

public import OQ64.Statement

/-!
# From "values + multiplicities" to an exact solution

If `a, o₁, …, o_{ℓ-1}` are pairwise distinct positive integers with multiplicities `ma, m₁, …` (all
`≥ 1`) summing to `k`, and `w = ma·a + Σ mᵢ·oᵢ ≤ N`, then `x = (a repeated ma times, o₁ repeated m₁
times, …, w)` is a solution of `x₁ + ⋯ + x_k = x_{k+1}` with exactly `ℓ + 1` distinct integers
(`w` exceeds every summand).  If all of `a, oᵢ, w` have one colour this is an `ExactSol`.
-/

@[expose] public section

namespace OQ64

theorem sum_replicate_nat (n a : Nat) : (List.replicate n a).sum = n * a := by
  induction n with
  | zero => simp
  | succ n ih => rw [List.replicate_succ, List.sum_cons, ih, Nat.succ_mul]; omega

theorem le_sum_of_mem_nat : ∀ {L : List Nat} {x : Nat}, x ∈ L → x ≤ L.sum
  | [], _, h => by simp at h
  | y :: L, x, h => by
    rw [List.sum_cons]
    rcases List.mem_cons.1 h with rfl | h
    · omega
    · have := le_sum_of_mem_nat h; omega

def expand (os : List (Nat × Nat)) : List Nat := os.flatMap (fun p => List.replicate p.1 p.2)

theorem sum_expand : ∀ os : List (Nat × Nat), (expand os).sum = (os.map (fun p => p.1 * p.2)).sum
  | [] => by simp [expand]
  | p :: os => by
    have ih := sum_expand os
    simp only [expand, List.flatMap_cons, List.sum_append, List.map_cons, List.sum_cons] at *
    rw [sum_replicate_nat, ih]

theorem length_expand : ∀ os : List (Nat × Nat), (expand os).length = (os.map Prod.fst).sum
  | [] => by simp [expand]
  | p :: os => by
    have ih := length_expand os
    simp only [expand, List.flatMap_cons, List.length_append, List.length_replicate, List.map_cons,
      List.sum_cons] at *
    rw [ih]

theorem mem_expand {x : Nat} : ∀ {os : List (Nat × Nat)}, x ∈ expand os ↔ ∃ p ∈ os, p.1 ≠ 0 ∧ x = p.2
  | [] => by simp [expand]
  | p :: os => by
    have ih := @mem_expand x os
    simp only [expand, List.flatMap_cons, List.mem_append, List.mem_replicate, List.mem_cons] at *
    constructor
    · rintro (⟨h1, h2⟩ | h)
      · exact ⟨p, Or.inl rfl, h1, h2⟩
      · obtain ⟨q, hq, h1, h2⟩ := ih.1 h
        exact ⟨q, Or.inr hq, h1, h2⟩
    · rintro ⟨q, hq | hq, h1, h2⟩
      · subst hq; exact Or.inl ⟨h1, h2⟩
      · exact Or.inr (ih.2 ⟨q, hq, h1, h2⟩)

theorem range_map_getD (L : List Nat) (d : Nat) :
    (List.range L.length).map (fun i => L.getD i d) = L := by
  apply List.ext_getElem
  · simp
  · intro i h1 h2
    simp [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem h2]

theorem exactSol_of_parts (k l N : Nat) (c : Nat → Bool) (a ma : Nat) (os : List (Nat × Nat)) (w : Nat)
    (hl : os.length + 1 = l) (hne : os ≠ []) (hma : 1 ≤ ma) (hm : ∀ p ∈ os, 1 ≤ p.1)
    (hk : ma + (os.map Prod.fst).sum = k)
    (ha1 : 1 ≤ a) (ho1 : ∀ p ∈ os, 1 ≤ p.2) (hdist : (a :: os.map Prod.snd).Nodup)
    (hw : w = ma * a + (os.map (fun p => p.1 * p.2)).sum) (hwN : w ≤ N)
    (hcol : ∀ y ∈ a :: os.map Prod.snd, c y = c w) : ExactSol k l N c := by
  -- the list of summands
  let L : List Nat := List.replicate ma a ++ expand os
  have hLlen : L.length = k := by
    simp only [L, List.length_append, List.length_replicate, length_expand]; omega
  have hLsum : L.sum = w := by
    simp only [L, List.sum_append, sum_replicate_nat, sum_expand]; omega
  have hmemL : ∀ y ∈ L, y = a ∨ y ∈ os.map Prod.snd := by
    intro y hy
    simp only [L, List.mem_append, List.mem_replicate] at hy
    rcases hy with ⟨_, rfl⟩ | hy
    · exact Or.inl rfl
    · obtain ⟨p, hp, _, rfl⟩ := mem_expand.1 hy
      exact Or.inr (List.mem_map.2 ⟨p, hp, rfl⟩)
  -- every summand is < w
  have hsum_pos : ∀ p ∈ os, p.2 ≤ (os.map (fun p => p.1 * p.2)).sum := by
    intro p hp
    have h1 : p.1 * p.2 ≤ (os.map (fun p => p.1 * p.2)).sum :=
      le_sum_of_mem_nat (List.mem_map.2 ⟨p, hp, rfl⟩)
    have h2 : p.2 ≤ p.1 * p.2 := Nat.le_mul_of_pos_left _ (hm p hp)
    omega
  have hos_pos : 1 ≤ (os.map (fun p => p.1 * p.2)).sum := by
    obtain ⟨p, hp⟩ := List.exists_mem_of_ne_nil os hne
    have := hsum_pos p hp; have := ho1 p hp; omega
  have hlt_a : a < w := by
    have : a ≤ ma * a := Nat.le_mul_of_pos_left _ hma
    omega
  have hlt_o : ∀ p ∈ os, p.2 < w := by
    intro p hp
    have := hsum_pos p hp
    have : 1 ≤ ma * a := Nat.mul_pos hma ha1
    omega
  let x : Nat → Nat := fun i => L.getD i w
  have hxk : x k = w := by
    simp only [x]
    rw [List.getD_eq_getElem?_getD, List.getElem?_eq_none (by omega)]
    rfl
  have hx_lt : ∀ i, i < k → x i ∈ L := by
    intro i hi
    simp only [x]
    rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem (by omega)]
    exact List.getElem_mem (by omega)
  refine ⟨x, w :: a :: os.map Prod.snd, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro i hi
    rcases Nat.lt_or_ge i k with h | h
    · rcases hmemL _ (hx_lt i h) with h' | h'
      · rw [h']; omega
      · obtain ⟨p, hp, hpe⟩ := List.mem_map.1 h'
        rw [← hpe]; have := ho1 p hp; have := hlt_o p hp; omega
    · have : i = k := by omega
      subst this; rw [hxk]; omega
  · rw [hxk, ← hLsum, ← hLlen]; simp only [x]; rw [range_map_getD]
  · rw [List.nodup_cons]
    refine ⟨?_, hdist⟩
    intro h
    rcases List.mem_cons.1 h with h | h
    · omega
    · obtain ⟨p, hp, hpe⟩ := List.mem_map.1 h
      have := hlt_o p hp; omega
  · simp; omega
  · intro i hi
    rcases Nat.lt_or_ge i k with h | h
    · rcases hmemL _ (hx_lt i h) with h' | h'
      · exact List.mem_cons_of_mem _ (by rw [h']; exact List.mem_cons_self)
      · exact List.mem_cons_of_mem _ (List.mem_cons_of_mem _ h')
    · have : i = k := by omega
      subst this; rw [hxk]; exact List.mem_cons_self
  · intro v hv
    rcases List.mem_cons.1 hv with rfl | hv
    · exact ⟨k, Nat.le_refl _, hxk⟩
    · -- v is a summand value: find an index of L
      have hvL : v ∈ L := by
        rcases List.mem_cons.1 hv with rfl | hv
        · exact List.mem_append.2 (Or.inl (List.mem_replicate.2 ⟨by omega, rfl⟩))
        · obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hv
          simp only [L, List.mem_append]; right
          exact mem_expand.2 ⟨p, hp, by have := hm p hp; omega, rfl⟩
      obtain ⟨i, hi, hiv⟩ := List.mem_iff_getElem.1 hvL
      refine ⟨i, by omega, ?_⟩
      simp only [x]
      rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hi]
      exact hiv
  · intro i hi
    rw [hxk]
    rcases Nat.lt_or_ge i k with h | h
    · rcases hmemL _ (hx_lt i h) with h' | h'
      · rw [h']; exact hcol a List.mem_cons_self
      · exact hcol _ (List.mem_cons_of_mem _ h')
    · have : i = k := by omega
      subst this; rw [hxk]

end OQ64
