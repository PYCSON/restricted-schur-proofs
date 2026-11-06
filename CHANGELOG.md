# Changelog

## v1.3.0 ([RELEASE DATE]) — DRAFT, not yet reviewed

### Added
- **Result 9, exact thresholds:**
  - `K(ℓ) = ℓ+1` for every `12 ≤ ℓ ≤ 18`. This answers open problem 1 of v1.2: the break point at `k = ℓ+1` is exactly `ℓ = 19`.
  - `K(19) = 21` and `K(20) = 22`. The three-block lower bound of Result 8 is exact there.
- **Result 10:** `S_2(20;19) = 4181` and `S_2(21;20) = 4861`. These are the smallest pairs with `k > ℓ` and `S_2 > F`. In both cases `S_2 = max{F, V_3}`.
- **Method for Results 9 and 10.** For every window, the exact minimum of the T1-fill template (Lemma 22) is computed, using a reduction lemma and monotonicity in `e`. Each surviving window, and each window with one minority element at `e ≤ 2`, is refuted by a per-window certificate: 14,723 certificates in all. Each consists of hyperedges re-checked by `mkcnfw.py`, followed by an LRAT proof accepted by both lrat-check and cake_lpr.
- **Result 11 (Lemma P, prefix dominance)** and **Result 12 (Theorem Q′):** `(1+a*)ℓ − 3.63 < K(ℓ) < (1+a*)ℓ + 1` for every `ℓ ≥ 19`. These are written proofs with machine-checked constructions and exact sympy checks.
- `evidence/oq64_exact/`: survivor files, per-window lists, hyperedges, all 14,723 LRAT proofs (43 MB), production logs, the enumerators and the exact sources of the binaries used, the replay script, the Lemma P material, and a second implementation of the T1-fill decision (`fullcheck/`).
- `verify_all.sh` gains the sections `exact12` … `exact20`, `s2_20_19`, `s2_21_20`, `exactenum`, `exactenumbig` and `lemmap`. The quick part (`exact12`–`exact15`, `exactenum`, `lemmap`) is in the default run.
- `tests/negative_controls_exact.sh`: 16 negative controls and one positive control for the new sections.
- Preprint v1.3 (`paper/restricted-schur-v1.3.{tex,pdf}`). The v1.0–v1.2 preprints are kept unchanged.

### Changed
- README and `CITATION.cff` now give the v1.2.0 DOI, 10.5281/zenodo.23938150.

### Unchanged
- All certificates, checkers and Lean developments of v1.0–v1.2 (byte-identical). Earlier releases and their DOIs are not modified.

### Status
- Computer-assisted proof candidates, not peer reviewed. The computations for Results 9–12 are first-party (Claude). Second-party review: [to be completed after the GPT round-8 review].

## v1.2.0 (3 November 2026)

### Added
- **Result 8, asymptotics of K(ℓ)** (preprint §8, Theorem 18): `(1+a*)ℓ − 4 < K(ℓ) < (1+a*)ℓ + 5` for every `ℓ ≥ 50`, with `a* = (√2−1)/2`; hence `K(ℓ) = ((1+√2)/2)ℓ + O(1)`. For `6 ≤ ℓ ≤ 49`, `K(ℓ) < (1+a*)ℓ + 9`.
  - Lower bound: a three-block colouring (Proposition 19). It also gives `S_2(20;19) ≥ 4181 > F`, `S_2(21;20) ≥ 4861 > F` (so `K(19) ≥ 21`, `K(20) ≥ 22`) and, on the diagonal, `WS_k(2)` above the Ahmed et al. bound for every `k ≥ 20` (`WS_20(2) ≥ 4770`).
  - Upper bound: the T1-fill template (Lemma 22) for windows with a sparse colour, Lemma 23 (worst-case bound, exact `Q(√2)` polynomial check), Lemma 21 (all-red window) and Lemma 24 (one minority element), with Proposition 15 and Lemma 16 for balanced and parity windows.
  - The relaxed variant `S_2(k;ℓ̃)` (read with `c(S) ≥ ℓ+1`) has the same constant (Open problem 4).
- `evidence/oq64_asymptotic/`: first-party exact scripts and logs, GPT's second-party review (report with passages about private correspondence removed, separately written checkers, outputs), and an independent re-derivation by a separately started Claude instance.
- `verify_all.sh` sections `asym` and `asymind` (python3 + sympy only; both are in the default run). These two sections no longer require `LRAT_CHECK`/`CAKE_LPR`.
- Four more negative controls (22 in all): the upper-bound proof with additive constant 3, the three-block colouring extended by one integer, a tampered T1-fill witness, and `verify_all.sh asym` under Python optimisation.
- Preprint v1.2 (`paper/restricted-schur-v1.2.{tex,pdf}`). Open problems 1–3 are rewritten: the break point is now open only for `12 ≤ ℓ ≤ 18`. The v1.0 and v1.1 preprints are kept unchanged.

### Changed
- Proposition 15 and Lemma 16 (balanced and parity windows, §7) were reviewed by a second party as part of the v1.2 review. GPT also wrote out and checked the infinite-parameter inequalities of Lemma 16 in full.
- In v1.1, Open problem 2 asked whether the four-block colourings are optimal. Proposition 19 beats them, so that form of the question has a negative answer.

### Unchanged
- All certificates, checkers and Lean developments of v1.0 and v1.1 (byte-identical). Earlier releases and their DOIs are not modified.

### Status
- Computer-assisted proof candidate, not peer reviewed. The human author has not personally checked every proof step.

## v1.1.0 (1 November 2026)

### Added
- **K(11)=12** (README Result 4, preprint Theorem 3(d) and §4.1): `S_2(k;11) = k²+56k+99` for every `k ≥ 12`.
  - For all `k ≥ 13` the proof uses 222 symbolic cube certificates, one per cube of a complete prefix partition of the colourings. Each has a symbolic hypergraph and an LRAT proof.
  - `k = 12` is the single-value certificate of v1.0.
  - `k = 11` fails by the known lower bound `WS_11(2) ≥ 881 > 836`.
- `evidence/oq64_l11/k13_cubes/`: the certificates, the checkers `check_partition.py` and `check_cube.py`, first-party logs, and the generation scripts (historical).
- `evidence/oq64_l11/k13_cubes/independent_review/`: GPT's separately written symbolic validator and LRAT checker, with its recorded outputs. Everything passed for all 222 cubes. For the release only the file paths were adapted; the originals are in `original/`.
- `verify_all.sh` sections `l11k13` (now part of the default run) and `l11k13ind`.
- Seven more negative controls (18 in all): a cube removed from the partition, a unit clause that contradicts its prefix, a certificate used for another prefix, the second-party LRAT checker on a proof without the empty clause, and three runs under Python optimisation (`PYTHONOPTIMIZE=1`) that must be refused.
- `verify_all.sh` and the release copies of the second-party checkers refuse to run under Python optimisation (`-O` / `PYTHONOPTIMIZE`), because it removes `assert` statements that the checkers rely on (found in GPT's release review).
- Preprint v1.1 (`paper/restricted-schur-v1.1.{tex,pdf}`). The v1.0 preprint is kept unchanged.
  - Open problem 1 is narrowed to `12 ≤ ℓ ≤ 23`.
  - It mentions an uncertified exhaustive search for `12 ≤ ℓ ≤ 15` at `k = ℓ+1` as evidence only.

### Unchanged
- All v1.0 certificates, checkers and Lean developments (byte-identical). The v1.0.0/v1.0.1 releases and DOI `10.5281/zenodo.23752136` are not modified.

### Status
- Computer-assisted proof candidate, not peer reviewed. The human author has not personally checked every proof step. See "Use of AI" in the README and Appendix A of the preprint.

## v1.0.1 (29 October 2026)
- `CITATION.cff`: single licence identifier so that Zenodo can import the metadata. No other change.

## v1.0.0 (28 October 2026)
- First public release.
