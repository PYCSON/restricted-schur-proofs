#!/usr/bin/env bash
# Replay every certificate behind the main claims of the preprint.
# Requirements: python3 (with sympy), xz, and the two LRAT checkers:
#   LRAT_CHECK = path to lrat-check (drat-trim distribution)
#   CAKE_LPR   = path to cake_lpr (formally verified checker)
# Usage:  LRAT_CHECK=/path/lrat-check CAKE_LPR=/path/cake_lpr ./verify_all.sh [section ...]
# Sections: oq62 oq64sym oq64single diag l11k12   (default: all)
# Every step prints PASS or stops with an error. Expect several hours in total (cert_10_12 is the largest).
set -euo pipefail
: "${LRAT_CHECK:?set LRAT_CHECK}"; : "${CAKE_LPR:?set CAKE_LPR}"
ROOT=$(cd "$(dirname "$0")" && pwd); EV=$ROOT/evidence
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
HEAP=${CAKE_HEAP:-4000}

lrat() { # lrat <cnf> <lrat.xz>
  xz -dc "$2" > "$W/p.lrat"
  "$LRAT_CHECK" "$1" "$W/p.lrat" > "$W/lc.out" 2>&1 || true
  grep -q "c VERIFIED" "$W/lc.out" || { echo "FAIL lrat-check $1"; tail -3 "$W/lc.out"; exit 1; }
  "$CAKE_LPR" --CML_HEAP_SIZE=$HEAP --CML_STACK_SIZE=500 "$1" "$W/p.lrat" > "$W/ck.out" 2>&1 || true
  grep -q "s VERIFIED UNSAT" "$W/ck.out" || { echo "FAIL cake_lpr $1"; tail -3 "$W/ck.out"; exit 1; }
  echo "  PASS lrat-check + cake_lpr: $(basename "$1")"; rm -f "$W/p.lrat"
}
unxz_to() { case "$1" in *.xz) xz -dc "$1" > "$2";; *) cp "$1" "$2";; esac; }
sel() { [ $# -eq 0 ] && return 0; for s in "$@"; do [ "$s" = "$SECTION" ] && return 0; done; return 1; }
ARGS=("$@")

SECTION=oq62; if sel "${ARGS[@]}"; then
  echo "== OQ 6.2: S_3(k;2) <= k^3+3k^2+2k-2 for k>=8 (seven symbolic cases)"
  ( cd "$EV/ub_cert" && python3 check_kernel.py uni_const1 uni_const2 uni_const3 uni_top0 uni_top1 uni_top2 bi_mid )
  for c in uni_const1 uni_const2 uni_const3 uni_top0 uni_top1 uni_top2 bi_mid; do lrat "$EV/ub_cert/$c.cnf" "$EV/ub_cert/$c.lrat.xz"; done
  echo "== OQ 6.2: 3<=k<=7, direct CNFs at n=F(k) (regenerated from the definition and compared)"
  for kn in 3:58 4:118 5:208 6:334 7:502; do k=${kn%:*}; n=${kn#*:}
    ( cd "$W" && python3 "$EV/s3k2/s3k2.py" --cnf-only 3 $k $n > /dev/null )
    cmp -s "$W/s3_${k}_${n}.cnf" "$EV/s3k2/s3_${k}_${n}.cnf" && echo "  PASS CNF regenerated identically: s3_${k}_${n}.cnf" || { echo "FAIL CNF mismatch k=$k"; exit 1; }
    lrat "$EV/s3k2/s3_${k}_${n}.cnf" "$EV/s3k2/s3_${k}_${n}.lrat.xz"
  done
fi

SECTION=oq64sym; if sel "${ARGS[@]}"; then
  echo "== OQ 6.4: symbolic certificates (valid for all k >= k0)"
  for b in cert_3_3 cert_4_4 cert_5_6 cert_6_7 cert_7_8 cert_8_10 cert_9_11 cert_10_12 certeq_5_5 certeq_6_6 certeq_7_7; do
    for ext in json cnf; do f="$EV/oq64_kernel/$b.$ext"; [ -f "$f" ] || f="$f.xz"; unxz_to "$f" "$W/$b.$ext"; done
    python3 "$EV/oq64_kernel/check_cert.py" "$W/$b.json"
    lrat "$W/$b.cnf" "$EV/oq64_kernel/$b.lrat.xz"; rm -f "$W/$b.json" "$W/$b.cnf"
  done
fi

single() { # single <k> <l> <n> <edges> <cnf> <lrat.xz> [prefix]
  local ref="$W/$(basename "${5%.xz}")"; unxz_to "$4" "$W/e.txt"; unxz_to "$5" "$ref"
  if [ $# -ge 7 ]; then python3 "$EV/oq64_windows/tools/mkcnfw.py" $1 $2 $3 "$W/e.txt" "$W/g.cnf" "$7" | tail -1
  else python3 "$EV/oq64_l8/k9/mkcnf.py" $1 $2 $3 "$W/e.txt" "$W/g.cnf" | tail -1; fi
  cmp -s "$W/g.cnf" "$ref" && echo "  PASS every hyperedge valid; CNF rebuilt identically (k=$1, l=$2, n=$3)" || { echo "FAIL CNF mismatch k=$1 l=$2"; exit 1; }
  lrat "$ref" "$6"; rm -f "$W/e.txt" "$W/g.cnf" "$ref"
}

SECTION=oq64single; if sel "${ARGS[@]}"; then
  echo "== OQ 6.4: single values S_2(9;8)=390, S_2(10;9)=533, S_2(11;10)=707"
  D=$EV/oq64_l8/k9;  single 9 8 390  $D/num_8_9_390.core.edges   $D/num_8_9_390.core.cnf.xz   $D/num_8_9_390.core.lrat.xz
  D=$EV/oq64_l9/k10; single 10 9 533 $D/num_9_10_533.core.edges  $D/num_9_10_533.core.cnf.xz  $D/num_9_10_533.core.lrat.xz
  D=$EV/oq64_l10/k11; single 11 10 707 $D/num_10_11_707.core.edges.xz $D/num_10_11_707.core.cnf.xz $D/num_10_11_707.core.lrat.xz
fi

SECTION=diag; if sel "${ARGS[@]}"; then
  echo "== Diagonal: WS_8(2)=365, WS_9(2)=505, WS_10(2)=676 (upper bounds; lower bounds are Ahmed et al.)"
  D=$EV/oq64_diag
  for kn in 8:365 9:505 10:676; do k=${kn%:*}; n=${kn#*:}; single $k $k $n $D/diag_${k}_${n}.core.edges.xz $D/diag_${k}_${n}.core.cnf.xz $D/diag_${k}_${n}.core.lrat.xz; done
fi

SECTION=l11k12; if sel "${ARGS[@]}"; then
  echo "== l=11: S_2(12;11)=915 (upper bound)"
  D=$EV/oq64_l11/k12; single 12 11 915 $D/core.edges.xz $D/core.cnf.xz $D/core.lrat.xz R
fi

echo "ALL SELECTED SECTIONS PASSED"
