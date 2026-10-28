module

public import RSN.CaseCNF

/-! # From an assignment-falsified clause to colour facts (generic lemmas) -/

@[expose] public section

namespace RSN

def valOf (g : Nat → Fin 3) (x : Nat) : Bool := (g ((x - 1) / 3 + 1)).val == (x - 1) % 3

theorem valOf_var (g : Nat → Fin 3) (i col : Nat) (hi : 1 ≤ i) (hc : col < 3) :
    valOf g (var i col) = ((g i).val == col) := by
  unfold valOf var
  have h1 : (3 * (i - 1) + col + 1 - 1) / 3 + 1 = i := by omega
  have h2 : (3 * (i - 1) + col + 1 - 1) % 3 = col := by omega
  rw [h1, h2]

theorem litEval_pos (v : Nat → Bool) (x : Nat) : litEval v (2 * x) = v x := by
  unfold litEval
  have h2 : (2 * x) / 2 = x := by omega
  simp [h2]

theorem litEval_negLit (v : Nat → Bool) (x : Nat) : litEval v (2 * x + 1) = !v x := by
  unfold litEval
  have h1 : ¬ (2 * x + 1) % 2 = 0 := by omega
  have h2 : (2 * x + 1) / 2 = x := by omega
  simp [h1, h2]

theorem fin3_cases (u : Fin 3) : u.val = 0 ∨ u.val = 1 ∨ u.val = 2 := by omega

def idsInRange (n : Nat) (es : List (Nat × Nat × Nat)) (reds blues : List Nat) : Bool :=
  es.all (fun t => decide (1 ≤ t.1 ∧ t.1 ≤ n ∧ 1 ≤ t.2.1 ∧ t.2.1 ≤ n ∧ 1 ≤ t.2.2 ∧ t.2.2 ≤ n)) &&
  reds.all (fun i => decide (1 ≤ i ∧ i ≤ n)) && blues.all (fun i => decide (1 ≤ i ∧ i ≤ n))

/-- Every colouring `g` of the vertex ids either has a monochromatic edge, or violates a red or
blue unit fact — provided the case CNF is unsatisfiable. -/
theorem case_alternatives (n : Nat) (es : List (Nat × Nat × Nat)) (reds blues : List Nat)
    (hr : idsInRange n es reds blues = true)
    (hunsat : ∀ v : Nat → Bool, ∃ c ∈ caseCNF n es reds blues, clauseEval v c = false)
    (g : Nat → Fin 3) :
    (∃ t ∈ es, g t.1 = g t.2.1 ∧ g t.2.1 = g t.2.2) ∨
    (∃ i ∈ reds, (g i).val ≠ 0) ∨ (∃ i ∈ blues, (g i).val ≠ 1) := by
  simp only [idsInRange, Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at hr
  obtain ⟨⟨hre, hrr⟩, hrb⟩ := hr
  obtain ⟨c, hc, hfalse⟩ := hunsat (valOf g)
  simp only [caseCNF, unitClauses, List.mem_append] at hc
  rcases hc with (hc | hc) | hc | hc
  · exfalso
    simp only [aloClauses, List.mem_map, List.mem_range] at hc
    obtain ⟨j, hj, rfl⟩ := hc
    simp only [clauseEval, List.any_cons, List.any_nil, litEval_pos, Bool.or_false] at hfalse
    rw [valOf_var g _ 0 (by omega) (by omega), valOf_var g _ 1 (by omega) (by omega),
      valOf_var g _ 2 (by omega) (by omega)] at hfalse
    rcases fin3_cases (g (j + 1)) with h | h | h <;> simp [h] at hfalse
  · left
    simp only [forbidClauses, List.mem_flatMap, List.mem_map] at hc
    obtain ⟨t, ht, col, hcol, rfl⟩ := hc
    have hrt := hre t ht
    have hcol3 : col < 3 := by simp at hcol; omega
    simp only [forbidOne, clauseEval, List.any_cons, List.any_nil, litEval_negLit, Bool.or_false,
      Bool.or_eq_false_iff, Bool.not_eq_false'] at hfalse
    obtain ⟨hx, hy, hz⟩ := hfalse
    rw [valOf_var g _ _ (by omega) hcol3] at hx hy hz
    simp only [beq_iff_eq] at hx hy hz
    refine ⟨t, ht, Fin.ext ?_, Fin.ext ?_⟩ <;> omega
  · right; left
    simp only [List.mem_map] at hc
    obtain ⟨i, hi, rfl⟩ := hc
    have hri := hrr i hi
    simp only [clauseEval, List.any_cons, List.any_nil, litEval_pos, Bool.or_false] at hfalse
    rw [valOf_var g i 0 (by omega) (by omega)] at hfalse
    refine ⟨i, hi, ?_⟩
    simpa using hfalse
  · right; right
    simp only [List.mem_map] at hc
    obtain ⟨i, hi, rfl⟩ := hc
    have hri := hrb i hi
    simp only [clauseEval, List.any_cons, List.any_nil, litEval_pos, Bool.or_false] at hfalse
    rw [valOf_var g i 1 (by omega) (by omega)] at hfalse
    refine ⟨i, hi, ?_⟩
    simpa using hfalse

end RSN
