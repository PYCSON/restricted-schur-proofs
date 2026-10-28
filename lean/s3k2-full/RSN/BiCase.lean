module

public import RSN.Statement
public import RSN.Poly2
public import RSN.Bridge

/-!
# The bivariate kernel case ⇒ a weak monochromatic solution, for all `a = s + 4`, `k = s + t + 7`
-/

@[expose] public section

namespace RSN

/-- `F (s + t + 7)` as a bivariate polynomial. -/
def Fpoly2 : List (List Int) := [[502, 191, 24, 1], [191, 48, 3], [24, 3], [1]]

theorem F_eq2 (s t : Nat) : ((F (s + t + 7) : Nat) : Int) = peval2 Fpoly2 (s : Int) (t : Int) := by
  simp only [F, Fpoly2, peval2, peval]
  have h : 2 ≤ (s + t + 7) ^ 3 + 3 * (s + t + 7) ^ 2 + 2 * (s + t + 7) := by
    have : 7 ≤ (s + t + 7) ^ 3 := by
      have := Nat.pow_le_pow_left (show 2 ≤ s + t + 7 by omega) 3
      simp at this; omega
    omega
  rw [Int.ofNat_sub h]
  push_cast
  grind

def getP2 (vs : List (List (List Int))) (i : Nat) : List (List Int) := vs.getD (i - 1) []

def vertsOK2 (n : Nat) (vs : List (List (List Int))) : Bool :=
  (List.range n).all (fun j =>
    allNonneg2 (padd2 (getP2 vs (j + 1)) [[-1]]) && allNonneg2 (padd2 Fpoly2 (pscale2 (-1) (getP2 vs (j + 1)))))

def identOK2 (vs : List (List (List Int))) (es : List (Nat × Nat × Nat)) : Bool :=
  es.all (fun t =>
    allZero2 (padd2 (mulK2 (getP2 vs t.1)) (padd2 (getP2 vs t.2.1) (pscale2 (-1) (getP2 vs t.2.2)))))

def posOK2 (p : List (List Int)) : Bool := allNonneg2 (padd2 p [[-1]])

def distOK2 (vs : List (List (List Int))) (es : List (Nat × Nat × Nat)) : Bool :=
  es.all (fun t =>
    posOK2 (padd2 (getP2 vs t.1) (pscale2 (-1) (getP2 vs t.2.1))) ||
    posOK2 (padd2 (getP2 vs t.2.1) (pscale2 (-1) (getP2 vs t.1))))

def redOK2 (vs : List (List (List Int))) (A : List (List Int)) (reds : List Nat) : Bool :=
  reds.all (fun i => allNonneg2 (padd2 (getP2 vs i) [[-1]]) && allNonneg2 (padd2 A (pscale2 (-1) (getP2 vs i))))

def blueOK2 (vs : List (List (List Int))) (A : List (List Int)) (blues : List Nat) : Bool :=
  blues.all (fun i => allZero2 (padd2 (getP2 vs i) (pscale2 (-1) (padd2 A [[1]]))))

theorem vert_range2 (n : Nat) (vs : List (List (List Int))) (hv : vertsOK2 n vs = true) (i : Nat)
    (hi1 : 1 ≤ i) (hi2 : i ≤ n) (s t : Int) (hs : 0 ≤ s) (ht : 0 ≤ t) :
    1 ≤ peval2 (getP2 vs i) s t ∧ peval2 (getP2 vs i) s t ≤ peval2 Fpoly2 s t := by
  have h := List.all_eq_true.1 hv (i - 1) (List.mem_range.2 (by omega))
  have hi : i - 1 + 1 = i := by omega
  rw [hi] at h
  simp only [Bool.and_eq_true] at h
  have h1 := peval2_allNonneg2 _ s t hs ht h.1
  have h2 := peval2_allNonneg2 _ s t hs ht h.2
  rw [peval2_padd2] at h1 h2
  rw [peval2_pscale2] at h2
  simp only [peval2, peval] at h1
  omega

theorem pos_of_posOK2 (p : List (List Int)) (s t : Int) (hs : 0 ≤ s) (ht : 0 ≤ t) (h : posOK2 p = true) :
    1 ≤ peval2 p s t := by
  have := peval2_allNonneg2 _ s t hs ht h
  rw [peval2_padd2] at this
  simp only [peval2, peval] at this
  omega

theorem bi_case (n : Nat) (vs : List (List (List Int))) (es : List (Nat × Nat × Nat)) (reds blues : List Nat)
    (A : List (List Int))
    (hr : idsInRange n es reds blues = true) (hv : vertsOK2 n vs = true) (hi : identOK2 vs es = true)
    (hd : distOK2 vs es = true) (hred : redOK2 vs A reds = true) (hblue : blueOK2 vs A blues = true)
    (hunsat : ∀ v : Nat → Bool, ∃ c ∈ caseCNF n es reds blues, clauseEval v c = false)
    (s t : Nat) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → (j : Int) ≤ peval2 A (s : Int) (t : Int) → c j = 0)
    (hB : ∀ j : Nat, (j : Int) = peval2 A (s : Int) (t : Int) + 1 → c j = 1) :
    WeakMono (s + t + 7) (F (s + t + 7)) c := by
  have hs : (0 : Int) ≤ (s : Int) := Int.natCast_nonneg s
  have ht : (0 : Int) ≤ (t : Int) := Int.natCast_nonneg t
  let val : Nat → Nat := fun i => (peval2 (getP2 vs i) (s : Int) (t : Int)).toNat
  have hval : ∀ i, 1 ≤ i → i ≤ n → ((val i : Nat) : Int) = peval2 (getP2 vs i) (s : Int) (t : Int) ∧
      1 ≤ peval2 (getP2 vs i) (s : Int) (t : Int) ∧
      peval2 (getP2 vs i) (s : Int) (t : Int) ≤ peval2 Fpoly2 (s : Int) (t : Int) := by
    intro i h1 h2
    have r := vert_range2 n vs hv i h1 h2 (s : Int) (t : Int) hs ht
    exact ⟨Int.toNat_of_nonneg (by omega), r⟩
  have hr' := hr
  simp only [idsInRange, Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at hr'
  obtain ⟨⟨hre, hrr⟩, hrb⟩ := hr'
  rcases case_alternatives n es reds blues hr hunsat (fun i => c (val i)) with
    ⟨e, he, hxy, hyz⟩ | ⟨i, hi', hne⟩ | ⟨i, hi', hne⟩
  · have hrt := hre e he
    obtain ⟨ex, rx1, rx2⟩ := hval e.1 (by omega) (by omega)
    obtain ⟨ey, ry1, ry2⟩ := hval e.2.1 (by omega) (by omega)
    obtain ⟨ez, rz1, rz2⟩ := hval e.2.2 (by omega) (by omega)
    have hid := peval2_allZero2 _ (s : Int) (t : Int) (List.all_eq_true.1 hi e he)
    rw [peval2_padd2, peval2_padd2, peval2_mulK2, peval2_pscale2] at hid
    have hdist := List.all_eq_true.1 hd e he
    simp only [Bool.or_eq_true] at hdist
    have hne : peval2 (getP2 vs e.1) (s : Int) (t : Int) ≠ peval2 (getP2 vs e.2.1) (s : Int) (t : Int) := by
      rcases hdist with h | h
      · have := pos_of_posOK2 _ (s : Int) (t : Int) hs ht h
        rw [peval2_padd2, peval2_pscale2] at this
        omega
      · have := pos_of_posOK2 _ (s : Int) (t : Int) hs ht h
        rw [peval2_padd2, peval2_pscale2] at this
        omega
    have hF := F_eq2 s t
    have h7 : s + t + 7 - 1 = s + t + 6 := by omega
    have hid' : ((s : Int) + (t : Int) + 6) * peval2 (getP2 vs e.1) (s : Int) (t : Int) +
        peval2 (getP2 vs e.2.1) (s : Int) (t : Int) = peval2 (getP2 vs e.2.2) (s : Int) (t : Int) := by
      have : (6 + (t : Int) + (s : Int)) = (s : Int) + (t : Int) + 6 := by omega
      rw [this] at hid
      omega
    have hw : (s + t + 7 - 1) * val e.1 + val e.2.1 = val e.2.2 := by
      rw [h7]
      have : (((s + t + 6) * val e.1 + val e.2.1 : Nat) : Int) = ((val e.2.2 : Nat) : Int) := by
        push_cast
        rw [ex, ey, ez]
        exact hid'
      exact Int.ofNat.inj this
    refine ⟨val e.1, val e.2.1, by omega, by omega, ?_, ?_, ?_, ?_⟩
    · intro h; apply hne; rw [← ex, ← ey, h]
    · rw [hw]; omega
    · exact hxy
    · rw [hw]; exact hyz
  · exfalso
    have hri := hrr i hi'
    obtain ⟨ex, r1, _⟩ := hval i (by omega) (by omega)
    have hc := List.all_eq_true.1 hred i hi'
    simp only [Bool.and_eq_true] at hc
    have h2 := peval2_allNonneg2 _ (s : Int) (t : Int) hs ht hc.2
    rw [peval2_padd2, peval2_pscale2] at h2
    have := hR (val i) (by omega) (by omega)
    exact hne (by simp [this])
  · exfalso
    have hri := hrb i hi'
    obtain ⟨ex, r1, _⟩ := hval i (by omega) (by omega)
    have hc := peval2_allZero2 _ (s : Int) (t : Int) (List.all_eq_true.1 hblue i hi')
    rw [peval2_padd2, peval2_pscale2, peval2_padd2] at hc
    simp only [peval2, peval] at hc
    have := hB (val i) (by omega)
    exact hne (by simp [this])

end RSN
