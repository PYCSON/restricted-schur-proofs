#!/bin/bash
# NOTE (public release): absolute paths of the original workspace were replaced by <TOOLS>/<REPO>/<WORKDIR>; this script was used to generate certificates and is not part of the verification chain.
# certified uniqueness of the three-block colouring at n=F-1, for a list of (k,l)
T=<TOOLS>
K9=<REPO>/evidence/oq64_l8/k9
cd <WORKDIR>/explore/oq64cert/uq
for kl in "3 3" "4 4" "4 3" "5 4" "6 5" "7 6" "8 7" "9 8" "10 9" "7 5" "8 6" "9 7"; do
  set -- $kl; k=$1; l=$2; tag=${l}_${k}
  python3 ../gaiser_good.py $k $l g_$tag.good > /dev/null
  n=$(wc -w < g_$tag.good)
  good=$(python3 $K9/checkgood.py $k $l $n g_$tag.good | tail -1)
  res=$(python3 ../numuniq.py $k $l $n g_$tag.good 3000 u_$tag | tail -1)
  case "$res" in
    UNIQUE*)
      python3 ../mkcnf_block.py $k $l $n u_$tag.edges g_$tag.good u_$tag.cnf > mk_$tag.txt
      $T/cadical/build/cadical -q --unsat --lrat=true --binary=false u_$tag.cnf u_$tag.lrat > /dev/null; crc=$?
      lc=$($T/drat-trim/lrat-check u_$tag.cnf u_$tag.lrat | grep -cE "^c VERIFIED")
      ck=$($T/cake_lpr/cake_lpr --CML_HEAP_SIZE=4000 --CML_STACK_SIZE=1000 u_$tag.cnf u_$tag.lrat | grep -c "s VERIFIED UNSAT")
      edges=$(wc -l < u_$tag.edges)
      echo "k=$k l=$l n=$n target=$good | $res | edges=$edges cadical_rc=$crc lrat-check=$lc cake_lpr=$ck";;
    *) echo "k=$k l=$l n=$n target=$good | $res";;
  esac
done
