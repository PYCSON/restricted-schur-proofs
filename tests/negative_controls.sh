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

[ $bad -eq 0 ] && echo "ALL NEGATIVE CONTROLS REJECTED" || { echo "$bad negative control(s) NOT rejected"; exit 1; }
