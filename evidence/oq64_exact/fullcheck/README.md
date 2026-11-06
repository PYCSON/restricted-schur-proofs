# Full second-implementation check of the T1-fill decision (Claude, 2026-11-06)

`full_explicit.py T1HILL l e` (T1HILL = a compiled `tools/t1hill.c`) covers every window of [1, 2ℓ] with 2 ≤ j ≤ ℓ−2. For each window it:
- compares the C objective (`t1hill C`, the same evalw logic as t1red and t1multi) with the minimum computed by the separately written Python code `t1fill_witness.best_w` from the v1.2 asymptotic evidence;
- for every window the C code calls refuted, builds the explicit T1-fill hyperedges with `t1fill_witness.verify` and checks that the chain closes (CLASH).

Results (`full_explicit_l9_11.log`, and `full_explicit_l11_e3.log` from a separate run) cover ℓ = 9, 10, 11 with e = 1, 2, 3:
- 0 objective mismatches;
- every refuted window has a closing explicit chain;
- the survivor counts equal those in the archived `red_l*_e*.txt`.

The first run hit the 2-hour container limit during ℓ=11, e=3. That case was then run on its own.
