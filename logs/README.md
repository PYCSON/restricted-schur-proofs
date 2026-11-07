# Verification logs, release v1.0

* `verify_all_v1.0.log`: complete output of `./verify_all.sh all`, run on 28 October 2026 22:32–22:56 (UTC+8) from this
  package. The first line is the SHA-256 of the `verify_all.sh` that was run, and the last lines are `EXIT 0` and the end time.
* `negative_controls_v1.0.log`: output of `tests/negative_controls.sh`. All 11 tampered inputs and fake checkers were rejected.
* `checker_outputs_v1.0.tar.xz`: the raw outputs of `lrat-check` and `cake_lpr` for every proof (`LOGDIR`).

The environment was Linux x86-64 with the checker builds listed in the main README. Absolute paths were replaced by
`<PACKAGE>`, `<TOOLS>` and `<SCRATCH>`. These are first-party runs, executed within this project.

# Verification logs, release v1.1 (added 1 November 2026)

* `verify_all_v1.1_l11k13.log`: output of `./verify_all.sh l11k13 l11k13ind` (the new Result 4 sections), run on 1 November 2026, 12:10–12:40 (UTC+8), after the optimised-Python guard was added. It begins with the SHA-256 of the `verify_all.sh` that was run and ends with `EXIT 0` and the start and end times.
* `negative_controls_v1.1.log`: output of the extended `tests/negative_controls.sh`. All 18 cases were rejected.
* The v1.0 sections were not re-run for v1.1, because their certificate files are byte-identical to v1.0 (compare `MANIFEST.sha256`). The only change to the code they use is the new section list in `verify_all.sh`.

These are first-party runs (Claude), with the same checker builds as for v1.0.

# Verification logs, release v1.2 (added 3 November 2026)

* `verify_all_v1.2_asym.log`: output of `./verify_all.sh asym asymind oq62`, run on 3 November 2026, 19:28–19:29 (UTC+8), after the round-7 fixes. It covers the new Result 8 sections. `oq62` was re-run to check that the old sections are unaffected by the changed handling of `LRAT_CHECK`/`CAKE_LPR`. The log begins with the SHA-256 of the `verify_all.sh` that was run and ends with `EXIT 0` and the start and end times.
* `negative_controls_v1.2.log`: output of `tests/negative_controls.sh` with the four new Result 8 controls. All 22 cases were rejected.
* The other sections were not re-run for v1.2, because their certificate files are byte-identical to v1.1 (compare `MANIFEST.sha256`).

These are first-party runs (Claude), with the same checker builds as before. The outputs of GPT's checkers are also stored in `evidence/oq64_asymptotic/independent_review_gpt/`: GPT's own runs in `*.log`, and Claude's re-runs through section `asymind` in the log above.

# Verification logs, release v1.3 (added 8 November 2026)

* `verify_all_v1.3_all.log`: complete output of `./verify_all.sh all` with `JOBS=2`, run on 7 November 2026, 11:35–12:27 (UTC+8), from a fresh clone of the staging commit `ed5dbfa5` (the release commit differs from it only in these logs, `MANIFEST.sha256`, and the final wording of the review verdict and the release date in the documentation; no certificate, script or Lean file changed). It covers every section of v1.0–v1.3 except `exactenumbig`. It begins with the commit hash and the SHA-256 of the `verify_all.sh` that was run and ends with `EXIT_CODE=0` and the end time.
* `negative_controls_v1.3.log`: output of `tests/negative_controls_exact.sh` (17 tampered inputs, fake checkers and wrong expected counts for the v1.3 sections, plus a positive control) followed by `tests/negative_controls.sh` (22 cases), both run from the same fresh clone, 12:27–12:28. Every case was rejected.
* `checker_outputs_v1.3.tar.xz`: the per-section outputs kept by `LOGDIR` (the `replay_perwin.py` summaries for every certificate set, and the outputs of GPT's checker in section `exactind`).
* The large enumerations (`exactenumbig`, about 7 hours) were not re-run from the fresh clone; their byte-for-byte reproductions during production are recorded in `evidence/oq64_exact/README.md` and in the `parts/` directories.

These are first-party runs (Claude), with the same checker builds as before (lrat-check `24a56122…`, cake_lpr `1822ca1e…`). The runs of GPT's independently written checker are in `evidence/oq64_exact/independent_review_gpt/logs/`.
