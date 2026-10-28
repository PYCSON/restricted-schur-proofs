module

public import RSN.Statement
public import RSN.Bridge

/-! # Direct (non-symbolic) instances for small `k`: vertex ids are the integers themselves -/

@[expose] public section

namespace RSN

def edgesOK (k : Nat) (es : List (Nat × Nat × Nat)) : Bool :=
  es.all (fun e => decide (e.2.2 = (k - 1) * e.1 + e.2.1 ∧ e.1 ≠ e.2.1))

theorem direct_case (k : Nat) (es : List (Nat × Nat × Nat)) (hF : 2 ≤ F k)
    (hr : idsInRange (F k) es [1] [] = true) (he : edgesOK k es = true)
    (hunsat : ∀ v : Nat → Bool, ∃ c ∈ caseCNF (F k) es [1] [], clauseEval v c = false)
    (c : Nat → Fin 3) (h1 : c 1 = 0) : WeakMono k (F k) c := by
  have hr' := hr
  simp only [idsInRange, Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at hr'
  obtain ⟨⟨hre, _⟩, _⟩ := hr'
  rcases case_alternatives (F k) es [1] [] hr hunsat c with ⟨e, hmem, hxy, hyz⟩ | ⟨i, hi, hne⟩ | ⟨i, hi, _⟩
  · have hrt := hre e hmem
    have hee := List.all_eq_true.1 he e hmem
    simp only [decide_eq_true_eq] at hee
    obtain ⟨hw, hne⟩ := hee
    refine ⟨e.1, e.2.1, by omega, by omega, hne, by omega, hxy, ?_⟩
    rw [← hw]; exact hyz
  · simp only [List.mem_singleton] at hi
    subst hi
    exact absurd (by simp [h1]) hne
  · simp at hi

end RSN
