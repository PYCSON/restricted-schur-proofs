module

public import RSN.Poly

/-!
# Bivariate integer polynomials `P(s, t)` as lists of univariate coefficient lists

`P = [Q₀, Q₁, …]` means `P(s,t) = Q₀(t) + s * (Q₁(t) + s * (…))`.
-/

@[expose] public section

namespace RSN

def peval2 : List (List Int) → Int → Int → Int
  | [], _, _ => 0
  | q :: qs, s, t => peval q t + s * peval2 qs s t

def padd2 : List (List Int) → List (List Int) → List (List Int)
  | [], q => q
  | p@(_ :: _), [] => p
  | a :: p, b :: q => padd a b :: padd2 p q

def pscale2 (k : Int) (p : List (List Int)) : List (List Int) := p.map (pscale k)

/-- `(6 + t + s) * P`, i.e. multiplication by `k - 1` where `k = s + t + 7`. -/
def mulK2 (p : List (List Int)) : List (List Int) := padd2 (p.map (pmulLin 6 1)) ([] :: p)

theorem peval2_padd2 : ∀ (p q : List (List Int)) (s t : Int),
    peval2 (padd2 p q) s t = peval2 p s t + peval2 q s t
  | [], q, s, t => by simp [padd2, peval2]
  | _ :: _, [], s, t => by simp [padd2, peval2]
  | a :: p, b :: q, s, t => by
    simp only [padd2, peval2, peval_padd, peval2_padd2 p q s t, Int.mul_add]
    omega

theorem peval2_pscale2 (k : Int) : ∀ (p : List (List Int)) (s t : Int),
    peval2 (pscale2 k p) s t = k * peval2 p s t
  | [], s, t => by simp [pscale2, peval2]
  | q :: qs, s, t => by
    have ih := peval2_pscale2 k qs s t
    simp only [pscale2] at ih
    simp only [pscale2, List.map_cons, peval2, ih, peval_pscale, Int.mul_add, Int.mul_left_comm]

theorem peval2_map_pmulLin : ∀ (p : List (List Int)) (s t : Int),
    peval2 (p.map (pmulLin 6 1)) s t = (6 + t) * peval2 p s t
  | [], s, t => by simp [peval2]
  | q :: qs, s, t => by
    have ih := peval2_map_pmulLin qs s t
    simp only [List.map_cons, peval2, ih, peval_pmulLin, Int.mul_add, Int.one_mul, Int.mul_left_comm]

theorem peval2_mulK2 (p : List (List Int)) (s t : Int) :
    peval2 (mulK2 p) s t = (6 + t + s) * peval2 p s t := by
  simp only [mulK2, peval2_padd2, peval2_map_pmulLin, peval2, peval]
  rw [Int.add_mul (6 + t) s]
  omega

def allNonneg2 (p : List (List Int)) : Bool := p.all allNonneg

def allZero2 (p : List (List Int)) : Bool := p.all allZero

theorem peval2_allNonneg2 : ∀ (p : List (List Int)) (s t : Int), 0 ≤ s → 0 ≤ t →
    allNonneg2 p = true → 0 ≤ peval2 p s t
  | [], _, _, _, _, _ => by simp [peval2]
  | q :: qs, s, t, hs, ht, h => by
    simp only [allNonneg2, List.all_cons, Bool.and_eq_true] at h
    have ih := peval2_allNonneg2 qs s t hs ht (by simpa [allNonneg2] using h.2)
    have hq := peval_allNonneg q t ht h.1
    simp only [peval2]
    have := Int.mul_nonneg hs ih
    omega

theorem peval2_allZero2 : ∀ (p : List (List Int)) (s t : Int), allZero2 p = true → peval2 p s t = 0
  | [], _, _, _ => rfl
  | q :: qs, s, t, h => by
    simp only [allZero2, List.all_cons, Bool.and_eq_true] at h
    have ih := peval2_allZero2 qs s t (by simpa [allZero2] using h.2)
    have hq := peval_allZero q t h.1
    simp [peval2, ih, hq]

end RSN
