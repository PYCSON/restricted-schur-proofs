#!/bin/bash
export PATH=/home/claude/leanbuild/lean4/build/release/stage1/bin:$PATH
cd /home/claude/rsnlean
for t in RSN.Statement RSN.Bridge RSN.UniCase RSN.Poly2 RSN.BiCase RSN.Direct Gaiser.Lower RSN.Top0 RSN.Top1 RSN.Top2 RSN.Small3Unsat RSN.Small4Unsat RSN.Small5Unsat RSN.Small6Unsat RSN.Small7Unsat RSN.Const2 RSN.BiMid RSN.Const1 RSN.Const3 RSN.Main RSN; do
  s=$(date +%s)
  lake build $t > build_$t.log 2>&1; rc=$?
  echo "$t rc=$rc $(( $(date +%s)-s ))s $(grep -c 'error' build_$t.log) errors"
  if [ $rc -ne 0 ]; then grep -A5 "error" build_$t.log | head -30; exit 1; fi
done
echo ALL_DONE
