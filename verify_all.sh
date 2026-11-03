#!/usr/bin/env bash
# Replay the certificates behind Results 1-4, 6 and 7 of README.md (Result 5 and the Lean developments: see README),
# and (new in v1.2) the exact checks behind Result 8 (asymptotics of K(l)): sections asym and asymind.
# Result 4 (K(11)=12) is sections l11k12 (k=12) and l11k13 (222 cube certificates, every k>=13); l11k13ind runs the
# separately written second-party checkers on the same 222 certificates (needs Python >= 3.11).
# Requirements: python3 (with sympy), xz, and the two LRAT checkers:
#   LRAT_CHECK = path to lrat-check (drat-trim distribution)
#   CAKE_LPR   = path to cake_lpr (formally verified checker)
# Usage:  LRAT_CHECK=/path/lrat-check CAKE_LPR=/path/cake_lpr ./verify_all.sh [section ...]
#   (the sections asym and asymind need only python3 with sympy; LRAT_CHECK/CAKE_LPR are then not required)
# Sections: oq62 oq64sym oq64single diag l11k12 l11k13 l11k13ind unique windows asym asymind
#   (default: oq62 oq64sym oq64single diag l11k12 l11k13 asym asymind; "all" adds l11k13ind, unique and windows)
# Optional: CAKE_HEAP (MB, default 4000); LOGDIR (keep every checker output there instead of deleting it).
# A step passes only if the checker exits with status 0 AND prints its exact success line
# ("c VERIFIED" for lrat-check, "s VERIFIED UNSAT" for cake_lpr). Any failure stops the script with status 1.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")" && pwd); EV=$ROOT/evidence
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
HEAP=${CAKE_HEAP:-4000}; LOGDIR=${LOGDIR:-}
[ -n "$LOGDIR" ] && mkdir -p "$LOGDIR"

DEFAULT=(oq62 oq64sym oq64single diag l11k12 l11k13 asym asymind); ALL=("${DEFAULT[@]}" l11k13ind unique windows)
ARGS=("$@"); [ ${#ARGS[@]} -eq 0 ] && ARGS=("${DEFAULT[@]}")
[ "${ARGS[*]}" = "all" ] && ARGS=("${ALL[@]}")
for requested in "${ARGS[@]}"; do
  case " ${ALL[*]} " in *" $requested "*) ;; *) echo "Unknown section: $requested (valid: ${ALL[*]} all)" >&2; exit 2;; esac
done
NEED_LRAT=0; for s_ in "${ARGS[@]}"; do case "$s_" in asym|asymind) ;; *) NEED_LRAT=1;; esac; done
if [ "$NEED_LRAT" -eq 1 ]; then : "${LRAT_CHECK:?set LRAT_CHECK}"; : "${CAKE_LPR:?set CAKE_LPR}"; fi
RAN=0
want() { for s in "${ARGS[@]}"; do [ "$s" = "$1" ] && { RAN=$((RAN+1)); return 0; }; done; return 1; }
fail() { echo "FAIL: $*" >&2; exit 1; }
python3 -c 'import sys; sys.exit(0 if __debug__ else 1)' \
  || fail 'Python optimization (-O/PYTHONOPTIMIZE) disables proof-critical assertions'
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

if want l11k13; then
  echo "== Result 4: S_2(k;11) <= F(k,11) for every k >= 13 (222 cube certificates; with l11k12 this gives K(11)=12)"
  D=$EV/oq64_l11/k13_cubes
  ( cd "$D/certs" && sha256sum -c --quiet SHA256SUMS ) || fail "Result 4: certificate archive hashes"
  python3 "$D/check_partition.py" "$D/certs" || fail "Result 4: the cube prefixes do not form a complete partition"
  cnt=0
  for j in "$D"/certs/certC*_11_13.json.xz; do
    P=$(basename "$j"); P=${P#certC}; P=${P%_11_13.json.xz}; b=certC${P}_11_13
    xz -dc "$j" > "$W/$b.json"
    python3 "$D/check_cube.py" "$W/$b.json" "$P" "$W/$b.cnf" "$W/$b.cube.cnf" > "$W/cc.out" || { cat "$W/cc.out" >&2; fail "cube units or CNF: $P"; }
    python3 "$EV/oq64_kernel/check_cert.py" "$W/$b.json" 60 > "$W/cert.out" || { cat "$W/cert.out" >&2; fail "check_cert: $P"; }
    lrat "$W/$b.cube.cnf" "$D/certs/$b.lrat.xz" > /dev/null
    rm -f "$W/$b.json" "$W/$b.cnf" "$W/$b.cube.cnf"
    cnt=$((cnt+1)); [ $((cnt % 20)) -eq 0 ] && echo "  PASS $cnt cube certificates so far"
  done
  [ "$cnt" -eq 222 ] || fail "expected 222 cube certificates, found $cnt"
  echo "  PASS all $cnt cubes (partition, prefix units, symbolic certificate for all k>=13, both LRAT checkers)"
fi

if want l11k13ind; then
  echo "== Result 4 (second-party path): GPT's separately written symbolic validator and LRAT checker on the 222 cubes"
  D=$EV/oq64_l11/k13_cubes; R=$D/independent_review
  python3 "$R/independent_audit.py" "$D" "$W/ind_audit.json" > "$W/ia.out" || { cat "$W/ia.out" >&2; fail "independent_audit.py"; }
  tail -1 "$W/ia.out"
  grep -q '^A2-A3 PASS: certs 222 ' "$W/ia.out" || fail "independent_audit.py did not report A2-A3 PASS for 222 certificates"
  python3 "$R/independent_lrat.py" --certs "$D/certs" $(cd "$D/certs" && ls certC*_11_13.json.xz | sed -e 's/^certC//' -e 's/_11_13\.json\.xz$//') > "$W/il.out" 2>&1 \
    || { tail -3 "$W/il.out" >&2; fail "independent_lrat.py"; }
  [ "$(grep -c '^A4 PASS' "$W/il.out")" -eq 222 ] || fail "independent_lrat.py did not pass all 222 cubes"
  echo "  PASS independent LRAT replay: 222/222"
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

if want asym; then
  echo "== Result 8 (asymptotics of K(l)): first-party exact checks (evidence/oq64_asymptotic/scripts)"
  A=$EV/oq64_asymptotic/scripts
  expect() { local pat=$1; shift; ( cd "$A" && python3 -I "$@" ) > "$W/as.out" 2>&1 || { cat "$W/as.out" >&2; fail "asym: $* exited non-zero"; }
             grep -Eq "$pat" "$W/as.out" || { cat "$W/as.out" >&2; fail "asym: $* did not print /$pat/"; }; keep "$W/as.out" "asym_$(echo "$*" | tr ' /' '__').log"; echo "  PASS $*"; }
  expect '=> ALL PASS' rigorous_asym.py 4 4 50          # upper (T1-fill, cases I/II) and lower (three-block) bounds, all real l >= 50
  ( cd "$A" && python3 -I rigorous_asym.py 3 4 50 ) > "$W/as.out" 2>&1 || true
  grep -q '=> NOT ALL' "$W/as.out" || fail "asym: negative control (cU=3) was not rejected"; echo "  PASS negative control: cU=3 is rejected"
  expect 'max K_upper - \(1\+sqrt2\)/2\*l over l=6\.\.49: 8\.55' finite_table.py   # finite part 6 <= l <= 49
  expect 'l >= 7 e >= 3 => ALL PASS' j1_symbolic.py 7 3   # j = 1 windows
  expect 'l >= 6 e >= 4 => ALL PASS' j1_symbolic.py 6 4
  expect '7000 cases, failures: 0' fact1_constructive.py  # Fact 1 (interval k-sums), constructive proof
  expect 'l=20 k=21: F=4812, good on \[1,F-1\]=True, extendable to F: \[False, False\]' check_gaiser.py   # DP checker validated on Gaiser's colouring
  expect 'V3= 4181 F= 4163' check19.py; grep -q 'good: (True, None)' "$W/as.out" || fail "asym: l=19 three-block colouring not good"
  expect 'V3= 4861 F= 4812' check20.py; grep -q 'good: (True, None)' "$W/as.out" || fail "asym: l=20 three-block colouring not good"
  expect 'k=l=20: j=4 V3=4770 Ahmed=4751  \[1,V3-1\] good=True' check_diag.py
  expect 'relaxed 3-block 20 1 5 V3 4861 F 4812 good: True' goodcheck_relaxed.py
  expect '200/200 refuted' t1fill_witness.py 16 8 200     # explicit T1-fill hyperedges on random windows
fi

if want asymind; then
  echo "== Result 8: second-party (GPT) independently written checkers (evidence/oq64_asymptotic/independent_review_gpt)"
  G=$EV/oq64_asymptotic/independent_review_gpt; mkdir -p "$W/gpt"
  gexp() { local pat=$1 f=$2; ( cd "$G" && OUT="$W/gpt" python3 -I -B -c "import sys,runpy; sys.path.insert(0,'$G'); runpy.run_path('$G/$f', run_name='__main__')" ) > "$W/gp.out" 2>&1 \
             || { cat "$W/gp.out" >&2; fail "asymind: $f exited non-zero"; }
           grep -Eq "$pat" "$W/gp.out" || { cat "$W/gp.out" >&2; fail "asymind: $f did not print /$pat/"; }; keep "$W/gp.out" "asymind_$f.log"; echo "  PASS $f"; }
  gexp 'SYMBOLIC PASS' independent_r6_symbolic.py
  gexp 'continuous proof is in report' independent_aux_symbolic.py
  gexp 'l 8 checked 19115 closed 19115 failure 0' independent_t1.py
  gexp 'TOTAL 23845 PASS 23845 FAIL 0' independent_balanced.py
  gexp 'PARITY 23740 checks 0 failures' independent_parity.py
  gexp 'FINITE PASS count 75' independent_finite.py
  gexp "'l': 20, 'e': 1, 'j': 5, 'n': 4860, 'F': 4812.*'good': True" independent_dp.py
  gexp "'ell': 20, 'e': 1, 'j': 5, 'V3': 4861, 'F': 4812, 'status': 'PASS'" independent_relaxed_dp.py
  gexp 'FACT1 exhaustive PASS 480' independent_fact1.py
fi

[ "$RAN" -gt 0 ] || fail "no section was run"
echo "ALL SELECTED SECTIONS PASSED: ${ARGS[*]}"
