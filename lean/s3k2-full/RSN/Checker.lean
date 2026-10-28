module

public import Init

/-!
# A small kernel-reducible RUP/LRAT checker with a soundness proof

Designed so that `decide +kernel` can run it: only structural recursion, `Nat` arithmetic on
literals (GMP-accelerated in the kernel), and lists. No `native_decide`, no `ofReduceBool`.

Literals are coded as `2 * var + s` (`s = 0`: positive, `s = 1`: negative).
-/

@[expose] public section

namespace RSN

abbrev Lit := Nat
abbrev Clause := List Lit

def litEval (v : Nat → Bool) (l : Lit) : Bool :=
  if l % 2 = 0 then v (l / 2) else !(v (l / 2))

def clauseEval (v : Nat → Bool) (c : Clause) : Bool := c.any (litEval v)

def litNeg (l : Lit) : Lit := if l % 2 = 0 then l + 1 else l - 1

theorem litEval_neg (v : Nat → Bool) (l : Nat) : litEval v (litNeg l) = !litEval v l := by
  unfold litEval litNeg
  by_cases h : l % 2 = 0
  · have h1 : ¬ (l + 1) % 2 = 0 := by omega
    have h2 : (l + 1) / 2 = l / 2 := by omega
    simp [h, h1, h2]
  · have h1 : (l - 1) % 2 = 0 := by omega
    have h2 : (l - 1) / 2 = l / 2 := by omega
    simp [h, h1, h2]

/-! ## Clause database: a binary trie keyed by clause id -/

inductive Trie where
  | leaf
  | node (v : Option Clause) (l r : Trie)

def Trie.val : Trie → Option Clause
  | .leaf => none
  | .node v _ _ => v

def Trie.left : Trie → Trie
  | .leaf => .leaf
  | .node _ l _ => l

def Trie.right : Trie → Trie
  | .leaf => .leaf
  | .node _ _ r => r

def Trie.find : Trie → Nat → Option Clause
  | .leaf, _ => none
  | .node v l r, k =>
    if k = 0 then v else if k % 2 = 1 then Trie.find l (k / 2) else Trie.find r (k / 2 - 1)

def Trie.insert : Nat → Trie → Nat → Clause → Trie
  | 0, t, _, _ => t
  | fuel + 1, t, k, c =>
    if k = 0 then .node (some c) t.left t.right
    else if k % 2 = 1 then .node t.val (Trie.insert fuel t.left (k / 2) c) t.right
    else .node t.val t.left (Trie.insert fuel t.right (k / 2 - 1) c)

/-- Every clause stored in the trie satisfies `P`. -/
def Trie.All (P : Clause → Prop) : Trie → Prop
  | .leaf => True
  | .node v l r => (∀ c, v = some c → P c) ∧ Trie.All P l ∧ Trie.All P r

theorem Trie.find_all {P : Clause → Prop} :
    ∀ (t : Trie) (k : Nat) (c : Clause), t.All P → t.find k = some c → P c
  | .leaf, _, _, _, h => by simp [Trie.find] at h
  | .node v l r, k, c, hall, h => by
    simp only [Trie.All] at hall
    obtain ⟨hv, hl, hr⟩ := hall
    simp only [Trie.find] at h
    split at h
    · exact hv c h
    · split at h
      · exact Trie.find_all l _ c hl h
      · exact Trie.find_all r _ c hr h

theorem Trie.parts_all {P : Clause → Prop} (t : Trie) (ht : t.All P) :
    (∀ c, t.val = some c → P c) ∧ t.left.All P ∧ t.right.All P := by
  cases t with
  | leaf => simp [Trie.val, Trie.left, Trie.right, Trie.All]
  | node v l r =>
    simp only [Trie.All] at ht
    exact ht

theorem Trie.insert_all {P : Clause → Prop} :
    ∀ (fuel : Nat) (t : Trie) (k : Nat) (c : Clause), t.All P → P c → (Trie.insert fuel t k c).All P
  | 0, t, _, _, ht, _ => by simpa [Trie.insert] using ht
  | fuel + 1, t, k, c, ht, hc => by
    obtain ⟨hv, hl, hr⟩ := Trie.parts_all t ht
    simp only [Trie.insert]
    split
    · simp only [Trie.All]
      refine ⟨?_, hl, hr⟩
      intro c' h
      injection h with h
      subst h
      exact hc
    · split
      · simp only [Trie.All]
        exact ⟨hv, Trie.insert_all fuel _ _ _ hl hc, hr⟩
      · simp only [Trie.All]
        exact ⟨hv, hl, Trie.insert_all fuel _ _ _ hr hc⟩

/-! ## Reverse unit propagation -/

/-- The literals of `d` that are not falsified by the partial assignment `A`
(a list of literals assumed true). -/
def reduceClause (A : List Lit) (d : Clause) : Clause :=
  d.filter (fun l => !(A.contains (litNeg l)))

def rupLoop (db : Trie) : List Lit → List Nat → Bool
  | _, [] => false
  | A, h :: hs =>
    match db.find h with
    | none => false
    | some d =>
      match reduceClause A d with
      | [] => true
      | u :: rest => if rest.all (· == u) then rupLoop db (u :: A) hs else false

/-- `rup db c hints`: the clause `c` follows from the clauses `hints` of `db` by unit propagation. -/
def rup (db : Trie) (c : Clause) (hints : List Nat) : Bool :=
  rupLoop db (c.map litNeg) hints

theorem mem_reduce_of_true (v : Nat → Bool) (A : List Lit) (hA : ∀ l ∈ A, litEval v l = true)
    (d : Clause) (l : Lit) (hl : l ∈ d) (hv : litEval v l = true) : l ∈ reduceClause A d := by
  unfold reduceClause
  rw [List.mem_filter]
  refine ⟨hl, ?_⟩
  cases hc : A.contains (litNeg l)
  · rfl
  · exfalso
    have hmem : litNeg l ∈ A := by simpa using hc
    have := hA _ hmem
    rw [litEval_neg, hv] at this
    simp at this

theorem rupLoop_sound (v : Nat → Bool) (db : Trie) (hdb : db.All (fun d => clauseEval v d = true)) :
    ∀ (hs : List Nat) (A : List Lit), (∀ l ∈ A, litEval v l = true) → rupLoop db A hs = true → False
  | [], A, _, h => by simp [rupLoop] at h
  | h0 :: hs, A, hA, h => by
    simp only [rupLoop] at h
    split at h
    · simp at h
    · rename_i d hd
      have hdv : clauseEval v d = true := Trie.find_all db h0 d hdb hd
      unfold clauseEval at hdv
      obtain ⟨l, hl, hlv⟩ := List.any_eq_true.1 hdv
      have hlr := mem_reduce_of_true v A hA d l hl hlv
      split at h
      · rename_i hr
        rw [hr] at hlr
        simp at hlr
      · rename_i u rest hr
        split at h
        · rename_i hall
          apply rupLoop_sound v db hdb hs (u :: A) _ h
          intro l' hl'
          rcases List.mem_cons.1 hl' with rfl | hl'
          · rw [hr] at hlr
            rcases List.mem_cons.1 hlr with rfl | hlr
            · exact hlv
            · have := List.all_eq_true.1 hall l hlr
              simp at this
              subst this
              exact hlv
          · exact hA l' hl'
        · simp at h

theorem rup_sound (v : Nat → Bool) (db : Trie) (hdb : db.All (fun d => clauseEval v d = true))
    (c : Clause) (hints : List Nat) (h : rup db c hints = true) : clauseEval v c = true := by
  cases hc : clauseEval v c
  · exfalso
    apply rupLoop_sound v db hdb hints (c.map litNeg) _ h
    intro l hl
    obtain ⟨l0, hl0, rfl⟩ := List.mem_map.1 hl
    rw [litEval_neg]
    have : litEval v l0 = false := by
      cases h' : litEval v l0
      · rfl
      · have : clauseEval v c = true := List.any_eq_true.2 ⟨l0, hl0, h'⟩
        rw [hc] at this
        contradiction
    simp [this]
  · rfl

/-! ## Proof steps -/

structure Step where
  id : Nat
  clause : Clause
  hints : List Nat

def checkSteps : Trie → List Step → Bool
  | _, [] => false
  | db, s :: ss =>
    if rup db s.clause s.hints then
      (if s.clause.isEmpty then true else checkSteps (db.insert 64 s.id s.clause) ss)
    else false

theorem checkSteps_sound (v : Nat → Bool) :
    ∀ (ss : List Step) (db : Trie), db.All (fun d => clauseEval v d = true) → checkSteps db ss = true → False
  | [], _, _, h => by simp [checkSteps] at h
  | s :: ss, db, hdb, h => by
    simp only [checkSteps] at h
    split at h
    · rename_i hr
      have hc := rup_sound v db hdb s.clause s.hints hr
      split at h
      · rename_i he
        have : s.clause = [] := List.isEmpty_iff.1 he
        rw [this] at hc
        simp [clauseEval] at hc
      · exact checkSteps_sound v ss _ (Trie.insert_all 64 db s.id s.clause hdb hc) h
    · simp at h

def buildDB : Trie → Nat → List Clause → Trie
  | t, _, [] => t
  | t, i, c :: cs => buildDB (t.insert 64 i c) (i + 1) cs

theorem buildDB_all {P : Clause → Prop} :
    ∀ (cs : List Clause) (t : Trie) (i : Nat), t.All P → (∀ c ∈ cs, P c) → (buildDB t i cs).All P
  | [], t, _, ht, _ => by simpa [buildDB] using ht
  | c :: cs, t, i, ht, hcs => by
    simp only [buildDB]
    exact buildDB_all cs _ _ (Trie.insert_all 64 t i c ht (hcs c (by simp)))
      (fun c' hc' => hcs c' (by simp [hc']))

/-- The checker: original clauses get ids `1, 2, …` in order. -/
def checkCNF (cnf : List Clause) (proof : List Step) : Bool :=
  checkSteps (buildDB .leaf 1 cnf) proof

/-- **Soundness.** If the checker accepts, every assignment falsifies some clause of `cnf`. -/
theorem checkCNF_sound (cnf : List Clause) (proof : List Step) (h : checkCNF cnf proof = true)
    (v : Nat → Bool) : ∃ c ∈ cnf, clauseEval v c = false := by
  apply Decidable.byContradiction
  intro hno
  have hall : ∀ c ∈ cnf, clauseEval v c = true := by
    intro c hc
    cases h' : clauseEval v c
    · exact absurd ⟨c, hc, h'⟩ hno
    · rfl
  exact checkSteps_sound v proof _ (buildDB_all cnf .leaf 1 (by simp [Trie.All]) hall) h

/-! ## Segment-wise checking

The kernel keeps its reduction caches for a whole declaration, so one huge `decide` runs out of
memory. Instead the proof is cut into segments; each segment is checked by its own theorem
against the database obtained by *inserting* (not re-checking) all earlier steps. -/

def insertSteps : Trie → List Step → Trie
  | db, [] => db
  | db, s :: ss => insertSteps (db.insert 64 s.id s.clause) ss

def checkSeg : Trie → List Step → Bool
  | _, [] => true
  | db, s :: ss => rup db s.clause s.hints && checkSeg (db.insert 64 s.id s.clause) ss

theorem checkSeg_sound (v : Nat → Bool) :
    ∀ (ss : List Step) (db : Trie), db.All (fun d => clauseEval v d = true) → checkSeg db ss = true →
      (insertSteps db ss).All (fun d => clauseEval v d = true) ∧ ∀ s ∈ ss, clauseEval v s.clause = true
  | [], db, hdb, _ => by simpa [insertSteps] using hdb
  | s :: ss, db, hdb, h => by
    simp only [checkSeg, Bool.and_eq_true] at h
    have hc := rup_sound v db hdb s.clause s.hints h.1
    have ih := checkSeg_sound v ss _ (Trie.insert_all 64 db s.id s.clause hdb hc) h.2
    refine ⟨by simpa [insertSteps] using ih.1, ?_⟩
    intro s' hs'
    rcases List.mem_cons.1 hs' with rfl | hs'
    · exact hc
    · exact ih.2 s' hs'

/-- All segments check, each against the database after the previous segments. -/
def SegsOK : Trie → List (List Step) → Prop
  | _, [] => True
  | db, s :: ss => checkSeg db s = true ∧ SegsOK (insertSteps db s) ss

theorem segsOK_sound (v : Nat → Bool) :
    ∀ (segs : List (List Step)) (db : Trie), db.All (fun d => clauseEval v d = true) → SegsOK db segs →
      ∀ s ∈ segs.flatten, clauseEval v s.clause = true
  | [], _, _, _ => by simp
  | seg :: segs, db, hdb, h => by
    simp only [SegsOK] at h
    have h1 := checkSeg_sound v seg db hdb h.1
    have h2 := segsOK_sound v segs _ h1.1 h.2
    intro s hs
    rw [List.flatten_cons, List.mem_append] at hs
    rcases hs with hs | hs
    · exact h1.2 s hs
    · exact h2 s hs

/-- **Soundness (segmented).** If all segments check and some checked step is the empty clause,
every assignment falsifies some clause of `cnf`. -/
theorem unsat_of_segs (cnf : List Clause) (segs : List (List Step))
    (h : SegsOK (buildDB .leaf 1 cnf) segs) (hempty : segs.flatten.any (fun s => s.clause.isEmpty) = true)
    (v : Nat → Bool) : ∃ c ∈ cnf, clauseEval v c = false := by
  apply Decidable.byContradiction
  intro hno
  have hall : ∀ c ∈ cnf, clauseEval v c = true := by
    intro c hc
    cases h' : clauseEval v c
    · exact absurd ⟨c, hc, h'⟩ hno
    · rfl
  have hs := segsOK_sound v segs _ (buildDB_all cnf .leaf 1 (by simp [Trie.All]) hall) h
  obtain ⟨s, hs1, hs2⟩ := List.any_eq_true.1 hempty
  have := hs s hs1
  rw [List.isEmpty_iff.1 hs2] at this
  simp [clauseEval] at this

end RSN
