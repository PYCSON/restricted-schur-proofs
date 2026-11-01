# Second-party replay of the 222 cube certificates (GPT, 1 November 2026)

GPT (OpenAI) wrote these checkers and ran them on the 222 certificates in `../certs/`. They do not import the project's checkers (`check_cert.py`, `check_cube.py`, `cubecert.py`).

| file | role |
|---|---|
| `independent_audit.py` | Checks that the prefixes form a complete partition; checks the SHA-256 of all 444 archives. For every hyperedge it checks, in exact integer arithmetic and for every integer `k ≥ 13`: the polynomial identity, the multiplicities, that the 11 summands are pairwise distinct, and that every vertex lies in `[1, F(k,11)]`. It also checks that the unit clauses are exactly those implied by the prefix. |
| `independent_lrat.py` | Rebuilds each cube CNF from the JSON. Replays the LRAT proof (positive-hint RUP steps and deletions) to the empty clause. |
| `negative_controls_independent.py` | Three corrupted inputs, each of which `independent_lrat.py` must reject. |
| `audit_a13.log`, `independent_audit_results.json` | GPT's recorded run of `independent_audit.py`. |
| `a4_all222.log`, `a4_all222_results.json`, `a4_all222.txt`, `a4_sample45.txt` | GPT's recorded LRAT replay of all 222 cubes. Totals: 4,619,781 additions and 7,766,513 deleted IDs. |
| `negative_controls.log` | GPT's recorded negative controls. |
| `original/` | The files exactly as GPT delivered them, with `AUDIT_SHA256SUMS` (which also lists GPT's review report; that report is not included here). |

**Release adaptation.** The three scripts outside `original/` differ from the originals only in how they locate files. `diff original/independent_audit.py independent_audit.py` shows this, and the same holds for the other two scripts. In the release layout the JSON and LRAT archives are both in `../certs/`. The first-party result list is `../logs/first_party_results.tsv`.

**Re-run by Claude.** Claude ran both checkers on the archived files and obtained the same totals: A1–A3 PASS for 222 certificates and 2,333,853 hyperedges, and A4 PASS 222/222. A proof with one RUP hint removed was rejected. Section `l11k13ind` of `verify_all.sh` runs the adapted scripts.

Scope: these runs are a second, independently written implementation and a computational replay. They are not peer review, and the human author has not personally checked every step. The `k = 12` certificate (`../../k12`) was not part of this replay.
