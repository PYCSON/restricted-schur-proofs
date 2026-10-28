module

public import RSN.Checker

/-!
# The CNF of one symbolic-kernel case, built from its data

Clause order equals the DIMACS files produced by `kcert.py`: at-least-one-colour clauses for each
vertex, then for each edge the three forbidden-colour clauses (colours 0, 1, 2), then the red unit
clauses, then the blue unit clauses.
-/

@[expose] public section

namespace RSN

/-- DIMACS variable for "vertex `i` (1-based) has colour `col`". -/
def var (i col : Nat) : Nat := 3 * (i - 1) + col + 1

def aloClauses (n : Nat) : List Clause :=
  (List.range n).map (fun j => [2 * var (j + 1) 0, 2 * var (j + 1) 1, 2 * var (j + 1) 2])

def forbidOne (t : Nat × Nat × Nat) (col : Nat) : Clause :=
  [2 * var t.1 col + 1, 2 * var t.2.1 col + 1, 2 * var t.2.2 col + 1]

def forbidClauses (es : List (Nat × Nat × Nat)) : List Clause :=
  es.flatMap (fun t => [0, 1, 2].map (forbidOne t))

def unitClauses (reds blues : List Nat) : List Clause :=
  reds.map (fun i => [2 * var i 0]) ++ blues.map (fun i => [2 * var i 1])

def caseCNF (n : Nat) (es : List (Nat × Nat × Nat)) (reds blues : List Nat) : List Clause :=
  aloClauses n ++ forbidClauses es ++ unitClauses reds blues

end RSN
