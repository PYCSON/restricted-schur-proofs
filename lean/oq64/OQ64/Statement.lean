module

public import Init

/-!
# Statement: Gaiser's two-colour restricted generalized Schur numbers, exact version

C. Gaiser, *Restricted generalized Schur numbers*, arXiv:2608.08789.  `S₂(k;ℓ)` is the least `N` such
that every 2-colouring of `[1, N]` admits a monochromatic solution of `x₁ + ⋯ + x_k = x_{k+1}` that
uses **exactly** `ℓ + 1` distinct integers.

`ExactSol k l N c` says: there are `x 0, …, x k ∈ [1, N]` with `x 0 + ⋯ + x (k-1) = x k`, all of the
same colour under `c`, whose set of values is the set of entries of a duplicate-free list `vals` of
length `l + 1` (so exactly `l + 1` distinct integers occur).  This is the definition to review by hand.
-/

@[expose] public section

namespace OQ64

def ExactSol (k l N : Nat) (c : Nat → Bool) : Prop :=
  ∃ (x : Nat → Nat) (vals : List Nat),
    (∀ i, i ≤ k → 1 ≤ x i ∧ x i ≤ N) ∧
    ((List.range k).map x).sum = x k ∧
    vals.Nodup ∧ vals.length = l + 1 ∧
    (∀ i, i ≤ k → x i ∈ vals) ∧
    (∀ v ∈ vals, ∃ i, i ≤ k ∧ x i = v) ∧
    (∀ i, i ≤ k → c (x i) = c (x k))

/-- Gaiser's formula `F(k, ℓ) = k² + [((ℓ+1)(ℓ−2))/2 + 2]·k + ℓ(ℓ−2)` (here `ℓ ≥ 2`). -/
def F (k l : Nat) : Nat := k * k + ((l + 1) * (l - 2) / 2 + 2) * k + l * (l - 2)

end OQ64
