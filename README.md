# On two open questions of Gaiser on restricted generalized Schur numbers

**Author:** Puyi Sun (ORCID [0009-0004-1644-5300](https://orcid.org/0009-0004-1644-5300))<br>
**Version:** 1.0, 28 October 2026<br>
**Status:** computer-assisted proof candidate. **Not peer reviewed.**<br>
**DOI (Zenodo, v1.0.1):** [10.5281/zenodo.23752136](https://doi.org/10.5281/zenodo.23752136)

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
| 7 | For `11 ≤ ℓ ≤ 23` and every `k ≥ ℓ+1`, no good colouring of `[1,F(k,ℓ)]` has a window `W_j` (1470 certificates plus a forcing lemma). First-party certificate checks only; an independent second-party replay of all 1470 certificates and of the forcing lemma is still pending. | paper §7; `evidence/oq64_windows` |

What each result has been checked with is stated in the status box on page 1 of the preprint and in its
Appendix A. In short:

* For Result 1 and for the cases `ℓ ≤ 7` of Result 2, independent checker replays are reported: a second, independently written checker was run on the certificates.
* For `ℓ = 8, 9, 10` and Results 3, 4, 6 and 7, only first-party tools (written and run within this project) have checked them so far.
* Codex reported a separate replay of the chain for `WS_8(2)=365` (independent encoder, fresh solver run, its own LRAT checker). That report does not replace an independent examination of its original logs.
* The archived first-party logs report that every included LRAT proof is accepted by both `lrat-check` and the formally verified checker `cake_lpr`. How far each result has been independently replayed is stated result by result in the preprint.
* The levels of checking are kept distinct. An *independently written* checker means separate source code. A *second-party replay* means the certificate was actually run by a separate system. Neither means that the human author has personally verified the mathematics, which he has not done for every step (see "Use of AI").
* On 28 October 2026 the final `verify_all.sh` and the certificate inputs of this release were replayed with `./verify_all.sh all`. The first-party logs are archived in `logs/` (`verify_all_v1.0.log`, `checker_outputs_v1.0.tar.xz`, `negative_controls_v1.0.log`).

## How the certificates work

A *symbolic certificate* is a finite hypergraph whose vertices are integer polynomials in `k`. Each edge is a
polynomial identity `w = (k−c)·a + Σ m_i o_i` encoding a valid solution for **every** `k ≥ k0`. All range,
multiplicity and distinctness conditions are checked exactly on the whole region by `check_cert.py`, with no
sampling. A colouring avoiding the certified edges exists if and only if the associated colouring CNF is
satisfiable (the colour of 1 is fixed by symmetry). That CNF's unsatisfiability is certified by an LRAT proof,
which is checked independently. *Single-value* certificates are ordinary hypergraphs on integers, and every
hyperedge is re-checked from the definition by `mkcnf.py`. The search programs
(`evidence/oq64_kernel/symeng*`, `evidence/oq64_l8/*`) are not trusted components of the verification chain.
The certificate validators and the proof checkers must establish the required conditions on their own.

Some generation scripts and logs contained absolute paths of the original workspace. These were replaced by the
placeholders `<TOOLS>`, `<REPO>` and `<WORKDIR>`. Such scripts are records of how the certificates were produced;
they are not needed for verification.

## Verifying

### Requirements

* `bash`, `xz`, Python 3 with `sympy`. The commands target a POSIX shell (Linux, macOS, or WSL on Windows). The binary hashes below apply to the stated Linux x86-64 builds; builds on other platforms may differ.
* The two LRAT checkers:

| Tool | Repository | Commit | SHA-256 of the binary we used (Linux x86-64) |
|---|---|---|---|
| lrat-check | https://github.com/marijnheule/drat-trim | `2e3b2dc0ecf938addbd779d42877b6ed69d9a985` | `24a561223ea0f61618b6d0d6741cc859d35778fb9d1f13c3fa2a183e0f39dd36` |
| cake_lpr (formally verified) | https://github.com/tanyongkiam/cake_lpr | `a36874a8b750b43fe4b385b8ddbf5b033e46a3fa` | `1822ca1e5d0f925e8f3b73047941a8261bee65eef6ccb0e33bb49f92821a09ca` |
| CaDiCaL 3.0.1 (only to regenerate proofs) | https://github.com/arminbiere/cadical | `c60730422e758ef1cebe7aeddf2dda31c996bf04` | `f66d249718a03a6188d7850cafb7a8f57ef22493973bffa0a6fd28fa485c7333` |

### Main verification commands and scope

```bash
sha256sum -c MANIFEST.sha256 --quiet          # integrity of every payload file (the manifest does not hash itself)
export LRAT_CHECK=/path/to/lrat-check CAKE_LPR=/path/to/cake_lpr
./verify_all.sh all                            # Results 1-4, 6 and 7
tests/negative_controls.sh                     # 11 tampered inputs / fake checkers; every one must be rejected
```

The sections can also be run on their own:

| Section | Result | What it checks |
|---|---|---|
| `oq62` | 1 | The seven symbolic cases with `check_kernel.py`, and the CNFs for `3 ≤ k ≤ 7` regenerated from the definition |
| `oq64sym` | 2, 3 | All symbolic certificates with `check_cert.py` (`certeq_*` re-prove `WS_5`–`WS_7`) |
| `oq64single` | 2 | `S_2(9;8)`, `S_2(10;9)`, `S_2(11;10)` |
| `diag` | 3 | `WS_8(2)`, `WS_9(2)`, `WS_10(2)` upper bounds |
| `l11k12` | 4 | `S_2(12;11) ≤ 915` |
| `unique` | 6 | The 12 extremal colourings are good, and the blocking-clause CNFs are unsatisfiable |
| `windows` | 7 | All 1470 window certificates (each prefix must be exactly the window `W_j`), then the combined forcing-lemma argument |

With no arguments the script runs `oq62 oq64sym oq64single diag l11k12`; an unknown section name is an error.
For each certificate, the script checks the hyperedges or the symbolic semantics and reconstructs the
corresponding CNF. Where a stored CNF is supplied, the reconstructed CNF is compared byte for byte with it. For
the uniqueness certificates, the CNF is generated from the checked hyperedges and the explicit blocking clause
before the LRAT replay. Section `unique` requires exactly the 12 pairs of Result 6. Every selected LRAT proof is
checked by both checkers.

A step passes only if the checker exits with status 0 **and** prints its exact success line. Set `LOGDIR=dir`
to keep every checker output. Result 5 is checked separately (Lean and the scripts listed below). Accepting each certificate does not
by itself validate the coverage argument across certificates; for Result 7 that argument is the separate
`windows_coverage.py` step.

Running time depends strongly on hardware, memory limits and the checker builds. The largest proofs take
several hours and need a few GB of disk space. `cake_lpr` needs about 4 GB of heap for them; set `CAKE_HEAP`
(in MB) to change this.

### Lean 4

Both Lean projects use Lean v4.35.0 with the core library only (see each `lean-toolchain`).

```bash
cd lean/s3k2-full && ulimit -s unlimited && lake build && lake env lean Test/Axioms.lean
lake env lean Test/Fault.lean      # 4 tampered inputs: must print exactly 4 errors (see below)
lake env lean Test/FaultControl.lean   # the untampered version of input 3: must succeed
cd ../oq64 && lake build OQ64.Final OQ64.Final2 OQ64.Four
```

The axiom check shows only `propext`, `Classical.choice` and `Quot.sound`. `Test/Fault.lean` is a negative
test. It must fail with four errors: three of the form "Tactic `decide` proved that the proposition … is false"
(lines 4, 6, 11) and one "(kernel) application type mismatch" (line 9). The recorded output is
`lean/s3k2-full/logs/fault.out`.

* `lean/s3k2-full` proves `RSN.S3_two_eq` (result 1).
* `lean/oq64` covers `K(3),…,K(7)`, the Ahmed et al. lower bound and the four-block construction.
* Not formalised: the certificates for `ℓ ≥ 8`, the diagonal values, and the general inequalities of Corollary 6.

### Results 5–7

* `evidence/oq64_fourblock/verify4.py` and `sym4.py` check the four-block colourings and inequalities.
  These are not part of `verify_all.sh`.
* Result 6, `evidence/oq64_structure`: for each pair `(k,ℓ)` the files are named **`u_<ℓ>_<k>`** and **`g_<ℓ>_<k>`**.
  For example, `(k,ℓ)=(4,3)` uses `u_3_4.edges.xz`, `u_3_4.lrat.xz` and `g_3_4.good`. The `.good` file is the
  extremal colouring of `[1,F(k,ℓ)−1]`. `mkcnf_block.py` adds a clause excluding it. Section `unique` automates
  both steps.
* Result 7, `evidence/oq64_windows/wj_certs*/…`: each directory contains `W.edges.xz`, `W.cnf.xz`, `W.lrat.xz`
  and `prefix.txt`. Decompress the edge file, then run `tools/mkcnfw.py k ℓ n W.edges out.cnf PREFIX` with the
  parameters of that case and the prefix from `prefix.txt`. Compare the result with the decompressed `W.cnf.xz`
  and run both LRAT checkers. Section `windows` automates this for all 1470 cases.
  * `wj_certs/` holds the cases with `k = ℓ+1`.
  * `wj_certs_e2_5/e<e>/` holds `k = ℓ+e`.
  * `wj_certs_gap/e<e>_W_…` holds the remaining pairs.
* The combined argument for Result 7 is checked in exact integer arithmetic by `windows_coverage.py`. It collects
  the certified `(ℓ,j,e)` from the directories and runs `z1c_combined.py`. Section `windows` runs it after the
  certificates. `z1_r23_all_e.py` and `z1b_combined.py` are intermediate steps, and their recorded outputs are in
  `*_out.txt`.

## Use of AI

The mathematics, programs, computations and text were produced with extensive use of AI systems: Claude
(Anthropic), and GPT and Codex (OpenAI). The author selected the problems, organised and directed the work, set
the verification requirements and decided what to release. The author has **not** personally checked every proof.
Correctness rests on the machine-checkable certificates and formal proofs in this repository, which anyone can
replay. AI systems are not authors. See Appendix A of the preprint for who did what.

## Licence

Text and data: CC BY 4.0. Code: MIT. See [`LICENSE`](LICENSE).

## Citation

See [`CITATION.cff`](CITATION.cff). Archived on Zenodo: [10.5281/zenodo.23752136](https://doi.org/10.5281/zenodo.23752136) (release v1.0.1; content identical to v1.0.0 of 28 October 2026 apart from `CITATION.cff`).
