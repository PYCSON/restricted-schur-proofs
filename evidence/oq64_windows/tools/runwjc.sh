#!/bin/bash
# usage: runwj.sh L J TMAX   -> certificate for window W_j at k=L+1, n=F(L+1,L)
L=$1; J=$2; TM=${3:-3600}; K=$((L+1))
N=$(python3 -c "k=$K;l=$L;print(k*k+((l+1)*(l-2)//2+2)*k+l*(l-2))")
PRE=$(python3 -c "L=$L;J=$J;print('R'+'B'*J+'R'*(2*L-1-J))")
T=/tmp/claude-0/-home-claude/e4d196b7-05e8-510e-8550-4ec4df7c279d/scratchpad/tools
D=/home/claude/explore/wj/out/W_l${L}_j${J}; mkdir -p $D; cd $D
echo "$PRE" > prefix.txt
/home/claude/explore/wj/c/numfastc $K $L $N $TM $PRE W.edges > search.log 2>&1
R=$(tail -1 search.log)
case "$R" in UNSAT*) ;; *) echo "l=$L j=$J n=$N SEARCH: $R"; exit 2;; esac
python3 /home/claude/explore/wj/mkcnfw.py $K $L $N W.edges W.cnf $PRE > mkcnf.log 2>&1 || { echo "l=$L j=$J MKCNF FAIL"; exit 3; }
$T/cadical/build/cadical --unsat --lrat=true --binary=false W.cnf W.lrat > cadical.log 2>&1; rc=$?
$T/drat-trim/lrat-check W.cnf W.lrat > lc.log 2>&1
$T/cake_lpr/cake_lpr --CML_HEAP_SIZE=2000 --CML_STACK_SIZE=500 W.cnf W.lrat > cake.log 2>&1
LC=$(grep -o "c VERIFIED" lc.log | head -1); CK=$(grep -o "s VERIFIED UNSAT" cake.log | head -1)
xz -9 -f W.lrat; xz -9 -f -k W.cnf; sha256sum W.edges W.cnf W.cnf.xz W.lrat.xz prefix.txt > SHA256SUMS
echo "l=$L j=$J n=$N | $R | $(cat mkcnf.log) | cadical_rc=$rc | lrat-check:${LC:-FAIL} | cake_lpr:${CK:-FAIL}"
