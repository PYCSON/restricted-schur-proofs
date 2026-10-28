# Verification logs, release v1.0

* `verify_all_v1.0.log`: complete output of `./verify_all.sh all`, run on 28 October 2026 22:32–22:56 (UTC+8) from this
  package. The first line is the SHA-256 of the `verify_all.sh` that was run, and the last lines are `EXIT 0` and the end time.
* `negative_controls_v1.0.log`: output of `tests/negative_controls.sh`. All 11 tampered inputs and fake checkers were rejected.
* `checker_outputs_v1.0.tar.xz`: the raw outputs of `lrat-check` and `cake_lpr` for every proof (`LOGDIR`).

The environment was Linux x86-64 with the checker builds listed in the main README. Absolute paths were replaced by
`<PACKAGE>`, `<TOOLS>` and `<SCRATCH>`. These are first-party runs, executed within this project.
