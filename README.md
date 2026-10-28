# On two open questions of Gaiser on restricted generalized Schur numbers

**Author:** Puyi Sun (ORCID [0009-0004-1644-5300](https://orcid.org/0009-0004-1644-5300))
**Version:** 1.0, 28 October 2026
**Status:** computer-assisted proof candidate. **Not peer reviewed.**

Preprint: [`paper/restricted-schur-v1.0.pdf`](paper/restricted-schur-v1.0.pdf) (source: `paper/restricted-schur-v1.0.tex`).

## The problems

For integers `2 ≤ ℓ ≤ k`, `S_r(k;ℓ)` is the least `n` such that every `r`-colouring of `{1,…,n}` contains a
monochromatic solution of `x_1 + … + x_k = x_{k+1}` that uses **exactly** `ℓ+1` distinct integers
(C. Gaiser, *Restricted generalized Schur numbers*, [arXiv:2608.08789](https://arxiv.org/abs/2608.08789)).
Gaiser proved `S_2(k;ℓ) ≥ F(k,ℓ) := k² + [(ℓ+1)(ℓ−2)/2 + 2]·k + ℓ(ℓ−2)` with equality for all large `k`, and asked:

* **Open Question 6.2:** is `S_3(k;2) = k³+3k²+k−1` for all large `k`?
* **Open Question 6.4:** what is the least `K(ℓ)` such that `S_2(k;ℓ) = F(k,ℓ)` for all `k ≥ K(ℓ)`?

## Results (all computer-assisted proof candidates)

| # | Statement | Where |
|---|---|---|
| 1 | `S_3(k;2) = k³+3k²+2k−2` for **every** `k ≥ 3`. So the answer to OQ 6.2 is negative. The lower bound was first made public by the Omega Institute's *trureturing* project (5 Oct 2026, issue #13213); **no priority is claimed for it**. The matching upper bound is, to our knowledge, new. | paper §8; `evidence/ub_cert`, `evidence/s3k2`, `lean/s3k2-full` |
| 2 | `K(3)=3, K(4)=4, K(5)=6, K(6)=7, K(7)=8, K(8)=9, K(9)=10, K(10)=11`. Each upper bound `S_2(k;ℓ) ≤ F(k,ℓ)` holds for **all** `k` from the threshold on. | paper Thm 3; `evidence/oq64_kernel`, `evidence/oq64_l8/k9`, `evidence/oq64_l9/k10`, `evidence/oq64_l10/k11`, `lean/oq64` (ℓ ≤ 7) |
| 3 | Two-colour weak Schur numbers `WS_8(2)=365`, `WS_9(2)=505`, `WS_10(2)=676`. The lower bounds are from Ahmed–Boza–Revuelta–Sanz (2023); the new part is the matching upper bounds. | paper §2, §4; `evidence/oq64_diag` |
| 4 | `S_2(12;11) = 915 = F(12,11)`. The symbolic certificate for all `k ≥ 13`, which would give `K(11)=12`, is still being computed and is **not** claimed. | paper §9; `evidence/oq64_l11/k12` |
| 5 | Four-block colourings: `K(ℓ) ≥ ℓ+2` for every `ℓ ≥ 24` and `K(ℓ) ≥ (9/8 − o(1))ℓ`. This is elementary, with Lean for the main construction. | paper Thm 5, Cor 6; `evidence/oq64_fourblock`, `lean/oq64` (`OQ64.Four`) |
| 6 | Uniqueness of the extremal colouring for 12 pairs `(k,ℓ)`. | paper §6; `evidence/oq64_structure` |
| 7 | For `11 ≤ ℓ ≤ 23` and every `k ≥ ℓ+1`, no good colouring of `[1,F(k,ℓ)]` has a window `W_j` (1470 certificates plus a forcing lemma). Not yet checked by a second party. | paper §7; `evidence/oq64_windows` |

What each result has been checked with is stated in the status box on page 1 of the preprint and in its
Appendix A. In short:

* For results 1 and 2 with `ℓ ≤ 7`, the certificates were also replayed by a second, independently written checker.
* For `ℓ = 8, 9, 10` and results 3–4, only our own tools have checked them so far.
* Every LRAT proof is accepted by `lrat-check` and by the formally verified checker `cake_lpr`.

## How the certificates work

A *symbolic certificate* is a finite hypergraph whose vertices are integer polynomials in `k`. Each edge is a
polynomial identity `w = (k−c)·a + Σ m_i o_i` encoding a valid solution for **every** `k ≥ k0`. All range,
multiplicity and distinctness conditions are checked exactly on the whole region by `check_cert.py`, with no
sampling. A colouring of `[1,F]` that avoids all edges is impossible exactly when the 2-colouring CNF is
unsatisfiable, and that is certified by LRAT. *Single-value* certificates are ordinary hypergraphs on integers,
and every hyperedge is re-checked from the definition by `mkcnf.py`. The search programs that found the
certificates (`evidence/oq64_kernel/symeng*`, `evidence/oq64_l8/*`) play no role in correctness.

## Verifying

### Requirements

* `bash`, `xz`, Python 3 with `sympy`. The commands are for Linux, macOS, or WSL on Windows.
* The two LRAT checkers:

| Tool | Repository | Commit | SHA-256 of the binary we used (Linux x86-64) |
|---|---|---|---|
| lrat-check | https://github.com/marijnheule/drat-trim | `2e3b2dc0ecf938addbd779d42877b6ed69d9a985` | `24a561223ea0f61618b6d0d6741cc859d35778fb9d1f13c3fa2a183e0f39dd36` |
| cake_lpr (formally verified) | https://github.com/tanyongkiam/cake_lpr | `a36874a8b750b43fe4b385b8ddbf5b033e46a3fa` | `1822ca1e5d0f925e8f3b73047941a8261bee65eef6ccb0e33bb49f92821a09ca` |
| CaDiCaL 3.0.1 (only to regenerate proofs) | https://github.com/arminbiere/cadical | `c60730422e758ef1cebe7aeddf2dda31c996bf04` | `f66d249718a03a6188d7850cafb7a8f57ef22493973bffa0a6fd28fa485c7333` |

### One command

```bash
sha256sum -c MANIFEST.sha256 --quiet          # integrity of every file
LRAT_CHECK=/path/to/lrat-check CAKE_LPR=/path/to/cake_lpr ./verify_all.sh
```

`verify_all.sh` replays results 1–4. Sections can be run separately: `oq62`, `oq64sym`, `oq64single`, `diag`, `l11k12`.
For each certificate it:

* re-derives the CNF from the certificate (or from the definition), and checks every edge;
* checks that the stored CNF is byte-identical to the regenerated one;
* runs both LRAT checkers.

A full run takes a few hours. `cake_lpr` needs about 4 GB of heap for the largest proofs; set `CAKE_HEAP`
(in MB) to change it.

### Lean 4

Both Lean projects use Lean v4.35.0 with the core library only (see each `lean-toolchain`).

```bash
cd lean/s3k2-full && ulimit -s unlimited && lake build && lake env lean Test/Axioms.lean
lake env lean Test/Fault.lean      # 4 tampered inputs; every one must be rejected
cd ../oq64 && lake build OQ64.Final OQ64.Final2 OQ64.Four
```

The axiom check shows only `propext`, `Classical.choice` and `Quot.sound`.

* `lean/s3k2-full` proves `RSN.S3_two_eq` (result 1).
* `lean/oq64` covers `K(3),…,K(7)`, the Ahmed et al. lower bound and the four-block construction.
* Not formalised: the certificates for `ℓ ≥ 8`, the diagonal values, and the general inequalities of Corollary 6.

### Results 5–7

* `evidence/oq64_fourblock/verify4.py` and `sym4.py` check the four-block colourings and inequalities.
* `evidence/oq64_structure`: for each pair, `u_<k>_<ℓ>.edges.xz` and `.lrat.xz` certify uniqueness, and
  `g_<k>_<ℓ>.good` is the extremal colouring.
* `evidence/oq64_windows/wj_certs*/W_l<ℓ>_j<j>*`: each directory has `W.edges`, `W.cnf.xz`, `W.lrat.xz` and
  `prefix.txt`. Check with `tools/mkcnfw.py k ℓ n W.edges out.cnf PREFIX`, then the two LRAT checkers.
  `z1*_combined.py` checks the forcing-lemma inequalities.

## Use of AI

The mathematics, programs, computations and text were produced with extensive use of AI systems: Claude
(Anthropic), and GPT and Codex (OpenAI). The author selected the problems, organised and directed the work, set
the verification requirements and decided what to release. The author has **not** personally checked every proof.
Correctness rests on the machine-checkable certificates and formal proofs in this repository, which anyone can
replay. AI systems are not authors. See Appendix A of the preprint for who did what.

## Licence

Text and data: CC BY 4.0. Code: MIT. See [`LICENSE`](LICENSE).

## Citation

See [`CITATION.cff`](CITATION.cff). A Zenodo DOI will be added for each release.
