#!/bin/bash
# numfast probes: k=l+1, n=F(k,l), prefix = R B^j R^(2l-1-j) (four-block-shaped window)
cd /home/claude/explore/oq64cert
for l in 23 22 21 20; do
  k=$((l+1)); F=$(python3 -c "k,l=$k,$l;print(k*k+((l+1)*(l-2)//2+2)*k+l*(l-2))")
  for j in 1 2 3 4 5 6 7 8 9 10; do
    p="R$(printf 'B%.0s' $(seq 1 $j))$(printf 'R%.0s' $(seq 1 $((2*l-1-j))))"
    r=$(nice -n 10 ./numfast $k $l $F 60 $p 2>/dev/null | head -2 | tr '\n' ' ')
    echo "l=$l k=$k n=$F j=$j :: $r"
  done
done
