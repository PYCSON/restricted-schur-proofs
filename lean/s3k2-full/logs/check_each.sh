#!/bin/bash
# NOTE (public release): absolute paths of the original workspace were replaced by <TOOLS>/<REPO>/<WORKDIR>; this script was used to generate certificates and is not part of the verification chain.
export PATH=<WORKDIR>/leanbuild/lean4/build/release/stage1/bin:$PATH
ulimit -s unlimited
cd <WORKDIR>/rsnlean
m=$1; s=$(date +%s)
lake env leanchecker $m > lc_logs/$m.log 2>&1; rc=$?
echo "$m rc=$rc $(( $(date +%s)-s ))s"
