# Verification logs, release v1.0

* `verify_all_v1.0.log`: complete output of `./verify_all.sh all`, run on 28 October 2026 22:32–22:56 (UTC+8) from this
  package. The first line is the SHA-256 of the `verify_all.sh` that was run, and the last lines are `EXIT 0` and the end time.
* `negative_controls_v1.0.log`: output of `tests/negative_controls.sh`. All 11 tampered inputs and fake checkers were rejected.
* `checker_outputs_v1.0.tar.xz`: the raw outputs of `lrat-check` and `cake_lpr` for every proof (`LOGDIR`).

The environment was Linux x86-64 with the checker builds listed in the main README. Absolute paths were replaced by
`<PACKAGE>`, `<TOOLS>` and `<SCRATCH>`. These are first-party runs, executed within this project.

# Verification logs, release v1.1 (added 1 November 2026)

* `verify_all_v1.1_l11k13.log`: output of `./verify_all.sh l11k13 l11k13ind` (the new Result 4 sections), run on 1 November 2026, 11:24–11:54 (UTC+8). It begins with the SHA-256 of the `verify_all.sh` that was run and ends with `EXIT 0`.
* `negative_controls_v1.1.log`: output of the extended `tests/negative_controls.sh`. All 15 cases were rejected.
* The v1.0 sections were not re-run for v1.1, because their certificate files are byte-identical to v1.0 (compare `MANIFEST.sha256`). The only change to the code they use is the new section list in `verify_all.sh`.

These are first-party runs (Claude), with the same checker builds as for v1.0.
