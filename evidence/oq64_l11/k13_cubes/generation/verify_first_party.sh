#!/bin/bash
# usage: verify.sh base   (base = certX_11_13) ; runs check_cert + LRAT on base.cube.cnf
T=<TOOLS>
b=$1
CC=$(python3 -I <REPO>/evidence/oq64_kernel/check_cert.py $b.json 60 2>&1 | tail -3 | tr '\n' ' ')
$T/cadical/build/cadical --unsat --lrat=true --binary=false -q $b.cube.cnf $b.lrat > $b.cad.log 2>&1; rc=$?
$T/drat-trim/lrat-check $b.cube.cnf $b.lrat > $b.lc.log 2>&1
$T/cake_lpr/cake_lpr --CML_HEAP_SIZE=4000 --CML_STACK_SIZE=500 $b.cube.cnf $b.lrat > $b.cake.log 2>&1
LC=$(grep -o "c VERIFIED" $b.lc.log | head -1); CK=$(grep -o "s VERIFIED UNSAT" $b.cake.log | head -1)
echo "$b | check_cert: $CC | cadical_rc=$rc | lrat-check:${LC:-FAIL} | cake_lpr:${CK:-FAIL}"
