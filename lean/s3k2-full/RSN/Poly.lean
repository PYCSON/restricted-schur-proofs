module

public import Init

/-!
# Integer polynomials as coefficient lists, with checkable certificates

`peval [d0, d1, …] m = d0 + m * (d1 + m * (…))`. Identities and sign conditions are reduced to
coefficient checks that `decide +kernel` can evaluate.
-/

@[expose] public section

namespace RSN

def peval : List Int → Int → Int
  | [], _ => 0
  | c :: cs, m => c + m * peval cs m

def padd : List Int → List Int → List Int
  | [], q => q
  | p@(_ :: _), [] => p
  | a :: p, b :: q => (a + b) :: padd p q

def pscale (k : Int) (p : List Int) : List Int := p.map (k * ·)

/-- `(a0 + a1 * m) * p`. -/
def pmulLin (a0 a1 : Int) (p : List Int) : List Int := padd (pscale a0 p) (0 :: pscale a1 p)

theorem peval_padd : ∀ (p q : List Int) (m : Int), peval (padd p q) m = peval p m + peval q m
  | [], q, m => by simp [padd, peval]
  | _ :: _, [], m => by simp [padd, peval]
  | a :: p, b :: q, m => by
    simp only [padd, peval, peval_padd p q m, Int.mul_add]
    omega

theorem peval_pscale (k : Int) : ∀ (p : List Int) (m : Int), peval (pscale k p) m = k * peval p m
  | [], m => by simp [pscale, peval]
  | c :: cs, m => by
    have ih := peval_pscale k cs m
    simp only [pscale] at ih
    simp only [pscale, List.map_cons, peval, ih, Int.mul_add, Int.mul_left_comm]

theorem peval_pmulLin (a0 a1 : Int) (p : List Int) (m : Int) :
    peval (pmulLin a0 a1 p) m = (a0 + a1 * m) * peval p m := by
  simp only [pmulLin, peval_padd, peval_pscale, peval, Int.add_mul, Int.zero_add]
  rw [Int.mul_left_comm m a1, Int.mul_assoc]

def allZero (p : List Int) : Bool := p.all (· == 0)

def allNonneg (p : List Int) : Bool := p.all (fun c => decide (0 ≤ c))

theorem peval_allZero : ∀ (p : List Int) (m : Int), allZero p = true → peval p m = 0
  | [], _, _ => rfl
  | c :: cs, m, h => by
    simp only [allZero, List.all_cons, Bool.and_eq_true, beq_iff_eq] at h
    have ih := peval_allZero cs m (by simpa [allZero] using h.2)
    simp [peval, ih, h.1]

theorem peval_allNonneg : ∀ (p : List Int) (m : Int), 0 ≤ m → allNonneg p = true → 0 ≤ peval p m
  | [], _, _, _ => by simp [peval]
  | c :: cs, m, hm, h => by
    simp only [allNonneg, List.all_cons, Bool.and_eq_true, decide_eq_true_eq] at h
    have ih := peval_allNonneg cs m hm (by simpa [allNonneg] using h.2)
    simp only [peval]
    have := Int.mul_nonneg hm ih
    omega

end RSN
