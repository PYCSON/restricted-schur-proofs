module

public import RSN.Statement
public import RSN.Poly
public import RSN.Bridge

/-!
# One univariate kernel case ⇒ a weak monochromatic solution, for all `k = t + 8`

Vertex `i` is the integer `P_i(t)` (coefficient list in `t`, `k = t + 8`). Kernel-checked
certificates show: `1 ≤ P_i ≤ F`, each edge satisfies `P_w = (t + 7) P_u + P_v` with `P_u ≠ P_v`,
red vertices lie in `[1, a]` and the blue vertex equals `a + 1`, where `a = A(t)`.
-/

@[expose] public section

namespace RSN

/-- `F (t + 8)` as a polynomial in `t`. -/
def Fpoly8 : List Int := [718, 242, 27, 1]

theorem F_eq (t : Nat) : ((F (t + 8) : Nat) : Int) = peval Fpoly8 (t : Int) := by
  simp only [F, Fpoly8, peval]
  have h : 2 ≤ (t + 8) ^ 3 + 3 * (t + 8) ^ 2 + 2 * (t + 8) := by
    have : 8 ≤ (t + 8) ^ 3 := by
      have := Nat.pow_le_pow_left (show 2 ≤ t + 8 by omega) 3
      simpa using this
    omega
  rw [Int.ofNat_sub h]
  push_cast
  grind

def getP (vs : List (List Int)) (i : Nat) : List Int := vs.getD (i - 1) []

def vertsOK (n : Nat) (vs : List (List Int)) : Bool :=
  (List.range n).all (fun j =>
    allNonneg (padd (getP vs (j + 1)) [-1]) && allNonneg (padd Fpoly8 (pscale (-1) (getP vs (j + 1)))))

def identOK (vs : List (List Int)) (es : List (Nat × Nat × Nat)) : Bool :=
  es.all (fun t =>
    allZero (padd (pmulLin 7 1 (getP vs t.1)) (padd (getP vs t.2.1) (pscale (-1) (getP vs t.2.2)))))

def posOK (p : List Int) : Bool := allNonneg (padd p [-1])

def distOK (vs : List (List Int)) (es : List (Nat × Nat × Nat)) : Bool :=
  es.all (fun t =>
    posOK (padd (getP vs t.1) (pscale (-1) (getP vs t.2.1))) ||
    posOK (padd (getP vs t.2.1) (pscale (-1) (getP vs t.1))))

def redOK (vs : List (List Int)) (A : List Int) (reds : List Nat) : Bool :=
  reds.all (fun i => allNonneg (padd (getP vs i) [-1]) && allNonneg (padd A (pscale (-1) (getP vs i))))

def blueOK (vs : List (List Int)) (A : List Int) (blues : List Nat) : Bool :=
  blues.all (fun i => allZero (padd (getP vs i) (pscale (-1) (padd A [1]))))

theorem vert_range (n : Nat) (vs : List (List Int)) (hv : vertsOK n vs = true) (i : Nat)
    (hi1 : 1 ≤ i) (hi2 : i ≤ n) (m : Int) (hm : 0 ≤ m) :
    1 ≤ peval (getP vs i) m ∧ peval (getP vs i) m ≤ peval Fpoly8 m := by
  have h := List.all_eq_true.1 hv (i - 1) (List.mem_range.2 (by omega))
  have hi : i - 1 + 1 = i := by omega
  rw [hi] at h
  simp only [Bool.and_eq_true] at h
  have h1 := peval_allNonneg _ m hm h.1
  have h2 := peval_allNonneg _ m hm h.2
  rw [peval_padd] at h1 h2
  rw [peval_pscale] at h2
  simp only [peval] at h1
  omega

theorem pos_of_posOK (p : List Int) (m : Int) (hm : 0 ≤ m) (h : posOK p = true) : 1 ≤ peval p m := by
  have := peval_allNonneg _ m hm h
  rw [peval_padd] at this
  simp only [peval] at this
  omega

/-- **One case.** If the case CNF is unsatisfiable and all certificates check, then every
colouring with `[1, A(t)]` red and `A(t) + 1` blue has a weak monochromatic solution in
`[1, F (t + 8)]`. -/
theorem uni_case (n : Nat) (vs : List (List Int)) (es : List (Nat × Nat × Nat)) (reds blues : List Nat)
    (A : List Int)
    (hr : idsInRange n es reds blues = true) (hv : vertsOK n vs = true) (hi : identOK vs es = true)
    (hd : distOK vs es = true) (hred : redOK vs A reds = true) (hblue : blueOK vs A blues = true)
    (hunsat : ∀ v : Nat → Bool, ∃ c ∈ caseCNF n es reds blues, clauseEval v c = false)
    (t : Nat) (c : Nat → Fin 3)
    (hR : ∀ j : Nat, 1 ≤ j → (j : Int) ≤ peval A (t : Int) → c j = 0)
    (hB : ∀ j : Nat, (j : Int) = peval A (t : Int) + 1 → c j = 1) :
    WeakMono (t + 8) (F (t + 8)) c := by
  have hm : (0 : Int) ≤ (t : Int) := Int.natCast_nonneg t
  let val : Nat → Nat := fun i => (peval (getP vs i) (t : Int)).toNat
  have hval : ∀ i, 1 ≤ i → i ≤ n → ((val i : Nat) : Int) = peval (getP vs i) (t : Int) ∧
      1 ≤ peval (getP vs i) (t : Int) ∧ peval (getP vs i) (t : Int) ≤ peval Fpoly8 (t : Int) := by
    intro i h1 h2
    have r := vert_range n vs hv i h1 h2 (t : Int) hm
    exact ⟨Int.toNat_of_nonneg (by omega), r⟩
  have hr' := hr
  simp only [idsInRange, Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at hr'
  obtain ⟨⟨hre, hrr⟩, hrb⟩ := hr'
  rcases case_alternatives n es reds blues hr hunsat (fun i => c (val i)) with
    ⟨e, he, hxy, hyz⟩ | ⟨i, hi', hne⟩ | ⟨i, hi', hne⟩
  · -- a monochromatic edge
    have hrt := hre e he
    obtain ⟨ex, rx1, rx2⟩ := hval e.1 (by omega) (by omega)
    obtain ⟨ey, ry1, ry2⟩ := hval e.2.1 (by omega) (by omega)
    obtain ⟨ez, rz1, rz2⟩ := hval e.2.2 (by omega) (by omega)
    have hid := peval_allZero _ (t : Int) (List.all_eq_true.1 hi e he)
    rw [peval_padd, peval_padd, peval_pmulLin, peval_pscale] at hid
    have hdist := List.all_eq_true.1 hd e he
    simp only [Bool.or_eq_true] at hdist
    have hne : peval (getP vs e.1) (t : Int) ≠ peval (getP vs e.2.1) (t : Int) := by
      rcases hdist with h | h
      · have := pos_of_posOK _ (t : Int) hm h
        rw [peval_padd, peval_pscale] at this
        omega
      · have := pos_of_posOK _ (t : Int) hm h
        rw [peval_padd, peval_pscale] at this
        omega
    have hF := F_eq t
    have h7 : t + 8 - 1 = t + 7 := by omega
    have hid' : ((t : Int) + 7) * peval (getP vs e.1) (t : Int) + peval (getP vs e.2.1) (t : Int) =
        peval (getP vs e.2.2) (t : Int) := by
      have : (7 + 1 * (t : Int)) = (t : Int) + 7 := by omega
      rw [this] at hid
      omega
    have hw : (t + 8 - 1) * val e.1 + val e.2.1 = val e.2.2 := by
      rw [h7]
      have : (((t + 7) * val e.1 + val e.2.1 : Nat) : Int) = ((val e.2.2 : Nat) : Int) := by
        push_cast
        rw [ex, ey, ez]
        exact hid'
      exact Int.ofNat.inj this
    refine ⟨val e.1, val e.2.1, by omega, by omega, ?_, ?_, ?_, ?_⟩
    · intro h; apply hne; rw [← ex, ← ey, h]
    · rw [hw]; omega
    · exact hxy
    · rw [hw]; exact hyz
  · -- a red vertex not coloured 0: impossible
    exfalso
    have hri := hrr i hi'
    obtain ⟨ex, r1, _⟩ := hval i (by omega) (by omega)
    have hc := List.all_eq_true.1 hred i hi'
    simp only [Bool.and_eq_true] at hc
    have h2 := peval_allNonneg _ (t : Int) hm hc.2
    rw [peval_padd, peval_pscale] at h2
    have := hR (val i) (by omega) (by omega)
    exact hne (by simp [this])
  · -- the blue vertex not coloured 1: impossible
    exfalso
    have hri := hrb i hi'
    obtain ⟨ex, r1, _⟩ := hval i (by omega) (by omega)
    have hc := peval_allZero _ (t : Int) (List.all_eq_true.1 hblue i hi')
    rw [peval_padd, peval_pscale, peval_padd] at hc
    simp only [peval] at hc
    have := hB (val i) (by omega)
    exact hne (by simp [this])

end RSN
