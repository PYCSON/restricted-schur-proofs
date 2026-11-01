#!/usr/bin/env bash
# Negative controls for verify_all.sh and the checkers. Every case below MUST be rejected.
# Usage: LRAT_CHECK=/path/lrat-check CAKE_LPR=/path/cake_lpr tests/negative_controls.sh
set -uo pipefail
: "${LRAT_CHECK:?}"; : "${CAKE_LPR:?}"
ROOT=$(cd "$(dirname "$0")/.." && pwd); EV=$ROOT/evidence; W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
bad=0
expect_fail() { # expect_fail <label> <command...>
  local label=$1; shift
  if "$@" > "$W/out" 2>&1; then echo "NOT REJECTED: $label"; bad=$((bad+1)); else echo "rejected (ok): $label"; fi
}
mk() { printf '#!/bin/sh\necho "%s"\nexit %s\n' "$2" "$3" > "$W/$1"; chmod +x "$W/$1"; }
mk lc_rc1 "c VERIFIED" 1;        mk lc_txt "c NOT VERIFIED" 0
mk ck_rc1 "s VERIFIED UNSAT" 1;  mk ck_txt "c Checking failed at line: 16" 0;  mk ck_pre "xs VERIFIED UNSAT" 0

expect_fail "lrat-check prints success but exits 1" env LRAT_CHECK="$W/lc_rc1" CAKE_LPR="$CAKE_LPR" "$ROOT/verify_all.sh" oq62
expect_fail "lrat-check exits 0 without success line" env LRAT_CHECK="$W/lc_txt" CAKE_LPR="$CAKE_LPR" "$ROOT/verify_all.sh" oq62
expect_fail "cake_lpr prints success but exits 1"     env LRAT_CHECK="$LRAT_CHECK" CAKE_LPR="$W/ck_rc1" "$ROOT/verify_all.sh" oq62
expect_fail "cake_lpr exits 0 with failure text"     env LRAT_CHECK="$LRAT_CHECK" CAKE_LPR="$W/ck_txt" "$ROOT/verify_all.sh" oq62
expect_fail "cake_lpr success text not at line start" env LRAT_CHECK="$LRAT_CHECK" CAKE_LPR="$W/ck_pre" "$ROOT/verify_all.sh" oq62
expect_fail "unknown section name"                  env LRAT_CHECK="$LRAT_CHECK" CAKE_LPR="$CAKE_LPR" "$ROOT/verify_all.sh" nonsense

# Real checkers on a truncated proof: lrat-check must exit non-zero; cake_lpr must not print the success line.
xz -dc "$EV/oq64_kernel/cert_3_3.lrat.xz" | head -c 300 > "$W/trunc.lrat"
expect_fail "lrat-check on truncated proof" "$LRAT_CHECK" "$EV/oq64_kernel/cert_3_3.cnf" "$W/trunc.lrat"
"$CAKE_LPR" --CML_HEAP_SIZE=2000 --CML_STACK_SIZE=500 "$EV/oq64_kernel/cert_3_3.cnf" "$W/trunc.lrat" > "$W/ck" 2>&1 || true
if grep -Eq '^s VERIFIED UNSAT' "$W/ck"; then echo "NOT REJECTED: cake_lpr on truncated proof"; bad=$((bad+1)); else echo "rejected (ok): cake_lpr on truncated proof"; fi

# A tampered hyperedge (sum changed by one) must be reported as invalid by the edge checker.
head -1 "$EV/oq64_l8/k9/num_8_9_390.core.edges" | awk -F'|' '{printf "%s| %d\n", $1, $2+1}' > "$W/t.edges"
python3 "$EV/oq64_l8/k9/mkcnf.py" 9 8 390 "$W/t.edges" "$W/t.cnf" > "$W/mk" 2>&1 || true
if grep -q 'bad=0 ' "$W/mk"; then echo "NOT REJECTED: tampered hyperedge"; bad=$((bad+1)); else echo "rejected (ok): tampered hyperedge ($(tail -1 "$W/mk"))"; fi

# A tampered symbolic certificate (one identity coefficient changed) must fail check_cert.py.
python3 - "$EV/oq64_kernel/cert_3_3.json" "$W/cert_3_3.json" <<'EOF'
import json,sys; c=json.load(open(sys.argv[1])); c['edges'][0]['c']+=1; json.dump(c,open(sys.argv[2],'w'))
EOF
cp "$EV/oq64_kernel/cert_3_3.cnf" "$W/cert_3_3.cnf"
expect_fail "tampered symbolic certificate" python3 "$EV/oq64_kernel/check_cert.py" "$W/cert_3_3.json"

# Result 6 must fail closed: in an isolated copy with one extremal colouring removed, section `unique` must fail.
C="$W/copy"; mkdir -p "$C/evidence/oq64_l8/k9"; cp "$ROOT/verify_all.sh" "$C/"
cp -r "$EV/oq64_structure" "$C/evidence/"; cp "$EV/oq64_l8/k9/checkgood.py" "$C/evidence/oq64_l8/k9/"
rm "$C/evidence/oq64_structure/g_5_7.good"
expect_fail "section unique with one of the 12 colourings missing" env LRAT_CHECK="$LRAT_CHECK" CAKE_LPR="$CAKE_LPR" "$C/verify_all.sh" unique

# Result 4, K(11)=12 cube family (section l11k13 and the second-party checker l11k13ind).
K=$EV/oq64_l11/k13_cubes
# (a) one cube removed: the remaining prefixes no longer cover all colourings.
mkdir -p "$W/parts"; cp "$K"/certs/certC*_11_13.*.xz "$W/parts/"; rm "$W/parts/certC0110100_11_13.json.xz" "$W/parts/certC0110100_11_13.lrat.xz"
[ "$(ls "$W/parts" | wc -l)" -eq 442 ] || { echo "could not build the partition sample"; exit 1; }
expect_fail "cube partition with one cube removed" python3 "$K/check_partition.py" "$W/parts"
# (b) a cube unit whose colour contradicts the prefix.
xz -dc "$K/certs/certC0110100_11_13.json.xz" > "$W/cube.json"
python3 - "$W/cube.json" "$W/cube_bad.json" <<'PYEOF'
import json,sys; c=json.load(open(sys.argv[1])); u=[x for x in c['cube_units'] if x[0]!=c['unit_red']][0]; u[1]=1-u[1]; json.dump(c,open(sys.argv[2],'w'))
PYEOF
[ -s "$W/cube_bad.json" ] || { echo "could not build the flipped-unit sample"; exit 1; }
expect_fail "cube unit colour flipped against the prefix" python3 "$K/check_cube.py" "$W/cube_bad.json" 0110100 "$W/b.cnf" "$W/bc.cnf"
# (c) a certificate presented under another prefix.
expect_fail "cube certificate used for a different prefix" python3 "$K/check_cube.py" "$W/cube.json" 0110101 "$W/b.cnf" "$W/bc.cnf"
# (d) the second-party LRAT checker on a proof with its last line (the empty clause) removed.
mkdir -p "$W/ind"; cp "$K/certs/certC0110100_11_13.json.xz" "$W/ind/"
xz -dc "$K/certs/certC0110100_11_13.lrat.xz" | sed '$d' | xz -c > "$W/ind/certC0110100_11_13.lrat.xz"
[ -s "$W/ind/certC0110100_11_13.lrat.xz" ] || { echo "could not build the truncated-proof sample"; exit 1; }
expect_fail "independent LRAT checker on a proof without the empty clause" python3 "$K/independent_review/independent_lrat.py" --certs "$W/ind" 0110100

# (e) Python optimisation (-O / PYTHONOPTIMIZE) removes assert statements: every entry point must refuse it.
expect_fail "independent symbolic audit rejects Python optimization" env PYTHONOPTIMIZE=1 python3 "$K/independent_review/independent_audit.py" "$K" "$W/optimized_audit.json"
expect_fail "independent LRAT replay rejects Python optimization" env PYTHONOPTIMIZE=1 python3 "$K/independent_review/independent_lrat.py" --certs "$K/certs" 0110100
expect_fail "verify_all rejects Python optimization" env PYTHONOPTIMIZE=1 LRAT_CHECK="$LRAT_CHECK" CAKE_LPR="$CAKE_LPR" "$ROOT/verify_all.sh" l11k13ind

[ $bad -eq 0 ] && echo "ALL NEGATIVE CONTROLS REJECTED" || { echo "$bad negative control(s) NOT rejected"; exit 1; }
