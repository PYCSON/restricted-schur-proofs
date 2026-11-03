#!/usr/bin/env python3
if not __debug__:raise SystemExit('REFUSE optimized Python')
import itertools,json
cnt=0;max_width=0
for l in range(3,9):
 for e in range(1,6):
  for a in range(1,5):
   for n in range(l+2,l+6):
    b=a+n-1;k=l+e;D=l*(l-1)//2
    reach=set()
    for base in itertools.combinations(range(a,b+1),l):
     sums={0}
     for _ in range(e):sums={v+x for v in sums for x in base}
     base_sum=sum(base)
     reach.update(base_sum+s for s in sums)
    I=set(range(k*a+D,k*b-D+1))
    assert I.issubset(reach),(l,e,a,b,sorted(I-reach)[:20])
    cnt+=1;max_width=max(max_width,len(I))
print('FACT1 exhaustive PASS',cnt,'instances; max interval length',max_width)
