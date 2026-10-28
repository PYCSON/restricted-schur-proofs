#!/usr/bin/env bash
# Replay the certificates behind Results 1-4, 6 and 7 of README.md (Result 5 and the Lean developments: see README).
# Requirements: python3 (with sympy), xz, and the two LRAT checkers:
#   LRAT_CHECK = path to lrat-check (drat-trim distribution)
#   CAKE_LPR   = path to cake_lpr (formally verified checker)
# Usage:  LRAT_CHECK=/path/lrat-check CAKE_LPR=/path/cake_lpr ./verify_all.sh [section ...]
# Sections: oq62 oq64sym oq64single diag l11k12 unique windows
#   (default: oq62 oq64sym oq64single diag l11k12; "all" adds unique and windows)
# Optional: CAKE_HEAP (MB, default 4000); LOGDIR (keep every checker output there instead of deleting it).
# A step passes only if the checker exits with status 0 AND prints its exact success line
# ("c VERIFIED" for lrat-check, "s VERIFIED UNSAT" for cake_lpr). Any failure stops the script with status 1.
set -euo pipefail
: "${LRAT_CHECK:?set LRAT_CHECK}"; : "${CAKE_LPR:?set CAKE_LPR}"
ROOT=$(cd "$(dirname "$0")" && pwd); EV=$ROOT/evidence
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
HEAP=${CAKE_HEAP:-4000}; LOGDIR=${LOGDIR:-}
[ -n "$LOGDIR" ] && mkdir -p "$LOGDIR"

DEFAULT=(oq62 oq64sym oq64single diag l11k12); ALL=("${DEFAULT[@]}" unique windows)
ARGS=("$@"); [ ${#ARGS[@]} -eq 0 ] && ARGS=("${DEFAULT[@]}")
[ "${ARGS[*]}" = "all" ] && ARGS=("${ALL[@]}")
for requested in "${ARGS[@]}"; do
  case " ${ALL[*]} " in *" $requested "*) ;; *) echo "Unknown section: $requested (valid: ${ALL[*]} all)" >&2; exit 2;; esac
done
RAN=0
want() { for s in "${ARGS[@]}"; do [ "$s" = "$1" ] && { RAN=$((RAN+1)); return 0; }; done; return 1; }
fail() { echo "FAIL: $*" >&2; exit 1; }
keep() { [ -n "$LOGDIR" ] && cp "$1" "$LOGDIR/$2" || true; }

lrat() { # lrat <cnf> <lrat.xz> : both checkers must accept
  local tag; tag=$(basename "$1" .cnf)
  xz -dc "$2" > "$W/p.lrat"
  local rc=0; "$LRAT_CHECK" "$1" "$W/p.lrat" > "$W/lc.out" 2>&1 || rc=$?
  keep "$W/lc.out" "$tag.lrat-check.log"
  [ $rc -eq 0 ] || { cat "$W/lc.out" >&2; fail "lrat-check exited with status $rc: $1"; }
  grep -Eq '^c VERIFIED[[:space:]]*$' "$W/lc.out" || { cat "$W/lc.out" >&2; fail "lrat-check did not report 'c VERIFIED': $1"; }
  rc=0; "$CAKE_LPR" --CML_HEAP_SIZE="$HEAP" --CML_STACK_SIZE=500 "$1" "$W/p.lrat" > "$W/ck.out" 2>&1 || rc=$?
  keep "$W/ck.out" "$tag.cake_lpr.log"
  [ $rc -eq 0 ] || { cat "$W/ck.out" >&2; fail "cake_lpr exited with status $rc: $1"; }
  grep -Eq '^s VERIFIED UNSAT[[:space:]]*$' "$W/ck.out" || { cat "$W/ck.out" >&2; fail "cake_lpr did not report 's VERIFIED UNSAT': $1"; }
  echo "  PASS lrat-check + cake_lpr: $tag"; rm -f "$W/p.lrat"
}
unxz_to() { case "$1" in *.xz) xz -dc "$1" > "$2";; *) cp "$1" "$2";; esac; }
F2() { echo $(( $1*$1 + (($2+1)*($2-2)/2+2)*$1 + $2*($2-2) )); }   # F(k,l)

single() { # single <k> <l> <n> <edges> <cnf> <lrat.xz> [prefix [tag]]
  local ref="$W/${8:-$(basename "${5%.xz}" .cnf)}.cnf"; unxz_to "$4" "$W/e.txt"; unxz_to "$5" "$ref"
  if [ $# -ge 7 ]; then python3 "$EV/oq64_windows/tools/mkcnfw.py" "$1" "$2" "$3" "$W/e.txt" "$W/g.cnf" "$7" > "$W/mk.out"
  else python3 "$EV/oq64_l8/k9/mkcnf.py" "$1" "$2" "$3" "$W/e.txt" "$W/g.cnf" > "$W/mk.out"; fi
  grep -Eq 'bad=0 ' "$W/mk.out" || { cat "$W/mk.out" >&2; fail "invalid hyperedge (k=$1 l=$2 n=$3)"; }
  cmp -s "$W/g.cnf" "$ref" || fail "regenerated CNF differs from $5"
  [ -z "${QUIET:-}" ] && echo "  PASS $(tail -1 "$W/mk.out"); CNF rebuilt identically (k=$1, l=$2, n=$3)"
  lrat "$ref" "$6"; rm -f "$W/e.txt" "$W/g.cnf" "$ref"
}

if want oq62; then
  echo "== Result 1 (OQ 6.2): S_3(k;2) <= k^3+3k^2+2k-2 for k>=8 (seven symbolic cases)"
  ( cd "$EV/ub_cert" && python3 check_kernel.py uni_const1 uni_const2 uni_const3 uni_top0 uni_top1 uni_top2 bi_mid )
  for c in uni_const1 uni_const2 uni_const3 uni_top0 uni_top1 uni_top2 bi_mid; do lrat "$EV/ub_cert/$c.cnf" "$EV/ub_cert/$c.lrat.xz"; done
  echo "== Result 1: 3<=k<=7, CNFs at n=F(k) regenerated from the definition and compared"
  for kn in 3:58 4:118 5:208 6:334 7:502; do k=${kn%:*}; n=${kn#*:}
    ( cd "$W" && python3 "$EV/s3k2/s3k2.py" --cnf-only 3 "$k" "$n" > /dev/null )
    cmp -s "$W/s3_${k}_${n}.cnf" "$EV/s3k2/s3_${k}_${n}.cnf" || fail "CNF mismatch k=$k"
    echo "  PASS CNF regenerated identically: s3_${k}_${n}"
    lrat "$EV/s3k2/s3_${k}_${n}.cnf" "$EV/s3k2/s3_${k}_${n}.lrat.xz"
  done
fi

if want oq64sym; then
  echo "== Result 2 (OQ 6.4): symbolic certificates, valid for all k >= k0 (certeq_*: WS_5..WS_7 re-proved)"
  for b in cert_3_3 cert_4_4 cert_5_6 cert_6_7 cert_7_8 cert_8_10 cert_9_11 cert_10_12 certeq_5_5 certeq_6_6 certeq_7_7; do
    for ext in json cnf; do f="$EV/oq64_kernel/$b.$ext"; [ -f "$f" ] || f="$f.xz"; unxz_to "$f" "$W/$b.$ext"; done
    python3 "$EV/oq64_kernel/check_cert.py" "$W/$b.json"
    lrat "$W/$b.cnf" "$EV/oq64_kernel/$b.lrat.xz"; rm -f "$W/$b.json" "$W/$b.cnf"
  done
fi

if want oq64single; then
  echo "== Result 2: single values S_2(9;8)=390, S_2(10;9)=533, S_2(11;10)=707"
  D=$EV/oq64_l8/k9;   single 9 8 390   "$D/num_8_9_390.core.edges"      "$D/num_8_9_390.core.cnf.xz"   "$D/num_8_9_390.core.lrat.xz"
  D=$EV/oq64_l9/k10;  single 10 9 533  "$D/num_9_10_533.core.edges"     "$D/num_9_10_533.core.cnf.xz"  "$D/num_9_10_533.core.lrat.xz"
  D=$EV/oq64_l10/k11; single 11 10 707 "$D/num_10_11_707.core.edges.xz" "$D/num_10_11_707.core.cnf.xz" "$D/num_10_11_707.core.lrat.xz"
fi

if want diag; then
  echo "== Result 3: WS_8(2)<=365, WS_9(2)<=505, WS_10(2)<=676 (lower bounds: Ahmed et al. 2023)"
  D=$EV/oq64_diag
  for kn in 8:365 9:505 10:676; do k=${kn%:*}; n=${kn#*:}
    single "$k" "$k" "$n" "$D/diag_${k}_${n}.core.edges.xz" "$D/diag_${k}_${n}.core.cnf.xz" "$D/diag_${k}_${n}.core.lrat.xz"; done
fi

if want l11k12; then
  echo "== Result 4: S_2(12;11)<=915"
  D=$EV/oq64_l11/k12; single 12 11 915 "$D/core.edges.xz" "$D/core.cnf.xz" "$D/core.lrat.xz" R
fi

if want unique; then
  echo "== Result 6: uniqueness of the good colouring of [1,F(k,l)-1] (files u_<l>_<k>, g_<l>_<k>)"
  D=$EV/oq64_structure
  expected=(3_3 3_4 4_5 5_6 5_7 6_7 6_8 7_8 7_9 8_9 9_10 10_11)   # (l,k) of Proposition 11 / README Result 6
  [ "$(find "$D" -maxdepth 1 -type f -name 'g_*_*.good' | wc -l)" -eq "${#expected[@]}" ] || fail "Result 6: expected exactly ${#expected[@]} extremal colourings"
  for pair in "${expected[@]}"; do
    g="$D/g_${pair}.good"; [ -s "$g" ] || fail "Result 6: missing or empty $g"
    [ -s "$D/u_${pair}.edges.xz" ] && [ -s "$D/u_${pair}.lrat.xz" ] || fail "Result 6: missing certificate files for $pair"
    b="g_${pair}"; l=${pair%%_*}; k=${pair##*_}; n=$(( $(F2 "$k" "$l") - 1 ))
    python3 "$EV/oq64_l8/k9/checkgood.py" "$k" "$l" "$n" "$g" > "$W/cg.out" || { cat "$W/cg.out" >&2; fail "colouring $b is not good"; }
    grep -qx GOOD "$W/cg.out" || { cat "$W/cg.out" >&2; fail "checkgood $b"; }
    xz -dc "$D/u_${l}_${k}.edges.xz" > "$W/e.txt"
    python3 "$D/mkcnf_block.py" "$k" "$l" "$n" "$W/e.txt" "$g" "$W/u_${l}_${k}.cnf" > "$W/mk.out"
    grep -Eq 'bad=0' "$W/mk.out" || { cat "$W/mk.out" >&2; fail "invalid hyperedge in u_${l}_${k}"; }
    echo "  PASS (k=$k, l=$l, n=$n): colouring is good; $(tail -1 "$W/mk.out")"
    lrat "$W/u_${l}_${k}.cnf" "$D/u_${l}_${k}.lrat.xz"; rm -f "$W/e.txt" "$W/u_${l}_${k}.cnf"
  done
fi

if want windows; then
  echo "== Result 7: window certificates W_j (1470 cases; prints one line per directory group)"
  D=$EV/oq64_windows; cnt=0
  while IFS= read -r d; do
    name=$(basename "$d"); e=1
    case "$d" in */wj_certs_e2_5/e*/W_*) e=$(basename "$(dirname "$d")" | tr -dc 0-9);; */wj_certs_gap/e*_W_*) e=${name%%_*}; e=${e#e}; name=${name#*_};; esac
    l=$(echo "$name" | sed -E 's/W_l([0-9]+)_j[0-9]+/\1/'); j=$(echo "$name" | sed -E 's/W_l[0-9]+_j([0-9]+)/\1/')
    k=$((l+e)); n=$(F2 "$k" "$l"); pre=$(tr -d '[:space:]' < "$d/prefix.txt")
    expect="R$(printf 'B%.0s' $(seq 1 "$j"))$(printf 'R%.0s' $(seq 1 $((2*l-1-j))))"   # W_j: red {1} u [j+2,2l], blue [2,j+1]
    [ "$pre" = "$expect" ] || fail "prefix in $d is not the window W_j for l=$l j=$j"
    QUIET=1 single "$k" "$l" "$n" "$d/W.edges.xz" "$d/W.cnf.xz" "$d/W.lrat.xz" "$pre" "W_l${l}_j${j}_e${e}" > /dev/null
    cnt=$((cnt+1)); [ $((cnt % 100)) -eq 0 ] && echo "  PASS $cnt window certificates so far"
  done < <(find "$D/wj_certs" "$D/wj_certs_e2_5" "$D/wj_certs_gap" -name prefix.txt -printf '%h\n' | sort)
  [ "$cnt" -eq 1470 ] || fail "expected 1470 window certificates, found $cnt"
  echo "  PASS all $cnt window certificates (prefix = W_j, hyperedges re-checked, CNF identical, both LRAT checkers)"
  echo "== Result 7: combined argument (forcing lemma R-23', R-22 for large k, balanced windows) with these certificates"
  python3 "$D/windows_coverage.py" || fail "window coverage"
fi

[ "$RAN" -gt 0 ] || fail "no section was run"
echo "ALL SELECTED SECTIONS PASSED: ${ARGS[*]}"
