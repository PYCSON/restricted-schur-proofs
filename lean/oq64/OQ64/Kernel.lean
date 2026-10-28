module

public import OQ64.Bridge
public import RSN.Poly
public import RSN.Checker
public import RSN.Fast

/-!
# Symbolic kernels: generic soundness

A kernel is a list `V` of integer polynomials in `k` (coefficient lists, `RSN.peval`) and a list of
edges `w = (k - c)·a + Σ mᵢ·oᵢ`.  `edgeOK` checks, by computation, that an edge is a genuine exact
solution for **every** integer `k ≥ k0`:
* `l - 1` others with multiplicities `mᵢ ≥ 1`, `Σ mᵢ = c`, `c + 1 ≤ k0` (so `k - c ≥ 1`);
* the polynomial identity holds coefficient-wise;
* all summand polynomials are positive and pairwise different on `k ≥ k0`, and `w ≤ F`
  (`posCheck`: explicit values for `k0 ≤ k < k1`, nonnegative Taylor coefficients at `k1`).
If the 2-colouring CNF of the kernel (`kernelCNF`) is unsatisfiable, then for every `k ≥ k0` every
colouring has an `ExactSol` in `[1, F(k)]` (`kernel_upper`).
-/

@[expose] public section

namespace OQ64
open RSN

/-! ## Taylor shift and a positivity certificate -/

def pshift : List Int → Int → List Int
  | [], _ => []
  | c :: cs, s => padd [c] (pmulLin s 1 (pshift cs s))

theorem peval_pshift : ∀ (p : List Int) (s t : Int), peval (pshift p s) t = peval p (s + t)
  | [], s, t => by simp [pshift, peval]
  | c :: cs, s, t => by
    simp only [pshift, peval_padd, peval_pmulLin, peval_pshift cs s t, peval, Int.one_mul, Int.mul_zero,
      Int.add_zero]

def headPos : List Int → Bool
  | [] => false
  | c :: cs => decide (0 < c) && allNonneg cs

theorem headPos_sound : ∀ (p : List Int) (t : Int), 0 ≤ t → headPos p = true → 0 < peval p t
  | [], _, _, h => by simp [headPos] at h
  | c :: cs, t, ht, h => by
    simp only [headPos, Bool.and_eq_true, decide_eq_true_eq] at h
    have h2 := peval_allNonneg cs t ht h.2
    simp only [peval]
    have := Int.mul_nonneg ht h2
    omega

/-- `p(k) > 0` for every natural `k ≥ k0`. -/
def posCheck (k0 k1 : Nat) (p : List Int) : Bool :=
  headPos (pshift p (k1 : Int)) && (List.range (k1 - k0)).all (fun i => decide (0 < peval p ((k0 + i : Nat) : Int)))

theorem posCheck_sound (k0 k1 : Nat) (p : List Int) (h : posCheck k0 k1 p = true) (k : Nat) (hk : k0 ≤ k) :
    0 < peval p (k : Int) := by
  simp only [posCheck, Bool.and_eq_true, List.all_eq_true, List.mem_range, decide_eq_true_eq] at h
  rcases Nat.lt_or_ge k k1 with hlt | hge
  · have := h.2 (k - k0) (by omega)
    have e : k0 + (k - k0) = k := by omega
    rw [e] at this; exact this
  · have hp := headPos_sound _ ((k : Int) - k1) (by omega) h.1
    rw [peval_pshift] at hp
    have e : (k1 : Int) + ((k : Int) - k1) = k := by omega
    rw [e] at hp; exact hp

def psub (p q : List Int) : List Int := padd p (pscale (-1) q)

theorem peval_psub (p q : List Int) (m : Int) : peval (psub p q) m = peval p m - peval q m := by
  simp only [psub, peval_padd, peval_pscale]; omega

def distinctCheck (k0 k1 : Nat) (p q : List Int) : Bool :=
  posCheck k0 k1 (psub p q) || posCheck k0 k1 (psub q p)

def pairOK (k0 k1 : Nat) : List (List Int) → Bool
  | [] => true
  | p :: ps => ps.all (distinctCheck k0 k1 p) && pairOK k0 k1 ps

/-! ## Edges -/

structure Edge where
  a : Nat
  c : Nat
  oth : List (Nat × Nat)
  w : Nat

def vtx (V : List (List Int)) (i : Nat) : List Int := V.getD i []

def natv (p : List Int) (k : Nat) : Nat := (peval p (k : Int)).toNat

def sumPolys (V : List (List Int)) : List (Nat × Nat) → List Int
  | [] => []
  | p :: os => padd (pscale (p.1 : Int) (vtx V p.2)) (sumPolys V os)

theorem peval_sumPolys (V : List (List Int)) (m : Int) :
    ∀ os : List (Nat × Nat), peval (sumPolys V os) m = (os.map (fun p => (p.1 : Int) * peval (vtx V p.2) m)).sum
  | [] => by simp [sumPolys, peval]
  | p :: os => by
    simp only [sumPolys, peval_padd, peval_pscale, peval_sumPolys V m os, List.map_cons, List.sum_cons]

/-- `(k - c)·a + Σ mᵢ·oᵢ - w` as a polynomial in `k`. -/
def combPoly (V : List (List Int)) (e : Edge) : List Int :=
  padd (pmulLin (-(e.c : Int)) 1 (vtx V e.a)) (padd (sumPolys V e.oth) (pscale (-1) (vtx V e.w)))

def edgeOK (l k0 k1 : Nat) (V : List (List Int)) (Fp : List Int) (e : Edge) : Bool :=
  decide (e.oth.length + 1 = l) && !e.oth.isEmpty && e.oth.all (fun p => decide (1 ≤ p.1)) &&
  decide ((e.oth.map Prod.fst).sum = e.c) && decide (e.c + 1 ≤ k0) &&
  allZero (combPoly V e) &&
  posCheck k0 k1 (vtx V e.a) && e.oth.all (fun p => posCheck k0 k1 (vtx V p.2)) &&
  posCheck k0 k1 (padd (psub Fp (vtx V e.w)) [1]) &&
  pairOK k0 k1 (vtx V e.a :: e.oth.map (fun p => vtx V p.2))

theorem natv_cast (p : List Int) (k : Nat) (h : 0 < peval p (k : Int)) : ((natv p k : Nat) : Int) = peval p (k : Int) := by
  unfold natv; exact Int.toNat_of_nonneg (by omega)

theorem pairOK_nodup (k0 k1 k : Nat) (hk : k0 ≤ k) :
    ∀ ps : List (List Int), (∀ p ∈ ps, 0 < peval p (k : Int)) → pairOK k0 k1 ps = true →
      (ps.map (fun p => natv p k)).Nodup
  | [], _, _ => by simp
  | p :: ps, hpos, h => by
    simp only [pairOK, Bool.and_eq_true, List.all_eq_true] at h
    rw [List.map_cons, List.nodup_cons]
    refine ⟨?_, pairOK_nodup k0 k1 k hk ps (fun q hq => hpos q (List.mem_cons_of_mem _ hq)) h.2⟩
    intro hm
    obtain ⟨q, hq, hqe⟩ := List.mem_map.1 hm
    have hd := h.1 q hq
    have hp0 := hpos p List.mem_cons_self
    have hq0 := hpos q (List.mem_cons_of_mem _ hq)
    simp only [distinctCheck, Bool.or_eq_true] at hd
    unfold natv at hqe
    rcases hd with hd | hd
    · have := posCheck_sound _ _ _ hd k hk; rw [peval_psub] at this; omega
    · have := posCheck_sound _ _ _ hd k hk; rw [peval_psub] at this; omega

theorem cast_sum_natv (V : List (List Int)) (k : Nat) :
    ∀ L : List (Nat × Nat), (∀ p ∈ L, 0 < peval (vtx V p.2) (k : Int)) →
      (((L.map (fun p => p.1 * natv (vtx V p.2) k)).sum : Nat) : Int) =
        (L.map (fun p => (p.1 : Int) * peval (vtx V p.2) (k : Int))).sum
  | [], _ => by simp
  | p :: L, h => by
    simp only [List.map_cons, List.sum_cons, Int.natCast_add, Int.natCast_mul]
    rw [natv_cast _ _ (h p List.mem_cons_self), cast_sum_natv V k L (fun q hq => h q (List.mem_cons_of_mem _ hq))]

/-- One checked edge whose vertices are monochromatic gives an exact solution. -/
theorem edge_sound (l k0 k1 : Nat) (V : List (List Int)) (Fp : List Int) (e : Edge)
    (he : edgeOK l k0 k1 V Fp e = true) (k : Nat) (hk : k0 ≤ k) (c : Nat → Bool)
    (hcol : ∀ x ∈ e.a :: e.oth.map Prod.snd, c (natv (vtx V x) k) = c (natv (vtx V e.w) k)) :
    ExactSol k l (natv Fp k) c := by
  simp only [edgeOK, Bool.and_eq_true, decide_eq_true_eq, Bool.not_eq_true', List.isEmpty_eq_false_iff,
    List.all_eq_true] at he
  obtain ⟨⟨⟨⟨⟨⟨⟨⟨⟨hl, hne⟩, hm1⟩, hsum⟩, hc⟩, hid⟩, hpa⟩, hpo⟩, hwF⟩, hpair⟩ := he
  have hne' : e.oth ≠ [] := by intro h; simp [h] at hne
  have pa := posCheck_sound _ _ _ hpa k hk
  have po : ∀ p ∈ e.oth, 0 < peval (vtx V p.2) (k : Int) := fun p hp => posCheck_sound _ _ _ (hpo p hp) k hk
  have pF := posCheck_sound _ _ _ hwF k hk
  simp only [peval_padd, peval_psub, peval] at pF
  have hz := peval_allZero _ (k : Int) hid
  simp only [combPoly, peval_padd, peval_pmulLin, peval_sumPolys, peval_pscale] at hz
  have hS := cast_sum_natv V k e.oth po
  have hSpos : 0 ≤ (e.oth.map (fun p => (p.1 : Int) * peval (vtx V p.2) (k : Int))).sum := by
    rw [← hS]; omega
  have hk1 : 1 ≤ k - e.c := by omega
  have pw : 0 < peval (vtx V e.w) (k : Int) := by
    have : 0 < (-(e.c : Int) + 1 * (k : Int)) * peval (vtx V e.a) (k : Int) :=
      Int.mul_pos (by omega) pa
    omega
  have hwN : natv (vtx V e.w) k ≤ natv Fp k := by
    unfold natv; omega
  have hos1 : (e.oth.map (fun p => (p.1, natv (vtx V p.2) k))).map Prod.fst = e.oth.map Prod.fst := by
    simp only [List.map_map]; rfl
  have hos2 : (e.oth.map (fun p => (p.1, natv (vtx V p.2) k))).map (fun p => p.1 * p.2) =
      e.oth.map (fun p => p.1 * natv (vtx V p.2) k) := by
    simp only [List.map_map]; rfl
  have hos3 : (e.oth.map (fun p => (p.1, natv (vtx V p.2) k))).map Prod.snd =
      (e.oth.map (fun p => vtx V p.2)).map (fun p => natv p k) := by
    simp only [List.map_map]; rfl
  have hnod := pairOK_nodup k0 k1 k hk _ (by
      intro p hp
      simp only [List.mem_cons, List.mem_map] at hp
      rcases hp with rfl | ⟨q, hq, rfl⟩
      · exact pa
      · exact po q hq) hpair
  simp only [List.map_cons] at hnod
  refine exactSol_of_parts k l (natv Fp k) c (natv (vtx V e.a) k) (k - e.c)
    (e.oth.map (fun p => (p.1, natv (vtx V p.2) k))) (natv (vtx V e.w) k)
    ?_ ?_ hk1 ?_ ?_ ?_ ?_ ?_ ?_ hwN ?_
  · simp only [List.length_map]; omega
  · intro h; exact hne' (List.map_eq_nil_iff.1 h)
  · intro p hp; simp only [List.mem_map] at hp; obtain ⟨q, hq, rfl⟩ := hp; exact hm1 q hq
  · rw [hos1, hsum]; omega
  · unfold natv; omega
  · intro p hp; simp only [List.mem_map] at hp; obtain ⟨q, hq, rfl⟩ := hp
    have := po q hq; unfold natv; simp only; omega
  · rw [hos3]; exact hnod
  · rw [hos2]
    have key : (((k - e.c) * natv (vtx V e.a) k + (e.oth.map (fun p => p.1 * natv (vtx V p.2) k)).sum : Nat) : Int)
        = ((natv (vtx V e.w) k : Nat) : Int) := by
      rw [Int.natCast_add, Int.natCast_mul, hS, natv_cast _ _ pw, natv_cast _ _ pa]
      have e1 : ((k - e.c : Nat) : Int) = (k : Int) - (e.c : Int) := by omega
      rw [e1]
      have e2 : ((k : Int) - (e.c : Int)) * peval (vtx V e.a) (k : Int) =
          (-(e.c : Int) + 1 * (k : Int)) * peval (vtx V e.a) (k : Int) := by
        congr 1; omega
      rw [e2]; omega
    exact_mod_cast key.symm
  · intro y hy
    rw [hos3] at hy
    simp only [List.mem_cons, List.mem_map] at hy
    rcases hy with rfl | ⟨q, ⟨r, hr, rfl⟩, rfl⟩
    · exact hcol _ List.mem_cons_self
    · exact hcol _ (List.mem_cons_of_mem _ (List.mem_map.2 ⟨r, hr, rfl⟩))

/-! ## The CNF of a kernel and the main soundness theorem -/

def edgeVerts (e : Edge) : List Nat := e.a :: (e.oth.map Prod.snd ++ [e.w])

def litsNeg (vs : List Nat) : Clause := vs.map (fun x => 2 * (x + 1) + 1)
def litsPos (vs : List Nat) : Clause := vs.map (fun x => 2 * (x + 1))

/-- Clause order = DIMACS order of `cert_<l>_<k0>.cnf`: the unit clause, then for each edge
"not all red" and "not all blue".  Variable `x + 1` means "vertex `x` is red". -/
def kernelCNF (u : Nat) (E : List Edge) : List Clause :=
  [2 * (u + 1)] :: E.flatMap (fun e => [litsNeg (edgeVerts e), litsPos (edgeVerts e)])

theorem clause_neg_false (v : Nat → Bool) (vs : List Nat) (h : clauseEval v (litsNeg vs) = false) :
    ∀ x ∈ vs, v (x + 1) = true := by
  intro x hx
  simp only [clauseEval, litsNeg, List.any_map, List.any_eq_false] at h
  have := h x hx
  simp only [Function.comp, litEval] at this
  have h1 : ¬ (2 * (x + 1) + 1) % 2 = 0 := by omega
  have h2 : (2 * (x + 1) + 1) / 2 = x + 1 := by omega
  simp only [h1, h2, ite_false] at this
  simpa using this

theorem clause_pos_false (v : Nat → Bool) (vs : List Nat) (h : clauseEval v (litsPos vs) = false) :
    ∀ x ∈ vs, v (x + 1) = false := by
  intro x hx
  simp only [clauseEval, litsPos, List.any_map, List.any_eq_false] at h
  have := h x hx
  simp only [Function.comp, litEval] at this
  have h1 : (2 * (x + 1)) % 2 = 0 := by omega
  have h2 : (2 * (x + 1)) / 2 = x + 1 := by omega
  simp only [h1, h2, ite_true] at this
  simpa using this

theorem kernel_upper_red (l k0 k1 : Nat) (V : List (List Int)) (E : List Edge) (Fp : List Int) (u : Nat)
    (hu : vtx V u = [1, 0, 0]) (hE : E.all (edgeOK l k0 k1 V Fp) = true)
    (hunsat : ∀ v : Nat → Bool, ∃ cl ∈ kernelCNF u E, clauseEval v cl = false)
    (k : Nat) (hk : k0 ≤ k) (c : Nat → Bool) (h1 : c 1 = true) : ExactSol k l (natv Fp k) c := by
  apply Classical.byContradiction
  intro hno
  let v : Nat → Bool := fun j => c (natv (vtx V (j - 1)) k)
  obtain ⟨cl, hcl, hf⟩ := hunsat v
  simp only [kernelCNF, List.mem_cons, List.mem_flatMap] at hcl
  rcases hcl with rfl | ⟨e, heE, hcl⟩
  · simp only [clauseEval, List.any_cons, List.any_nil, Bool.or_false, litEval] at hf
    have h0 : (2 * (u + 1)) % 2 = 0 := by omega
    have h2 : (2 * (u + 1)) / 2 = u + 1 := by omega
    simp only [h0, h2, ite_true, v, Nat.add_sub_cancel, hu] at hf
    have : natv [1, 0, 0] k = 1 := by simp [natv, peval]
    rw [this, h1] at hf; exact absurd hf (by decide)
  · have heok := List.all_eq_true.1 hE e heE
    simp only [List.mem_cons, List.mem_singleton, List.not_mem_nil, or_false] at hcl
    have hmono : ∀ x ∈ edgeVerts e, v (x + 1) = v (e.w + 1) := by
      rcases hcl with rfl | rfl
      · have hh := clause_neg_false v _ hf
        intro x hx; rw [hh x hx, hh e.w (by simp [edgeVerts])]
      · have hh := clause_pos_false v _ hf
        intro x hx; rw [hh x hx, hh e.w (by simp [edgeVerts])]
    apply hno
    apply edge_sound l k0 k1 V Fp e heok k hk c
    intro x hx
    have := hmono x (by
      simp only [edgeVerts, List.mem_cons, List.mem_append, List.mem_singleton] at hx ⊢
      rcases hx with h | h
      · exact Or.inl h
      · exact Or.inr (Or.inl h))
    simpa [v] using this

/-- **Generic upper bound from a kernel.** -/
theorem kernel_upper (l k0 k1 : Nat) (V : List (List Int)) (E : List Edge) (Fp : List Int) (u : Nat)
    (hu : vtx V u = [1, 0, 0]) (hE : E.all (edgeOK l k0 k1 V Fp) = true)
    (hunsat : ∀ v : Nat → Bool, ∃ cl ∈ kernelCNF u E, clauseEval v cl = false)
    (k : Nat) (hk : k0 ≤ k) (c : Nat → Bool) : ExactSol k l (natv Fp k) c := by
  cases h1 : c 1
  · -- swap the colours
    have := kernel_upper_red l k0 k1 V E Fp u hu hE hunsat k hk (fun x => !c x) (by simp [h1])
    obtain ⟨x, vals, h1', h2, h3, h4, h5, h6, h7⟩ := this
    refine ⟨x, vals, h1', h2, h3, h4, h5, h6, ?_⟩
    intro i hi
    have := h7 i hi
    cases hc1 : c (x i) <;> cases hc2 : c (x k) <;> simp_all
  · exact kernel_upper_red l k0 k1 V E Fp u hu hE hunsat k hk c h1

/-! ## Building the clause database in stages -/

theorem buildDB_append : ∀ (A B : List Clause) (t : Trie) (i : Nat),
    buildDB t i (A ++ B) = buildDB (buildDB t i A) (i + A.length) B
  | [], B, t, i => by simp [buildDB]
  | c :: A, B, t, i => by
    simp only [List.cons_append, buildDB, List.length_cons]
    rw [buildDB_append A B _ (i + 1)]
    congr 1; omega

theorem kernelCNF_append (u : Nat) (E1 E2 : List Edge) :
    kernelCNF u (E1 ++ E2) = [2 * (u + 1)] ::
      (E1.flatMap (fun e => [litsNeg (edgeVerts e), litsPos (edgeVerts e)]) ++
       E2.flatMap (fun e => [litsNeg (edgeVerts e), litsPos (edgeVerts e)])) := by
  simp [kernelCNF, List.flatMap_append]


def buildChunks : Trie → Nat → List (List Clause) → Trie
  | t, _, [] => t
  | t, i, A :: As => buildChunks (buildDB t i A) (i + A.length) As

theorem buildChunks_eq : ∀ (As : List (List Clause)) (t : Trie) (i : Nat),
    buildChunks t i As = buildDB t i As.flatten
  | [], t, i => by simp [buildChunks, buildDB]
  | A :: As, t, i => by
    simp only [buildChunks, List.flatten_cons]
    rw [buildChunks_eq As, buildDB_append]

/-- Fast (recursor-based) staged database construction. -/
noncomputable def buildChunksF (As : List (List Clause)) : Trie → Nat → Trie :=
  List.rec (motive := fun _ => Trie → Nat → Trie) (fun t _ => t)
    (fun A _ ih t i => ih (buildDBF A t i) (i + A.length)) As

theorem buildChunksF_eq : ∀ (As : List (List Clause)) (t : Trie) (i : Nat),
    buildChunksF As t i = buildChunks t i As
  | [], _, _ => rfl
  | A :: As, t, i => by
    show buildChunksF As (buildDBF A t i) (i + A.length) = _
    rw [buildChunksF_eq As, buildDBF_eq]
    rfl

def edgeClauses (E : List Edge) : List Clause :=
  E.flatMap (fun e => [litsNeg (edgeVerts e), litsPos (edgeVerts e)])

theorem kernelCNF_chunks (u : Nat) (Es : List (List Edge)) (Cs : List (List Clause))
    (h : Es.map edgeClauses = Cs) :
    kernelCNF u Es.flatten = ([[2 * (u + 1)]] :: Cs).flatten := by
  subst h
  simp only [kernelCNF, List.flatten_cons, List.singleton_append]
  congr 1
  induction Es with
  | nil => simp
  | cons E Es ih => simp [List.flatMap_append, ih, edgeClauses]

end OQ64
