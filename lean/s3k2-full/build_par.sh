#!/bin/bash
export PATH=/home/claude/leanbuild/lean4/build/release/stage1/bin:$PATH
ulimit -s unlimited
cd /home/claude/rsnlean
stream() { for t in "$@"; do s=$(date +%s); lake build $t > build_$t.log 2>&1; rc=$?; echo "$t rc=$rc $(( $(date +%s)-s ))s errs=$(grep -c '^error' build_$t.log)"; done; }
stream RSN.Small4Unsat RSN.Small5Unsat RSN.Small6Unsat RSN.Small7Unsat > streamA.out 2>&1 &
stream RSN.Const2 RSN.BiMid RSN.Const1 RSN.Const3 > streamB.out 2>&1 &
wait
echo PAR_DONE
