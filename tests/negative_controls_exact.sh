#!/usr/bin/env bash
# Negative controls for the v1.3 sections (evidence/oq64_exact). Every case below MUST be rejected.
# Usage: LRAT_CHECK=/path/lrat-check CAKE_LPR=/path/cake_lpr tests/negative_controls_exact.sh
set -uo pipefail
: "${LRAT_CHECK:?}"; : "${CAKE_LPR:?}"
ROOT=$(cd "$(dirname "$0")/.." && pwd); X=$ROOT/evidence/oq64_exact; W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
R="python3 -I $X/tools/replay_perwin.py"
bad=0
expect_fail() { local label=$1; shift
  if "$@" > "$W/out" 2>&1; then echo "NOT REJECTED: $label"; bad=$((bad+1)); else echo "rejected (ok): $label -- $(grep -m1 -E 'FAIL|Error' "$W/out" | cut -c1-110)"; fi; }
fresh() { rm -rf "$W/s"; cp -r "$X/l12" "$W/s"; }      # a writable copy of the l=12 set
N1=1160; N2=1254
first=$(head -1 "$X/l12/perwin_l12_e1.txt"); surv1=$(grep -m1 '^SURV' "$X/l12/red_l12_e1.txt" | awk '{print $2}')

fresh; if $R "$W/s" 12 1 $N1 > "$W/out" 2>&1; then echo "positive control (ok): the unmodified copy passes"; else cat "$W/out"; echo "POSITIVE CONTROL FAILED"; exit 1; fi

fresh; xz -dc "$X/l12/proofs_e1/${first}_1.lrat.xz" | head -c 200 | xz > "$W/s/proofs_e1/${first}_1.lrat.xz"
expect_fail "truncated LRAT proof" $R "$W/s" 12 1 $N1

fresh; other=$(sed -n 2p "$X/l12/perwin_l12_e1.txt"); cp "$X/l12/proofs_e1/${other}_1.lrat.xz" "$W/s/proofs_e1/${first}_1.lrat.xz"
expect_fail "proof of another window" $R "$W/s" 12 1 $N1

fresh; python3 - "$W/s/edges_l12_e1.txt.xz" "$first" <<'EOF'
import lzma, sys
f, w = sys.argv[1], sys.argv[2]
lines = lzma.open(f, 'rt').read().splitlines()
out = []
for x in lines:
    key, body = x.split('\t', 1)
    if key == f'{w}_1':
        es = body.split(';'); a, b = es[0].split('|'); es[0] = f'{a}| {int(b) + 1}'; body = ';'.join(es)
    out.append(f'{key}\t{body}')
lzma.open(f, 'wt').write('\n'.join(out) + '\n')
EOF
expect_fail "hyperedge with the sum changed by one" $R "$W/s" 12 1 $N1

fresh; python3 - "$W/s/edges_l12_e1.txt.xz" "$first" <<'EOF'
import lzma, sys
f, w = sys.argv[1], sys.argv[2]
lines = lzma.open(f, 'rt').read().splitlines()
out = []
for x in lines:
    key, body = x.split('\t', 1)
    if key == f'{w}_1': body = ';'.join(body.split(';')[1:])     # drop one hyperedge: the proof no longer fits
    out.append(f'{key}\t{body}')
lzma.open(f, 'wt').write('\n'.join(out) + '\n')
EOF
expect_fail "one hyperedge removed from a CNF" $R "$W/s" 12 1 $N1

fresh; grep -v "^$surv1\$" "$X/l12/perwin_l12_e1.txt" > "$W/s/perwin_l12_e1.txt"
expect_fail "a survivor missing from the per-window list" $R "$W/s" 12 1 $N1

fresh; grep -v "^SURV $surv1 " "$X/l12/red_l12_e1.txt" > "$W/s/red_l12_e1.txt"
expect_fail "a survivor removed from the survivor file (DONE count unchanged)" $R "$W/s" 12 1 $N1

fresh; sed -i 's/ N=1160 / N=1161 /' "$W/s/red_l12_e1.txt"
expect_fail "DONE line with the wrong bound N" $R "$W/s" 12 1 $N1

fresh; expect_fail "replay at a larger bound than the certificates" $R "$W/s" 12 1 $((N1 + 1))

fresh; sed -i "0,/^SURV $surv1 [0-9]*/s//SURV $surv1 0/" "$W/s/red_l12_e1.txt"
expect_fail "survivor with objective 0 (refuted windows must not be listed as survivors)" $R "$W/s" 12 1 $N1

fresh; rm "$W/s/proofs_e1/${first}_1.lrat.xz"
expect_fail "missing proof file" $R "$W/s" 12 1 $N1

fresh; cp "$X/l12/proofs_e2/$(ls "$X/l12/proofs_e2" | head -1)" "$W/s/proofs_e1/RBBBBBBBBBBBBBBBBBBBBBBB_9.lrat.xz"
expect_fail "extra proof file" $R "$W/s" 12 1 $N1

fresh; j1=$(grep -m1 '^RBBBBB' "$X/l12/perwin_l12_e2.txt"); grep -v "^$j1\$" "$X/l12/perwin_l12_e2.txt" > "$W/s/perwin_l12_e2.txt"
expect_fail "a j=1 window missing at e=2" $R "$W/s" 12 2 $N2

printf '#!/bin/sh\necho "c VERIFIED"\nexit 1\n' > "$W/lc"; chmod +x "$W/lc"
fresh; expect_fail "lrat-check prints success but exits 1" env LRAT_CHECK="$W/lc" $R "$W/s" 12 2 $N2
printf '#!/bin/sh\necho "xs VERIFIED UNSAT"\nexit 0\n' > "$W/ck"; chmod +x "$W/ck"
fresh; expect_fail "cake_lpr success text not at line start" env CAKE_LPR="$W/ck" $R "$W/s" 12 2 $N2

printf '#!/bin/sh\nwhile read l e w; do echo 0; done\n' > "$W/fakehill"; chmod +x "$W/fakehill"
python3 -I "$X/fullcheck/full_explicit.py" "$W/fakehill" 8 1 > "$W/fc" 2>&1
if grep -q 'objective mismatches=0' "$W/fc"; then echo "NOT REJECTED: second implementation vs a fake C objective"; bad=$((bad+1)); else echo "rejected (ok): second implementation vs a fake C objective"; fi

python3 -I "$X/lemmaP/asym_upper.py" > "$W/au" 2>&1
if grep -q 'l0=19 c=-7/10: .* not all negative' "$W/au"; then echo "rejected (ok): Theorem Q' upper bound with the constant 1 - 7/10 at l0 = 19"; else echo "NOT REJECTED: c=-7/10"; bad=$((bad+1)); fi

[ "$bad" -eq 0 ] && echo "NEGATIVE CONTROLS (v1.3) PASSED" || { echo "NEGATIVE CONTROLS (v1.3) FAILED: $bad not rejected"; exit 1; }
