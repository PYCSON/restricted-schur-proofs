module

public import Init

/-!
# Statement for the Gaiser restricted generalized Schur numbers (upper-bound side)

`F k = k³ + 3k² + 2k − 2`. A *weak monochromatic solution* in `[1, N]` is a pair `u ≠ v` with
`w = (k - 1) * u + v ≤ N` and `u, v, w` of one colour. It is a solution of
`x₁ + ⋯ + x_k = x_{k+1}` using exactly three distinct integers (`u` taken `k - 1` times, `v` once).
-/

@[expose] public section

namespace RSN

def F (k : Nat) : Nat := k ^ 3 + 3 * k ^ 2 + 2 * k - 2

def WeakMono (k N : Nat) (c : Nat → Fin 3) : Prop :=
  ∃ u v : Nat, 1 ≤ u ∧ 1 ≤ v ∧ u ≠ v ∧ (k - 1) * u + v ≤ N ∧
    c u = c v ∧ c v = c ((k - 1) * u + v)

end RSN
