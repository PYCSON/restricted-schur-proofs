#!/bin/bash
# NOTE (public release): absolute paths of the original workspace were replaced by <TOOLS>/<REPO>/<WORKDIR>; this script was used to generate certificates and is not part of the verification chain.
# Certify WS_k(2) = S2(k;k) = n at a single point: UNSAT at n (hypergraph + LRAT), good colouring at n-1.
set -u
k=$1; n=$2; TMAX=${3:-7200}
L8=<REPO>/evidence/oq64_l8
T=<TOOLS>
P=diag_${k}_${n}
log() { echo "$(date '+%H:%M:%S') $*" | tee -a $P.log; }
log "numeng2 $k $k $n"
python3 $L8/numeng2.py $k $k $n $TMAX $P > $P.numeng.out 2>&1; log "numeng2 rc=$? $(tail -1 $P.numeng.out)"
python3 $L8/k9/mkcnf.py $k $k $n $P.edges $P.cnf > $P.mkcnf.out 2>&1; log "mkcnf: $(tail -1 $P.mkcnf.out)"
$T/cadical/build/cadical --unsat --lrat=true --binary=false $P.cnf $P.lrat > $P.cadical.out 2>&1; log "cadical rc=$?"
python3 $L8/k9/trimcore.py $P.edges $P.cnf $P.lrat $P.core.edges > $P.trim.out 2>&1; log "trimcore: $(tail -1 $P.trim.out)"
python3 $L8/k9/mkcnf.py $k $k $n $P.core.edges $P.core.cnf > $P.mkcnf_core.out 2>&1; log "mkcnf core: $(tail -1 $P.mkcnf_core.out)"
$T/cadical/build/cadical --unsat --lrat=true --binary=false $P.core.cnf $P.core.lrat > $P.cadical_core.out 2>&1; log "cadical core rc=$?"
$T/drat-trim/lrat-check $P.core.cnf $P.core.lrat > $P.lc.out 2>&1; log "lrat-check: $(grep -E 'VERIFIED|FAIL|ERROR' $P.lc.out | head -1)"
$T/cake_lpr/cake_lpr $P.core.cnf $P.core.lrat --CML_HEAP_SIZE=3000 > $P.cake.out 2>&1; log "cake_lpr: $(tail -1 $P.cake.out)"
m=$((n-1)); G=diag_${k}_${m}
python3 $L8/numeng2.py $k $k $m 600 $G > $G.numeng.out 2>&1; log "numeng2 at n-1: $(tail -1 $G.numeng.out)"
[ -s $G.good ] && { python3 $L8/k9/checkgood.py $k $k $m $G.good > $G.check.out 2>&1; log "checkgood: $(tail -1 $G.check.out)"; }
log "done"
