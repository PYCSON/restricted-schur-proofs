# Exact thresholds K(12), …, K(20) and the values S₂(20;19), S₂(21;20)

**Status.** Computer-assisted proof candidates, not peer reviewed. The method and the computations are first-party: Claude (Anthropic) designed them, wrote the code and ran it. The second-party review is recorded in the CHANGELOG and in `independent_review_gpt/`. Lemma numbers below refer to the preprint (`paper/`).

Write k = ℓ + e and F = F(k,ℓ), Gaiser's formula. Write V₃(ℓ,e,j) for the three-block value (Proposition 19). The results are these:

| Result | Statement | Certificates |
|---|---|---|
| 9 | K(ℓ) = ℓ+1 for 12 ≤ ℓ ≤ 18 | 5921 per-window certificates |
| 9 | K(19) = 21 and K(20) = 22 | 282 + 536 |
| 10 | S₂(20;19) = 4181 = V₃(19,1,5) > F(20,19) = 4163 | 3558 |
| 10 | S₂(21;20) = 4861 = V₃(20,1,5) > F(21,20) = 4812 | 4426 |

All lower bounds are already in v1.2. The diagonal bound S₂(ℓ;ℓ) > F(ℓ,ℓ) gives K(ℓ) ≥ ℓ+1. The three-block colourings, which are checked in Lean (`lean/OQ64/Three.lean`) and in section `asym`, give K(19) ≥ 21, K(20) ≥ 22, S₂(20;19) ≥ 4181 and S₂(21;20) ≥ 4861.

## Upper bounds: the method

Let χ be a 2-colouring of [1, N] with χ(1) red, and let W = [1, 2ℓ] be its window. Here N = F(k,ℓ) for Result 9, and N = 4181 or 4861 for Result 10.

1. **Balanced windows** (both colours have at least ℓ−1 elements in W) and **the all-red window** are impossible for every e ≥ 1. This follows from the lemmas of §8 that are already in v1.2: the balanced-window proposition, the parity lemmas, and the all-red lemma.
2. **One minority element (j = 1)** is impossible for e ≥ 3 and ℓ ≥ 7 (the j = 1 lemma). For e ≤ 2 the 2ℓ such windows are refuted one by one (step 5).
3. **Minority size 2 ≤ j ≤ ℓ−2.** The T1-fill lemma refutes W as soon as some admissible tuple gives w ≤ N. The other template choices are forced, so the exact minimum w*(W) is a finite minimum. Three facts make the search feasible:
   - **Reduction lemma.** Recolouring every position after m_ℓ to the majority colour cannot decrease w*. So only the *reduced* windows and the windows with at most one low minority element need to be enumerated (`tools/t1red.c`).
   - **Monotonicity in e** (ℓ ≥ 9). With a fixed tuple, w − F(ℓ+e,ℓ) strictly decreases in e. A window refuted at e₀ is therefore refuted at every e ≥ e₀. This lets `tools/t1multi.c` treat a range of e in one pass.
   - **Zero survivors at the top bound.** For every ℓ the enumeration finds no survivor at e = e_P(ℓ) (e_P = 3 for 12 ≤ ℓ ≤ 15, e_P = 4 for 16 ≤ ℓ ≤ 20). Lemma P (below) explains this.
4. **Survivors.** The windows that survive at a given e are listed in `red_l<ℓ>_e<e>.txt`. Each line is `SURV <window> <w*−N>`, and the file ends with a `DONE …` line that holds the counters.
5. **Per-window certificates.** Each survivor, and for e ≤ 2 also each j = 1 window, is refuted separately:
   - a solver records hyperedges (monochromatic solutions) that rule out every extension of the window to [1, N];
   - `../oq64_windows/tools/mkcnfw.py` re-checks every hyperedge and builds the CNF with the window as unit clauses;
   - CaDiCaL proves the CNF UNSAT, producing an LRAT proof (`proofs_e<e>/`);
   - the proof is accepted only if both lrat-check and the formally verified cake_lpr accept it.

## Lemma P and Theorem Q′ (`lemmaP/`)

**Lemma P.** For 1 ≤ e ≤ 2ℓ² − 4ℓ, the largest exact T1-fill minimum over all windows with 2 ≤ j ≤ ℓ−2 is attained at a prefix window (red = [1, j]). The prefix value has a closed form, given in `lemmaP/LEMMA_P.md`, which contains the proof.

**Theorem Q′.** For every ℓ ≥ 19,

  (1+a*)ℓ − 3.63 < K(ℓ) ≤ (1+a*)ℓ + 16 − 11√2 < (1+a*)ℓ + 0.444,   where a* = (√2−1)/2.

The upper bound uses Lemma P; its constant 16 − 11√2 is attained at ℓ = 22 and was found by the second party (GPT). The lower bound uses only the three-block family. Theorem 18 of v1.2 gave the window (−4, +5) for ℓ ≥ 50.

The computations agree with Lemma P. For every ℓ and e enumerated, the largest surviving objective equals the prefix objective. Examples: 72 at ℓ = 19, e = 3; 238 and 106 at ℓ = 20, e = 2, 3; 300 for S₂(20;19); 326 for S₂(21;20).

## Directory layout

| Path | Contents |
|---|---|
| `l10/`, `l11/` | Survivor files used only to validate the tools |
| `l12/` … `l18/` | Survivor files `red_l<ℓ>_e<e>.txt` for e = 1 … e_P; per-window lists `perwin_l<ℓ>_e<e>.txt`; hyperedges `edges_l<ℓ>_e<e>.txt.xz`; proofs `proofs_e<e>/<window>_<e>.lrat.xz`; the production log `res_l<ℓ>.tsv` (one line per window: status, solver line, mkcnfw line). `l12/exhaustive/`, `l13/exhaustive/` hold the survivors of a brute-force run over all 2^(2ℓ−1) windows, which are identical. |
| `l19/`, `l20/` | The same for e = 2 … 5. The enumeration ran in segments (`parts/`); they were merged with `tools/t1combine.py` |
| `S2_20_19/`, `S2_21_20/` | The same at the fixed bound N = 4181 or 4861 (e = 1) |
| `tools/` | Enumeration and replay code (see below) |
| `lemmaP/` | Lemma P, Theorem Q/Q′, and their checks and logs |
| `fullcheck/` | A second implementation of the T1-fill decision, run on every window for ℓ = 9, 10, 11 |
| `independent_review_gpt/` | The second party's (GPT) separately written checker and SymPy audit, as delivered, with the logs of Claude's runs (see its README) |

**Tools.**
- `tools/replay_perwin.py` replays one set of certificates. It fails closed if any of the following does not hold:
  - the survivor file is well formed and its `DONE` line has the right ℓ, e and N;
  - the per-window list equals survivors ∪ {j = 1 windows when e ≤ 2};
  - there is exactly one hyperedge entry and one proof per listed window;
  - for every window, mkcnfw reports bad=0, lrat-check prints `c VERIFIED` and cake_lpr prints `s VERIFIED UNSAT`.
- `tools/t1red.c`, `tools/t1multi.c` and `tools/t1combine.py` reproduce the survivor files.
- `tools/t1multi_v1.c` and `tools/t1multi_v2seg.c` are the exact sources of the binaries used for ℓ = 18 and for ℓ = 19, 20 and Result 10. `t1multi.c` adds options without changing the computation.
- `tools/perwin_cert.py` and `tools/perwin_certN.py` are the production scripts. Their tool paths are those of the original machine.
- `tools/regen_proofs.py` regenerated the stored proofs from the stored hyperedges after the production run, with CaDiCaL 3.0.1, so that each proof can be stored and replayed. The production run had already checked every certificate with both checkers (`res_*.tsv`).
- In the production scripts the paths of the original machine are replaced by the placeholders `<TOOLS>`, `<REPO>`, `<WORKDIR>` and `<PRIVATE_EVIDENCE>`. These scripts are records of how the data were produced and are not needed for verification.

## Replay

```
LRAT_CHECK=/path/lrat-check CAKE_LPR=/path/cake_lpr JOBS=4 ./verify_all.sh exact12 exact13 exact14 exact15 exactenum lemmap exactind
LRAT_CHECK=… CAKE_LPR=… JOBS=4 ./verify_all.sh exact16 exact17 exact18 exact19 exact20 s2_20_19 s2_21_20
./verify_all.sh exactenumbig      # several hours: re-runs the enumerations for l >= 17 and at N = 4181, 4861
```

`exactenum` recompiles the C tools with gcc. It then re-runs the enumeration for 10 ≤ ℓ ≤ 16, compares every survivor file byte for byte, checks the prefix closed form, and runs the second implementation (`fullcheck/`) on all windows for ℓ = 9, 10.
