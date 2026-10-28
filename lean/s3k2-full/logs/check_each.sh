#!/bin/bash
export PATH=/home/claude/leanbuild/lean4/build/release/stage1/bin:$PATH
ulimit -s unlimited
cd /home/claude/rsnlean
m=$1; s=$(date +%s)
lake env leanchecker $m > lc_logs/$m.log 2>&1; rc=$?
echo "$m rc=$rc $(( $(date +%s)-s ))s"
