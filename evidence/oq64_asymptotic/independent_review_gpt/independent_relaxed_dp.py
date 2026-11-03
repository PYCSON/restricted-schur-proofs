#!/usr/bin/env python3
"""Independent DP for >=ell distinct summands (corrected relaxed sense) and e=0 diagonal."""
if not __debug__:raise SystemExit('REFUSE optimized Python')
from independent_dp import V3,F,available_sums
import json
rows=[]
for ell,e,j in ((19,1,5),(20,1,5),(20,0,4)):
 m,v3=V3(ell,e,j);n=v3-1
 colors={'red':list(range(1,j+1))+list(range(m+1,n+1)), 'blue':list(range(j+1,m+1))}
 for name,vals in colors.items():
  mask=sum(1<<x for x in vals)
  for distinct in range(ell,ell+e+1):
   bits=available_sums(vals,distinct,ell+e-distinct,n)
   assert not bits&mask,(ell,e,j,name,distinct)
 rows.append({'ell':ell,'e':e,'j':j,'V3':v3,'F':F(ell,e),'status':'PASS'})
 print('RELAXED DP',rows[-1])
with open(__import__('os').path.join(__import__('os').environ.get('OUT','.'),'relaxed_dp_results.json'),'w') as f:json.dump(rows,f,indent=2)
