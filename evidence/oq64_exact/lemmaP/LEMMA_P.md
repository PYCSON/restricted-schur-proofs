# Lemma P (prefix dominance for T1-fill) — Claude, 2026-11-05, first-party DRAFT, not reviewed

**Status.** This is a proof candidate written by Claude. No second party has checked it. Each construction in the proof has been checked by machine:

- `lemmaP_check.py` covers every window for ℓ = 6..10 and several e. It found 0 failures, and its negative control fails as predicted.
- `t1dom.c` checks the conclusion exhaustively, against the exact T1-fill minimum, for ℓ = 10..12 and e = 1, 3, 6.
- The closed form (P0) below agrees with the C code in 7568 cases (ℓ = 9..40, e = 1..11, all j).

## Setting

The setting is that of Lemma 22 of the v1.2 preprint (T1-fill):

- ℓ ≥ 4, e ≥ 1, N = F(ℓ+e, ℓ).
- W is a 2-colouring of [1, 2ℓ] with 1 red, in case (U): one colour M has ≥ ℓ+2 elements in W, and the other colour D has j elements, with 2 ≤ j ≤ ℓ−2 and q = ℓ−j ≥ 2.
- S = {m₁ < … < m_ℓ} are the ℓ least elements of M ∩ W, and D = {D₁ < … < D_j} is D ∩ W.
- *Case I* means M is red (1 ∈ S). *Case II* means M is blue (D₁ = 1).
- A tuple (y, r′, d) is *admissible* if y, r′, d ∈ S, d ∉ {y, r′}, and b := y + r′ − d ∈ D. (y = r′ is allowed.)
- w(W; y, r′, d) is the value of Lemma 22, and w*(W) is its minimum over admissible tuples.
- P_j denotes the prefix window: red = [1, j], blue = [j+1, 2ℓ]. It is in case II, with S = [j+1, j+ℓ] and D = [1, j].

## Step 0: a closed form for w

Use ΣR′ = ΣS − y, Σ₀ = ΣS + (e−1)u and d − y = r′ − b. The set {r} ∪ {z_i} is exactly the q least elements of S∖{r′}; write Q(r′) for its sum. Then

  (★) w = (q+1)ΣS + ΣD + (q+1)(e−1)u + [r′ + Q(r′)] − b + e·d_b.

Here:
- u = m₁ if y ≠ m₁, and u = m₂ otherwise.
- r′ + Q(r′) = Σ_{q+1}(S), the sum of the q+1 least elements of S, if r′ is one of them. Otherwise r′ + Q(r′) > Σ_{q+1}(S).
- d_b = D₁ if b ≠ D₁, and d_b = D₂ otherwise.

Call an admissible tuple *good* if y ≠ m₁ and r′ is among the q+1 least elements of S. For a good tuple,

  (★★) w = (q+1)ΣS + ΣD + (q+1)(e−1)m₁ + Σ_{q+1}(S) − b + e·d_b.

**(P0) The prefix value.** For P_j every term of (★) is at least its value under the tuple (y, r′, d) = (j+2, j+1, j+3), for which b = j and d_b = 1. Hence

  w*(P_j) = (q+1)(ℓj + ℓ(ℓ+1)/2) + j(j+1)/2 + (q+1)(e−1)(j+1) + (q+1)j + (q+1)(q+2)/2 − j + e.

Subtracting N gives

  G_P(ℓ,e,j) := w*(P_j) − F(ℓ+e,ℓ) = −e² − e(ℓ²+ℓ−2)/2 − (e+ℓ−1)j² + (eℓ + (ℓ²−ℓ−2)/2)·j + 2ℓ,

and

  w*(P_j) − V₃(ℓ,e,j) = e(j+1) + j(ℓ−2) + ℓ(ℓ+3)/2,

where V₃ is the three-block value. Note that the window of the three-block colouring is exactly P_j.

## Lemma P

Let ℓ ≥ 4 and 1 ≤ e ≤ 2ℓ² − 4ℓ. Every window W of case (U) with 2 ≤ j ≤ ℓ−2 satisfies w*(W) ≤ w*(P_{j′}) for some 2 ≤ j′ ≤ j. Hence

  max_W (w*(W) − N) = max_{2≤j′≤ℓ−2} G_P(ℓ, e, j′).

The maximum is attained, because P_{j′} is itself such a window.

**Reduction.** Let W′ be W with every position > m_ℓ recoloured to M, and let j′ = |D ∩ [1, m_ℓ]|. If j′ ≥ 2, the reduction lemma (README) gives w*(W) ≤ w*(W′). W′ is *reduced*: S ⊔ D(W′) = [1, ℓ+j′] and D_{j′} < m_ℓ = ℓ + j′. So it suffices to prove the following two claims:

- **(A)** w*(W) ≤ w*(P_j) for reduced W.
- **(B)** w*(W) ≤ w*(P_j) for the windows with j′ ≤ 1 (the "low" windows).

### (A) Reduced windows, S ⊔ D = [1, ℓ+j]

Because ΣS + ΣD = ΣS_P + ΣD_P, formula (★★) gives, for a good tuple,

  w − w*(P_j) = −q·δ − (q+1)(e−1)(j+1−m₁) − Δ + (j − b) + e(d_b − 1),

where:
- δ := ΣS_P − ΣS = Σ_i (j+i−m_i) ≥ 0;
- Δ := Σ_{q+1}(S_P) − Σ_{q+1}(S) ≥ 0;
- j + 1 − m₁ ≥ 0, since m_i ≤ i + j.

**Case II (D₁ = 1).**
- Setup. Let p be maximal with [1,p] ⊆ D, so that m₁ = p+1. Here δ = Σ_i (D_i − i), and D_i − i is non-decreasing in i. Let i* = max{i : D_i − i ≤ q+p−1}. Then i* ≥ p, and D_i − i ≥ q+p for every i > i*. Hence δ ≥ (j−i*)(q+p).
- *i* > p*: take b = D_{i*} > m₁ and r′ = m₁. For y ∈ Y := S ∩ (b, ℓ+j], put d = y − (b − m₁).
  - We have |Y| = ℓ − D_{i*} + i* ≥ j − p + 1.
  - The values d are distinct and lie in (m₁, ℓ+j]. Only j − p elements of that interval are not in S.
  - So some d is in S. The tuple is good, with d ≠ r′, d ≠ y and d_b = 1.
- *i* = p, 2 ≤ p < j*: here D_{p+1} ≥ q + 2p + 1 ≥ p+4. Take (y, r′, d) = (p+2, p+1, p+3), so b = p.
- *p = j*: W = P_j.
- *i* = p = 1 < j*: here D₂ ≥ q+3 and [2, q+2] ⊆ S. Take (y, r′, d) = (D₂ − q, q+2, 2), so b = D₂ and r′ = m_{q+1}.
- Bound. In every case b ≠ 1 and b ≥ i*. Therefore j − b ≤ j − i* ≤ q·δ, and w ≤ w*(P_j).

**Case I (m₁ = 1).** Let t = D₁ − 1 ≥ 1, so that [1,t] ⊆ S. A good tuple exists:
- *t ≥ 2*: take (D_j + 1, 1, 2), so b = D_j. (D_j + 1 ∈ S because D_j < m_ℓ.)
- *t = 1*: S∖{1} contains a consecutive pair x, x+1. Otherwise its ℓ−1 elements in [3, ℓ+j] would need ≥ ℓ−2 separating D elements, plus the element 2, giving j ≥ ℓ−1. Take (x+1, 1, x), so b = 2 = D₁ and d_b = D₂.

Bounds used, all from m_i ≤ i+j:
- δ ≥ tj;
- if t = 1, δ ≥ j + (D₂−3)(j−1);
- Δ ≥ j;
- (q+1)j ≥ ℓ + j − 1 ≥ max(t, D₂), since (q+1)j − (ℓ+j−1) = (j−1)(q−1).

Then:
- *t ≥ 2*: w − w*(P_j) ≤ −qtj − (e−1)t + (j − D_j) + et ≤ −qtj + t < 0.
- *t = 1*: w − w*(P_j) ≤ −q(j + (D₂−3)(j−1)) − j − (e−1)(D₂−1) + (j−2) + e(D₂−1) < 0.

### (B) Low windows (j′ ≤ 1)

Write D″ = D ∩ (m_ℓ, 2ℓ]. Formula (★) is used directly; the sums ΣS + ΣD are no longer equal.

- **(L2)** Case II, S = [2, ℓ+1]. Let β = min D″ ∈ [ℓ+2, 2ℓ] and take (y, r′, d) = (ℓ+1, β−ℓ+1, 2). Then b = β, and r′ + Q(r′) ≤ Σ_{q+1}(S) + (j−1). This gives w − w*(P_j) < −j(ℓ−2) < 0.
- **(L1)** Case I, S = [1, ℓ+1]∖{a} with 2 ≤ a ≤ ℓ. Let β = min D″.
  - If β−ℓ ≠ a, take (ℓ+1, β−ℓ, 1).
  - Else, if a ≠ 2, take (ℓ+1, a+1, 2).
  - Else take (ℓ+1, 4, 3).

  In all three b = β and d_b = a. This gives w − w*(P_j) ≤ −(q−1)(ℓ+j) − 1 < 0.
- **(L0)** Case I, S = [1, ℓ], D ⊆ [ℓ+1, 2ℓ].
  - If D₂ ≤ 2ℓ−1, take (ℓ, D₂+1−ℓ, 1): b = D₂ and d_b = D₁ ≤ 2ℓ − j + 1. This gives w − w*(P_j) < 0, using (q+1)j ≥ D₁ − 1, which follows from (j−2)(q) ≥ 0.
  - Otherwise j = 2 and D = {D₁, 2ℓ}. Take (ℓ, D₁+1−ℓ, 1): b = D₁ and d_b = 2ℓ. Direct expansion gives w − w*(P_2) ≤ e − 2ℓ² + 4ℓ. This is the only place where the bound e ≤ 2ℓ² − 4ℓ is used.
  - The negative control `lemmaP_check.py 7 72 100` fails exactly here.

## Consequence (Theorem Q, candidate)

Let ℓ ≥ 9 and put e₀ = max(3, e_P(ℓ)), where e_P(ℓ) = min{e ≥ 1 : G_P(ℓ,e,j) ≤ 0 for all 2 ≤ j ≤ ℓ−2}. Then S₂(k;ℓ) = F(k,ℓ) for every k ≥ ℓ + e₀, so K(ℓ) ≤ ℓ + e₀. Also K(ℓ) ≥ ℓ + e_L(ℓ) + 1, where e_L(ℓ) = max{e : max_j V₃ − F ≥ 1} (Proposition 19).

*Proof.* Take e = e₀; this needs e₀ ≤ 2ℓ² − 4ℓ.
- Cases (B) and (R) are impossible for every e.
- j = 1 is impossible for e ≥ 3 (Lemma 24, ℓ ≥ 7).
- For 2 ≤ j ≤ ℓ−2, Lemma P and G_P ≤ 0 give w*(W) ≤ N, so Lemma 22 refutes W.

The same tuple refutes W at every e ≥ e₀ (monotonicity, ℓ ≥ 9, README item 6). ∎

Numerically (`eLP_big.py`; exact integers; the maximum over j is taken at the vertex of the concave quadratic, checked against brute force for ℓ = 9..199 and e ≤ 39):
- for 19 ≤ ℓ ≤ 60, e_P − e_L ∈ {3, 4};
- for 19 ≤ ℓ ≤ 60, (1+a*)ℓ − 3.22 < K(ℓ) < (1+a*)ℓ + 0.45, compared with (−4, +5) in Theorem 18.

The full table up to ℓ = 20000 is in `eLP_19_20000.txt`. A heuristic: the real-variable value of e_P − e_L tends to (1/2 + x + a*x)/(1/2 − x + x²) = 2.914… at x = (2−√2)/2.

## Theorem Q′ (candidate): an additive window of width below 4.63 for every ℓ ≥ 19

For every ℓ ≥ 19,

  (1+a*)ℓ − 3.63 < K(ℓ) < (1+a*)ℓ + 1.

The upper bound needs Lemma P. The lower bound does not, and it improves the −4 of Corollary 20.

- **Upper bound** (`asym_upper.py`, sympy exact with √2 kept symbolic).
  - Write G_P = −A j² + β j + γ with A = e+ℓ−1. Its real maximum over j is negative iff Disc := β² + 4Aγ < 0.
  - Substitute e = a*ℓ and ℓ = 19 + u. Every coefficient of Disc, as a polynomial in u, is negative. So G_P < 0 for every real j at e = a*ℓ.
  - ∂G_P/∂e < 0, so the same holds for every e ≥ a*ℓ. Hence e_P(ℓ) ≤ ⌈a*ℓ⌉ < a*ℓ + 1.
  - Then K(ℓ) ≤ ℓ + max(3, ⌈a*ℓ⌉) < (1+a*)ℓ + 1. Here max(3, ⌈a*ℓ⌉) = ⌈a*ℓ⌉ because a*·19 > 3.
  - With e = a*ℓ − 1/2 the same holds from ℓ = 1000 on, so K(ℓ) < (1+a*)ℓ + 1/2 for ℓ ≥ 1000.
- **Lower bound** (`asym_lower.py`). This is the criterion of Corollary 20(a): H := 4Aγ + β² − A² − 4A ≥ 0 for G_L = V₃ − F.
  - Substitute e = a*ℓ − 3.63 and ℓ = 19 + u. Every coefficient is positive. The vertex satisfies 3/2 ≤ j* ≤ ℓ − 3/2 for every ℓ ≥ 19 (`asym_vertex.py`: both differences times 2A have only positive coefficients in u). So the nearest integer j lies in [1, ℓ−1].
  - So some integer j has V₃ − F ≥ 1 at e = ⌊a*ℓ − 3.63⌋, and K(ℓ) ≥ ℓ + ⌊a*ℓ − 3.63⌋ + 1 > (1+a*)ℓ − 3.63.
  - Numerically the infimum over 19 ≤ ℓ ≤ 20000 is −3.6199, close to the conjectured limit −3(1+√2)/2 = −3.6213.

**Still open for a second party:**
1. Review Lemma P.
2. Review the three sympy arguments above (`asym_upper.py`, `asym_lower.py`, `asym_vertex.py`), and check that ⌈a*ℓ⌉ ≥ 3 for ℓ ≥ 19.
3. Check that e₀ ≤ 2ℓ² − 4ℓ (immediate from e₀ = ⌈a*ℓ⌉ for ℓ ≥ 19; for 9 ≤ ℓ ≤ 18, e₀ ≤ 4).
