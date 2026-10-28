module

public import RSN.Checker

/-!
# Recursor-based versions of the checker functions

Definitions by pattern matching compile to `brecOn`, which the kernel evaluates slowly and with
large memory. These versions use the recursors directly; `*_eq` theorems show each one equals the
specification in `RSN.Checker`, so soundness transfers.
-/

@[expose] public section

namespace RSN

noncomputable def litNegF (l : Nat) : Nat := bif (l % 2).beq 0 then l + 1 else l - 1

noncomputable def memF (x : Nat) (A : List Nat) : Bool := List.rec false (fun a _ ih => x.beq a || ih) A

noncomputable def mapNegF (c : List Nat) : List Nat := List.rec [] (fun l _ ih => litNegF l :: ih) c

noncomputable def reduceF (A : List Nat) (d : List Nat) : List Nat :=
  List.rec [] (fun l _ ih => bif memF (litNegF l) A then ih else l :: ih) d

noncomputable def allEqF (u : Nat) (rest : List Nat) : Bool := List.rec true (fun x _ ih => x.beq u && ih) rest

noncomputable def Trie.findF (t : Trie) : Nat → Option Clause :=
  Trie.rec (motive := fun _ => Nat → Option Clause) (fun _ => none)
    (fun v _ _ fl fr k => bif k.beq 0 then v else bif (k % 2).beq 1 then fl (k / 2) else fr (k / 2 - 1)) t

noncomputable def Trie.insertF (fuel : Nat) : Trie → Nat → Clause → Trie :=
  Nat.rec (motive := fun _ => Trie → Nat → Clause → Trie) (fun t _ _ => t)
    (fun _ ih t k c => bif k.beq 0 then .node (some c) t.left t.right
      else bif (k % 2).beq 1 then .node t.val (ih t.left (k / 2) c) t.right
      else .node t.val t.left (ih t.right (k / 2 - 1) c)) fuel

noncomputable def afterFind (ih : List Lit → Bool) (A : List Lit) : Option Clause → Bool
  | none => false
  | some d =>
    match reduceF A d with
    | [] => true
    | u :: rest => bif allEqF u rest then ih (u :: A) else false

noncomputable def rupLoopF (db : Trie) (hs : List Nat) : List Lit → Bool :=
  List.rec (motive := fun _ => List Lit → Bool) (fun _ => false)
    (fun h _ ih A => afterFind ih A (db.findF h)) hs

noncomputable def rupF (db : Trie) (c : Clause) (hints : List Nat) : Bool := rupLoopF db hints (mapNegF c)

noncomputable def checkSegF (ss : List Step) : Trie → Bool :=
  List.rec (motive := fun _ => Trie → Bool) (fun _ => true)
    (fun s _ ih db => rupF db s.clause s.hints && ih (db.insertF 64 s.id s.clause)) ss

noncomputable def insertStepsF (ss : List Step) : Trie → Trie :=
  List.rec (motive := fun _ => Trie → Trie) (fun db => db)
    (fun s _ ih db => ih (db.insertF 64 s.id s.clause)) ss

noncomputable def buildDBF (cs : List Clause) : Trie → Nat → Trie :=
  List.rec (motive := fun _ => Trie → Nat → Trie) (fun t _ => t)
    (fun c _ ih t i => ih (t.insertF 64 i c) (i + 1)) cs

/-- Segments check (fast version), each against the database after the previous segments. -/
def SegsOKF : Trie → List (List Step) → Prop
  | _, [] => True
  | db, s :: ss => checkSegF s db = true ∧ SegsOKF (insertStepsF s db) ss

/-! ## The fast versions agree with the specification -/

theorem nbeq (a b : Nat) : a.beq b = decide (a = b) := by
  cases h : a.beq b
  · have : ¬ a = b := fun e => by subst e; simp at h
    simp [this]
  · simp at h
    simp [h]

theorem litNegF_eq (l : Nat) : litNegF l = litNeg l := by
  unfold litNegF litNeg
  by_cases h : l % 2 = 0 <;> simp [h, nbeq]

theorem memF_eq (x : Nat) : ∀ A : List Nat, memF x A = A.contains x
  | [] => rfl
  | a :: as => by
    show (x.beq a || memF x as) = (a :: as).contains x
    rw [memF_eq x as, nbeq, List.contains_cons]
    by_cases h : x = a
    · subst h; simp
    · simp [h]

theorem mapNegF_eq : ∀ c : List Nat, mapNegF c = c.map litNeg
  | [] => rfl
  | l :: c => by
    show litNegF l :: mapNegF c = _
    rw [litNegF_eq, mapNegF_eq c]
    rfl

theorem reduceF_eq (A : List Nat) : ∀ d : List Nat, reduceF A d = reduceClause A d
  | [] => rfl
  | l :: d => by
    show (bif memF (litNegF l) A then reduceF A d else l :: reduceF A d) = reduceClause A (l :: d)
    rw [reduceF_eq A d, memF_eq, litNegF_eq]
    unfold reduceClause
    rw [List.filter_cons]
    cases A.contains (litNeg l) <;> rfl

theorem allEqF_eq (u : Nat) : ∀ rest : List Nat, allEqF u rest = rest.all (· == u)
  | [] => rfl
  | x :: rest => by
    show (x.beq u && allEqF u rest) = (x :: rest).all (· == u)
    rw [allEqF_eq u rest, List.all_cons, nbeq]
    by_cases h : x = u
    · subst h; simp
    · simp [h]

theorem findF_eq : ∀ (t : Trie) (k : Nat), t.findF k = t.find k
  | .leaf, _ => rfl
  | .node v l r, k => by
    show (bif k.beq 0 then v else bif (k % 2).beq 1 then l.findF (k / 2) else r.findF (k / 2 - 1)) = _
    rw [findF_eq l, findF_eq r]
    simp only [Trie.find, nbeq]
    by_cases h0 : k = 0
    · simp [h0]
    · by_cases h1 : k % 2 = 1 <;> simp [h0, h1]

theorem insertF_eq : ∀ (fuel : Nat) (t : Trie) (k : Nat) (c : Clause),
    Trie.insertF fuel t k c = Trie.insert fuel t k c
  | 0, _, _, _ => rfl
  | fuel + 1, t, k, c => by
    show (bif k.beq 0 then Trie.node (some c) t.left t.right
      else bif (k % 2).beq 1 then Trie.node t.val (Trie.insertF fuel t.left (k / 2) c) t.right
      else Trie.node t.val t.left (Trie.insertF fuel t.right (k / 2 - 1) c)) = _
    rw [insertF_eq fuel t.left, insertF_eq fuel t.right]
    simp only [Trie.insert, nbeq]
    by_cases h0 : k = 0
    · simp [h0]
    · by_cases h1 : k % 2 = 1 <;> simp [h0, h1]

theorem rupLoopF_eq (db : Trie) : ∀ (hs : List Nat) (A : List Lit), rupLoopF db hs A = rupLoop db A hs
  | [], _ => rfl
  | h :: hs, A => by
    show afterFind (rupLoopF db hs) A (db.findF h) = rupLoop db A (h :: hs)
    rw [findF_eq]
    simp only [rupLoop]
    cases db.find h with
    | none => rfl
    | some d =>
      simp only [afterFind, reduceF_eq]
      cases reduceClause A d with
      | nil => rfl
      | cons u rest =>
        simp only [allEqF_eq, rupLoopF_eq db hs]
        cases rest.all (· == u) <;> rfl

theorem rupF_eq (db : Trie) (c : Clause) (hints : List Nat) : rupF db c hints = rup db c hints := by
  unfold rupF rup
  rw [mapNegF_eq, rupLoopF_eq]

theorem checkSegF_eq : ∀ (ss : List Step) (db : Trie), checkSegF ss db = checkSeg db ss
  | [], _ => rfl
  | s :: ss, db => by
    show (rupF db s.clause s.hints && checkSegF ss (db.insertF 64 s.id s.clause)) = _
    rw [rupF_eq, insertF_eq, checkSegF_eq ss]
    rfl

theorem insertStepsF_eq : ∀ (ss : List Step) (db : Trie), insertStepsF ss db = insertSteps db ss
  | [], _ => rfl
  | s :: ss, db => by
    show insertStepsF ss (db.insertF 64 s.id s.clause) = _
    rw [insertF_eq, insertStepsF_eq ss]
    rfl

theorem buildDBF_eq : ∀ (cs : List Clause) (t : Trie) (i : Nat), buildDBF cs t i = buildDB t i cs
  | [], _, _ => rfl
  | c :: cs, t, i => by
    show buildDBF cs (t.insertF 64 i c) (i + 1) = _
    rw [insertF_eq, buildDBF_eq cs]
    rfl

theorem segsOKF_iff : ∀ (segs : List (List Step)) (db : Trie), SegsOKF db segs → SegsOK db segs
  | [], _, _ => trivial
  | s :: ss, db, h => by
    simp only [SegsOKF] at h
    simp only [SegsOK]
    rw [checkSegF_eq, insertStepsF_eq] at h
    exact ⟨h.1, segsOKF_iff ss _ h.2⟩

end RSN
