# Changelog

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
