module

public import OQ64.L3
public import OQ64.L4
public import OQ64.L5
public import OQ64.L6

/-!
# Upper bounds for Gaiser's S₂(k;ℓ), exact version, ℓ = 3, 4, 5, 6

`ExactSol k l N c` (see `OQ64/Statement.lean`): the colouring `c` has a monochromatic solution of
`x₁ + ⋯ + x_k = x_{k+1}` in `[1, N]` using exactly `l + 1` distinct integers.  `F k l` is Gaiser's
formula `k² + [((ℓ+1)(ℓ−2))/2 + 2]·k + ℓ(ℓ−2)`.

* `S2_3_upper` : every 2-colouring of `[1, F k 3]` has such a solution, for all `k ≥ 3`;
* `S2_4_upper` : likewise for `ℓ = 4`, all `k ≥ 4`;
* `S2_5_upper` : `ℓ = 5`, all `k ≥ 6`;
* `S2_6_upper` : `ℓ = 6`, all `k ≥ 7`.

Together with Gaiser's lower bound `S₂(k;ℓ) ≥ F(k,ℓ)` (arXiv:2608.08789, Theorem 1.1, not formalised
here) these give `S₂(k;ℓ) = F(k,ℓ)` on the stated ranges.
-/

@[expose] public section

namespace OQ64


theorem natv_F (c0 c1 : Nat) (k : Nat) :
    natv [(c0 : Int), (c1 : Int), 1] k = k * k + c1 * k + c0 := by
  unfold natv
  simp only [RSN.peval, Int.mul_zero, Int.add_zero, Int.mul_one]
  have h1 : (0 : Int) ≤ (k : Int) * (k : Int) := Int.mul_nonneg (by omega) (by omega)
  have h2 : ((k * k + c1 * k + c0 : Nat) : Int) = (k : Int) * (k : Int) + (c1 : Int) * (k : Int) + (c0 : Int) := by
    simp [Int.natCast_add, Int.natCast_mul]
  rw [Int.mul_add]
  rw [Int.mul_comm (k : Int) (c1 : Int)]
  omega

theorem S2_3_upper (k : Nat) (hk : 3 ≤ k) (c : Nat → Bool) : ExactSol k 3 (F k 3) c := by
  have h := l3_upper k hk c
  have e : natv l3F k = F k 3 := by
    rw [show l3F = [((3 : Nat) : Int), ((4 : Nat) : Int), 1] from rfl, natv_F]; simp [F]
  rwa [e] at h

theorem S2_4_upper (k : Nat) (hk : 4 ≤ k) (c : Nat → Bool) : ExactSol k 4 (F k 4) c := by
  have h := l4_upper k hk c
  have e : natv l4F k = F k 4 := by
    rw [show l4F = [((8 : Nat) : Int), ((7 : Nat) : Int), 1] from rfl, natv_F]; simp [F]
  rwa [e] at h

theorem S2_5_upper (k : Nat) (hk : 6 ≤ k) (c : Nat → Bool) : ExactSol k 5 (F k 5) c := by
  have h := l5_upper k hk c
  have e : natv l5F k = F k 5 := by
    rw [show l5F = [((15 : Nat) : Int), ((11 : Nat) : Int), 1] from rfl, natv_F]; simp [F]
  rwa [e] at h

theorem S2_6_upper (k : Nat) (hk : 7 ≤ k) (c : Nat → Bool) : ExactSol k 6 (F k 6) c := by
  have h := l6_upper k hk c
  have e : natv l6F k = F k 6 := by
    rw [show l6F = [((24 : Nat) : Int), ((16 : Nat) : Int), 1] from rfl, natv_F]; simp [F]
  rwa [e] at h

end OQ64
