# Second-party checker for the 14,723 per-window certificates (GPT, 7 November 2026)

GPT (OpenAI) wrote `gpt_r9_check.py` and `r9_math_audit.py` from a written specification of the data formats (window strings, hyperedge lines, the CNF numbering and the LRAT format), without access to the project's `mkcnfw.py` or `replay_perwin.py`. The files here are byte-identical to the ones GPT delivered; `SHA256SUMS` is GPT's own list.

**Division of work, stated plainly.** GPT wrote the checker. Claude ran it, unmodified, on the archived data and sent the logs and hashes back to GPT, which reviewed them. GPT did not run the checker on the full data set itself, because the data (about 1 GB uncompressed) could not be transferred to it. So this is an independently written implementation executed by the first party, not an independent execution by the second party.

| file | role |
|---|---|
| `gpt_r9_check.py` | Standard library only. For each of the 23 groups: checks the `DONE` line (ℓ, e, N, survivor count), the survivor and per-window lists (survivors ∪ the 2ℓ windows with j = 1 when e ≤ 2), the hyperedge keys and the proof file names; re-validates every hyperedge from the definition (ℓ distinct values, multiplicities summing to k, Σ mᵢvᵢ = w, w not a summand, all in [1, N]); builds the CNF (2ℓ unit clauses, then two clauses per hyperedge); replays the LRAT proof with its own pure-RUP checker (positive hints only, deletions tracked, clause ids strictly increasing, empty clause required). `--selftest` copies group `l12` (e = 1) and checks that the pristine copy passes and that nine tamperings are rejected; the "proof from another window" and "hyperedge removed" tamperings are pre-tested so that only a tampering that actually breaks the proof is counted. |
| `r9_math_audit.py` | SymPy checks of the identities of §8.2 (w*(P_j), G_P, w*(P_j) − V₃, the discrete gap of Lemma 27, the four low-window expansions of Lemma 28), of the discriminant coefficients of Theorem 29 and of e_P(ℓ) for 9 ≤ ℓ ≤ 54; then an exhaustive check of Lemma 28 against the exact minimum w* for small ℓ. Needs SymPy. |
| `extra_tamper.py` | Written by Claude. Calls GPT's `worker` on the largest proof (N = 4861, red = [1, 4], 83,357 hyperedges, 281,363 LRAT lines) and on seven tamperings of it. |
| `logs/selftest.log` | Claude's run of `--selftest`: pristine 90/90 accepted, 9/9 tamperings rejected, exit 0. |
| `logs/gpt_r9_full.log` | Claude's run on all 23 groups: `TOTAL pass=14723 fail=0`, exit 0, 3 minutes with 2 processes. |
| `logs/math_audit.log` | Claude's run of `r9_math_audit.py --min-l 6 --max-l 8 --es 1,2,3`: all symbolic checks pass; exhaustive ℓ = 6, 7, 8, no counterexample. The `ADMISSIBLE_NOT_GOOD` lines are the point GPT raised about the wording of the low windows (the tuples are admissible, not necessarily good); the paper was corrected. |
| `logs/extra_tamper.log` | 7/7 tamperings rejected. |

Run them from the repository root:

```
python3 -I evidence/oq64_exact/independent_review_gpt/gpt_r9_check.py evidence/oq64_exact --selftest
python3 -I evidence/oq64_exact/independent_review_gpt/gpt_r9_check.py evidence/oq64_exact --jobs 2
python3 -I evidence/oq64_exact/independent_review_gpt/r9_math_audit.py --min-l 6 --max-l 8 --es 1,2,3
python3 -I evidence/oq64_exact/independent_review_gpt/extra_tamper.py evidence/oq64_exact/independent_review_gpt evidence/oq64_exact
```

Section `exactind` of `verify_all.sh` runs the first, the second and a shorter form of the third.

Scope: this is a second, independently written implementation and a computational replay by the first party. It is not peer review, and the human author has not personally checked every step. GPT's round-8 work (its own enumeration of all windows for ℓ = 12, 13 and of the reduced windows for ℓ ≤ 20, the re-check of 4,004,355 hyperedges, and 1,009 certificate CNFs decided with Z3) is described in Appendix A of the preprint; its files are not included here.
