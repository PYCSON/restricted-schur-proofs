> **Release note.** This is the working note behind §8 of preprint v1.2. Paths in it refer to the private research repository. The release scripts are in `scripts/`, the logs in `logs/`, and the reviews in `independent_review_gpt/` and `independent_review_claude_subagent/`.

# K(ℓ) = ((1+√2)/2)·ℓ + O(1) (Claude, draft, 2026-11-01)

**Status.** This is a draft by Claude: a computer-assisted proof candidate, not peer reviewed, and not yet second-party reviewed.
- The lower bound (§1) is elementary and self-contained.
- The upper bound (§2–§5) depends on THEORY_CASE1 §1–3, §4 and §7a (balanced and parity windows), which still need second-party review.
- This draft supersedes the constants of R-35 (v1: 9ℓ/2; v2: 3ℓ).

Notation (note: in §1, j counts the small reds of the construction; in §3–§4, j = |D∩W| is the size of the minority colour in the window):
- k = ℓ+e, D = ℓ(ℓ−1)/2, F = F(k,ℓ) = k² + (D+1)k + ℓ(ℓ−2).
- A colouring is *good* if it has no monochromatic x₁+…+x_k = y with exactly ℓ distinct summand values.
- K(ℓ) is the least K such that S₂(k;ℓ) = F(k,ℓ) for every k ≥ K.
- a* = (√2−1)/2 ≈ 0.20711.

## Main statement (candidate)

1. **(Lower bound.)** For every ℓ ≥ 50, K(ℓ) > ((1+√2)/2)ℓ − 4. For 19 ≤ ℓ ≤ 49 the exact values from the finite table also give K(ℓ) > ((1+√2)/2)ℓ − 4. In particular K(19) ≥ 21 and K(20) ≥ 22; R-19 needed ℓ ≥ 24 for K(ℓ) ≥ ℓ+2.
2. **(Upper bound, conditional on THEORY_CASE1.)** For every ℓ ≥ 50, K(ℓ) ≤ ((1+√2)/2)ℓ + 5. For every ℓ ≥ 6, K(ℓ) ≤ ((1+√2)/2)ℓ + 9.

Hence |K(ℓ) − ((1+√2)/2)ℓ| < 5 for ℓ ≥ 50.

## 1. Lower bound: the three-block colouring

For 1 ≤ j ≤ ℓ−1 put

- m = ℓ(ℓ+1)/2 + ℓj + e(j+1) − 1,
- V₃ = j(j+1)/2 + (ℓ−j)(m+1) + (ℓ−j)(ℓ−j−1)/2 + e.

Colour [1, V₃−1] with red = [1, j] ∪ [m+1, V₃−1] and blue = [j+1, m]. This colouring is good.

- **Blue.** Any blue k-sum is at least Σ_{i=1..ℓ}(j+i) + e(j+1) = m+1, so it is not blue.
- **Red.** A red k-sum with exactly ℓ distinct values uses at most j small reds. So it has at least ℓ−j values ≥ m+1, which are distinct. Its minimum is j(j+1)/2 + Σ_{i=1..ℓ−j}(m+i) + e·1 = V₃, which lies outside [1, V₃−1].

So V₃ − 1 ≥ F implies S₂(k;ℓ) > F, and then K(ℓ) > k.

**Asymptotics.** G(j) = V₃ − F is a concave quadratic in j, with leading coefficient 1−e−ℓ. With j = xℓ and e = εℓ, its cubic part is −ℓ³[ε(2x²−2x+1) + 2x² − x]/2. This is positive for some x iff ε < max_x (x−2x²)/(2x²−2x+1) = a*, with the maximum at x* = (2−√2)/2.

**All ℓ ≥ 50 (`rigorous_asym.py 4 4 50`, exact sympy with √2 symbolic).**
- Put e₁ = a*ℓ − 4 and A = ℓ+e₁−1. The polynomial 4A·γ + β² − A² − 4A is ≥ 0 for every real ℓ ≥ 50; every coefficient in u = ℓ−50 is ≥ 0. Here β and γ are the j- and constant coefficients of G.
- This means that the integer j nearest the vertex has G ≥ 1, since G(j) ≥ G_max − A/4.
- The vertex lies in [1, ℓ−1].
- G is decreasing in e for fixed j, because ∂G/∂e ≤ −ℓ²/4 − ℓ + 1/4 − 2e < 0. So every integer 1 ≤ e ≤ a*ℓ − 4 has a good three-block colouring of [1, F].

**19 ≤ ℓ ≤ 49.** Exact integer table in `finite_table.py`.

**Brute-force DP confirmations (`goodcheck.py`).**
- The colouring is good, and not extendable, for (ℓ, e) = (4,1), (4,2), (5,1), (5,3), (6,1), (6,2), (7,2), (8,1) and every j.
- **ℓ=19, k=20, j=5:** V₃ = 4181 > F = 4163, and the colouring of [1, 4180] is good.
- **ℓ=20, k=21, j=5:** V₃ = 4861 > F = 4812, and the colouring of [1, 4860] is good.
- The checker reproduces Gaiser's three-segment colouring: good on [1, F−1] and not extendable, in 5 cases including ℓ=20.

A local search over the generalised "small set + blocks" family (`family_search.py`) finds nothing better than [1, j]. At ℓ=18, e=1 the best is V₃ = 3574, just below F = 3575, so the breakpoint ℓ = 16–18 remains open for the SAT search.

## 2. Upper bound: case split on W = [1, 2ℓ]

Let χ be good on [1, F] with χ(1) = red. Exactly one of the following holds.

- **(B) Balanced** (both colours have ≥ ℓ−1 elements in W). Impossible for ℓ ≥ 6 and every e ≥ 1: THEORY_CASE1 §1–3 for non-parity windows, §4 and §7a for the parity window. **Dependency.**
- **(R) W all red.** Impossible for every k ≥ ℓ+1, by Lemma A (§5) with x ≥ 2ℓ+1.
- **(U₁) j = 1.** The minority colour has exactly one element in W. Impossible for e ≥ 4, and for e ≥ 3 when ℓ ≥ 7 (§4).
- **(U) 2 ≤ j ≤ ℓ−2.** Impossible once N − w ≥ 0 (§3), that is, e ≥ eU(ℓ).

## 3. The T1-fill template (case U)

**Colours.** M is the majority colour, with |M∩W| = ℓ+q ≥ ℓ+2. D is the minority colour, with j = ℓ−q. Case I: M red (m₁ = 1). Case II: M blue.

Let S₁ = {m₁, …, m_ℓ} be the ℓ smallest elements of M∩W.

**Parameters.** Throughout, e ≥ 1 (at e = 0 the term (e−1)u is negative and the template is not defined). The template allows y = r′; the closure argument and the subcase b = 2ℓ−1 below use this.
- y, r′, d ∈ S₁ and b ∈ D∩W with b = y + r′ − d. Then d ∉ {y, r′} automatically.
- R′ = S₁∖{y} and u = min R′.
- r = min(S₁∖{r′}).
- z₁, …, z_{q−1}: the q−1 smallest elements of S₁∖{r, r′}.
- d_b = min(D∩W∖{b}). This exists because j ≥ 2.
- Σ₀ = ΣS₁ + (e−1)u.

**Hyperedges.** Each is k summands with exactly ℓ distinct values, and each sum exceeds every summand.

1. L₁ = Σ₀ + r, L₂ = Σ₀ + r′, Z_i = Σ₀ + z_i. These are k-sums of S₁ ⊆ M, so they are forced to D. They are pairwise distinct and > 2ℓ.
2. B₃ = (D∩W∖{b}) ∪ {Z₁, …, Z_{q−1}} has |B₃| = ℓ−2. Then M_v = ΣB₃ + b + L₁ + e·d_b is a k-sum of the D-set B₃ ∪ {b, L₁}, so M_v is forced to M.
3. w = ΣR′ + M_v + (e−1)u + d is a k-sum of the M-set R′ ∪ {M_v}, so w is forced to D.
4. w′ = ΣB₃ + L₁ + L₂ + e·d_b is a k-sum of the D-set B₃ ∪ {L₁, L₂}, so w′ is forced to M.
5. w − w′ = b + d − y − r′ = 0, because B₃ cancels. This is a contradiction as soon as w ≤ N. Every other value is < w.

So the only inequality needed is

  w = ΣR′ + ΣD_W + q·Σ₀ + Σz_i + r + d + e·d_b + (e−1)u ≤ N.

**Existence of the triple inside S₁.**
- Suppose D∩[1, m_ℓ] ≠ ∅ and no triple exists. Then X = S₁ is closed under y + r′ − d (when the result lies in [1, m_ℓ]), so X = (m₁ + δℤ) ∩ [m₁, m_ℓ] with δ ≥ m₁.
  - If δ = 1, then m₁ = 1 and D∩[1, m_ℓ] = ∅, a contradiction.
  - If δ ≥ 2, then m_ℓ ≥ 2ℓ−2+m₁ > ℓ+j ≥ m_ℓ, a contradiction.
- Suppose D∩[1, m_ℓ] = ∅. Then S₁ = [1, ℓ], so this is necessarily case I. Take b ∈ D with b ≤ 2ℓ−1 (one exists since j ≥ 2), and put y = ℓ, r′ = b+1−ℓ, d = 1.

**Worst-case bounds.**
- ΣR′ ≤ ΣS₁ ≤ Σ_{i≤ℓ}(j+i).
- ΣD_W ≤ Σ_{i≤j}(2ℓ−j+i).
- u = 1 in case I: y = r′ = 1 is impossible, so we can relabel so that y ≠ 1. In case II, u ≤ m₂ ≤ j+2.
- r ≤ j+3 (in fact r ≤ m₂ ≤ j+2), d ≤ ℓ+j, z_i ≤ j+i+2, d_b ≤ 2ℓ.

These are implemented in `t1fill_bound.py` (exact integers) and `rigorous_asym.py` (symbolic).

**All ℓ ≥ 50 (`rigorous_asym.py 4 4 50`).**
- P(j) = N − w_bound is a convex quadratic in j. Its leading coefficient is ℓ+1 in case I and ℓ+e in case II.
- At e₀ = a*ℓ + 4, the quantity 4αγ − β² has only nonnegative coefficients in u = ℓ−50, in both cases. So P ≥ 0 for every real j.
- For ℓ ≥ 9, P is increasing in e: ∂P/∂e ≥ ℓ²/4 − 2ℓ + 2e − 5/4 > 0. For ℓ = 6, 7, 8 the same bound is positive once e ≥ 3, and eU ≥ 9 there. In case I the derivative is always positive.
- Hence every integer e ≥ a*ℓ + 4 works, and K(ℓ) ≤ ℓ + ⌈a*ℓ + 4⌉.

The leading terms explain the constant. With e = a*ℓ + c, the discriminant's ℓ⁴ term vanishes in case II, and its ℓ³ coefficient is 2 + 3√2/2 − √2·c. In case I the ℓ⁴ coefficient is 5/4 − √2 < 0, which is the 1/8-threshold of the R-19 four-block windows.

**6 ≤ ℓ ≤ 49.** Exact table (`finite_table.py`): K(ℓ) ≤ ℓ + max(eU, eJ1), with eU ≤ 14 and eJ1 ≤ 4. The maximum of K_upper − ((1+√2)/2)ℓ is 8.55.

**Witness checks (`t1fill_witness.py`).** Explicit hyperedges were built and every condition re-checked: colours, k, exactly ℓ distinct values, sums, ≤ N, and w = w′. The result is 900/900 random unbalanced windows refuted for ℓ = 12, 16, 20, 24, 40.

**Consistency (`consistency.py`).** T1-fill must never refute a window of a known good colouring. The test covers three-block and four-block windows at every e where they are good, with the minimum of w taken exactly over all parameter choices (`consistency2.py`). Result: ℓ = 19..60, 80, 100, 150; 6807 good windows tested; **0 inconsistencies** (`logs/consistency2.txt`). For the three-block windows themselves, the exact-minimum T1-fill refutes every one from e ≈ e_L + 3 or 4.

## 4. j = 1 (`j1_chain.py`)

**Case II.** D∩W = {1} and M = [2, 2ℓ]. Take S = [2, ℓ+1]; then eS = [2e, (ℓ+1)e]. Step 1 forces D on [ΣS+2e, ΣS+(ℓ+1)e]. Step 2 uses {1}, ℓ−1 interval values and e copies of 1. Step 3 uses T = [2, ℓ] and e copies of 2.

**Case I.** D∩W = {b₀}.
- If b₀ > ℓ, take S = [1, ℓ].
- Otherwise take S = [1, ℓ+1]∖{b₀}. Its gaps are ≤ 2 and it contains a run of length 2 starting at offset a ≤ 2.

**Lemma G.** Let O ⊆ [0, Δ] with 0, Δ ∈ O, all gaps ≤ r, and a run [a, a+r−1] ⊆ O. Then for e ≥ 2, eO ⊇ [a, (e−1)Δ + a + r − 1].

*Proof.* (e−1)O ⊇ ⋃_{i≤e−2}(iΔ + O), which has gaps ≤ r on [0, (e−1)Δ]. Adding the run fills every gap.

In both subcases of Case I, eS ⊇ [e+2, e+(e−1)(ℓ−1)]. In Case II, eS = [2e, (ℓ+1)e]. The conditions are then polynomial inequalities. `j1_symbolic.py` substitutes u = ℓ − L₁ ≥ 0 and s = e − E₁ ≥ 0 and finds that every coefficient is nonnegative, in both cases, for (L₁, E₁) = (7, 3) and (6, 4). So the conditions hold for all ℓ ≥ 7 with e ≥ 3, and for ℓ = 6 with e ≥ 4. The integer check `j1_chain.py` (ℓ ≤ 3000) agrees.

## 5. All-red window: Fact 1 and Lemma A

**Fact 1.** Let n = b−a+1 ≥ ℓ+2 and e ≥ 1. Every integer in [ka+D, kb−D] is a k-term sum with exactly ℓ distinct values from [a, b].

*Proof.*
- Take the blocks S_c = [c, c+ℓ−1]. Moving the e extras up one unit at a time inside a block gives every value in [ΣS_c + ec, ΣS_c + e(c+ℓ−1)].
- **e ≥ 2.** Consecutive blocks overlap, since ℓ−1 ≤ e(ℓ−2).
- **e = 1.** The only missing value between blocks c and c+1 is ΣS_c + c + ℓ. It is
  - [c, c+ℓ−2] ∪ {c+ℓ+1} with extra c+ℓ−2, if c+ℓ+1 ≤ b;
  - otherwise {c−1} ∪ [c+2, c+ℓ] with extra c+2, where c−1 ≥ a because n ≥ ℓ+2. ∎

The constructive check `fact1_constructive.py` covers 7000 cases (ℓ ≤ 30, e ≤ 5) with 0 failures.

**All-red window.** Suppose W is all red and k ≥ ℓ+1.
1. By Fact 1 on [1, 2ℓ], every value in I = [k+D, 2kℓ−D] is a red k-sum. These values are > 2ℓ and < F, so they are blue.
2. By Fact 1 on I, which has length ≥ ℓ+2, the blue k-sums cover [k(k+D)+D, k(2kℓ−D)−D] ⊇ [t, F], where t = k(k+D)+D. So [t, F] is red.
3. The red multiset 1^(k−ℓ+1), 2, …, ℓ−1, t has exactly ℓ distinct values and sums to F. This is a contradiction.

(This is Lemma A of THEORY_SMALLEST_BLUE with x ≥ 2ℓ+1, now with Fact 1 proved.)

## 6. Relation to earlier claims

- R-19 (four-block, 9/8) is superseded by the three-block construction, whose constant is (1+√2)/2 ≈ 1.2071.
- R-35 (K ≤ 9ℓ/2, then K ≤ 3ℓ) is superseded by K ≤ ((1+√2)/2)ℓ + 9. The three-step chain is still used for j = 1.
- The known values K(3..11) = ℓ+1 are consistent: the upper bound is not sharp for small ℓ.
- The breakpoint is now ℓ₀ ≤ 19. The smallest ℓ with K(ℓ) > ℓ+1 is at most 19; ℓ = 16, 17, 18 are being decided by the SAT run on the user's machine.

## 6a. Corollary: the relaxed numbers S₂(k; ℓ̃) (Gaiser OQ 6.4, second question)

**Reading of the definition.** Gaiser's relaxed number forbids monochromatic solutions with *at least* ℓ distinct summand values (c(S) ≥ ℓ+1, counting the sum). Only this reading agrees with the paper's value S₂(k;2̃) = k²+2k. The paper's §6 says "c(S) ≥ ℓ", which conflicts with Corollary 6.3 of the paper; we use c(S) ≥ ℓ+1.

**Upper side.** Every restricted solution is also a relaxed solution, so S₂(k;ℓ̃) ≤ S₂(k;ℓ). Gaiser's Corollary 6.3 gives S₂(k;ℓ̃) ≥ F. Hence S₂(k;ℓ̃) = F for every k ≥ K(ℓ), and the relaxed threshold satisfies K̃(ℓ) ≤ K(ℓ).

**Lower side.** The three-block colouring is good in the relaxed sense too. A k-sum with ℓ' ≥ ℓ distinct values has a minimum that only grows with ℓ', for each colour. So the same V₃ bounds hold, and K̃(ℓ) > ((1+√2)/2)ℓ − 4 for ℓ ≥ 50, with K̃(19) ≥ 21 and K̃(20) ≥ 22.

**Brute-force check (`goodcheck_relaxed.py`, DP with the distinct count capped at ℓ).**
- Three-block colourings: good and not extendable, for (ℓ, e) = (4,1), (5,2), (6,1), (6,2), (7,1) and every j.
- The ℓ=19 and ℓ=20 instances are good.
- Gaiser's three-segment colouring is good on [1, F−1] in the relaxed sense.

**Conclusion.** K̃(ℓ) = ((1+√2)/2)ℓ + O(1) as well. The upper bound carries the same conditionality as R-38.

## 6b. Corollary: the diagonal k = ℓ (weak Schur numbers WS_k(2) = S₂(k;k))

**Statement.** Take e = 0 in the three-block construction. This gives S₂(k;k) ≥ max_j V₃(k, 0, j).

**Comparison with known bounds.**
- The construction beats Ahmed et al. 2023 ((k³+4k²−5k+2)/2) for every k ≥ 20; it ties at k = 19. R-19(c) (four blocks) beats it only from k ≥ 22.
- It never exceeds the known exact values WS₈..₁₄(2) = 365, 505, 676, 881, 1123, 1405, 1730. This is a sanity check.

**DP check (`check_diag.py`).** For k = 20, j = 4, the colouring of [1, 4769] is good. Hence **WS₂₀(2) ≥ 4770 > 4751**.

**Asymptotics.** The leading term is still (9/16)k³, as for four blocks. Only the lower-order terms improve.

## 6c. Independent review (Claude subagent, 2026-11-02, not anchored on the drafting)

A separate Claude agent re-derived §1–§5 and the case split by hand. It wrote fresh code only, reusing none of these scripts. **It found no fatal error and no fixable gap.** The cosmetic points it raised have been applied above:
- monotonicity in e for ℓ = 6..8;
- the y = r′ case;
- the empty-intersection subcase being case I;
- the e ≥ 1 requirement;
- the §4 wording;
- the notation clash between §1 and §3.

**Coverage of the review.**
- **Its own checker:** validated on 460 naive enumerations and on Gaiser's construction.
- **Three-block colouring:** good for ℓ = 3..9, e = 0..4 and every j (175 cases), plus the ℓ = 19 and ℓ = 20 instances.
- **T1-fill, exhaustive windows:** every window with 2 ≤ j ≤ ℓ−2 for ℓ = 6, 7, 8 (8.9M parameter instances), with 0 bound violations and a clash in every case.
- **T1-fill, consistency:** a stronger test, w ≥ V whenever [1, V−1] is good, run with exact minimisation including all ℓ-subsets S₁ when there are ≤ 40. Result: 3600 windows, 0 inconsistencies.
- **Asymptotics:** sympy re-derivation of both thresholds. The constants are tight for this method: the lower bound fails at a*ℓ − 3.5 and case II fails at a*ℓ + 3.5.
- **Integer scans:** ℓ ≤ 40000, 0 failures.
- **j = 1:** explicit chains, 9660 cases.
- **Fact 1:** checked on 154,050 values.
- **All-red chain:** checked.
- **THEORY_CASE1:** numerical checks only (ℓ = 6, 7 balanced; parity chains up to ℓ = 160). No written referee of the §7a inequalities.

**Remaining risk.** The upper bound depends on THEORY_CASE1 §7a, which still needs a written second-party referee. That is GPT's task E in round 6.

## 7. Open items

1. Second-party review of everything above, especially §3 (T1-fill) and §2(B) (THEORY_CASE1).
2. Literature and novelty check: three-block colourings in the Rado / Schur-number literature (Ahmed et al. 2023 use four blocks), and Gaiser 2026.
3. Narrow the additive gap (currently < 9 for ℓ ≥ 50) by sharper bounds in T1-fill or better constructions.
