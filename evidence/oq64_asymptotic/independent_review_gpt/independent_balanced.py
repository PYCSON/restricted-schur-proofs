#!/usr/bin/env python3
if not __debug__:raise SystemExit('REFUSE optimized Python')
import itertools,collections,json

def F(l,e):
 k=l+e;return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)

def verify(l,e,red):
 W=set(range(1,2*l+1));blue=W-red
 if min(len(red),len(blue))<l-1:return None
 if red==set(range(1,2*l+1,2)):return 'parity'
 known={x:(0 if x in red else 1) for x in W}
 N=F(l,e)
 for Mcol,M0,D0 in [(0,red,blue),(1,blue,red)]:
  if len(M0)<l or len(D0)<l-1:continue
  M=sorted(M0);D=sorted(D0);Ds=set(D)
  for y in M:
   for rp in M:
    for d in M:
     if d==y or d==rp:continue
     b=y+rp-d
     if b not in Ds:continue
     required={y,rp,d}
     S=sorted(required | set(x for x in M if x not in required) )[:l]
     # Ensure triple in S even if high chosen: select other smallest with room
     S=sorted(required | set(sorted(x for x in M if x not in required)[:l-len(required)]))
     if len(S)!=l:continue
     B3=[x for x in D if x!=b][:l-2]
     assert len(B3)==l-2
     R=[x for x in S if x!=y]; u=min(R)
     r=min(x for x in S if x!=rp)
     db=min(B3)
     l1=sum(S)+(e-1)*u+r;l2=sum(S)+(e-1)*u+rp
     mv=sum(B3)+b+l1+e*db
     w=sum(R)+mv+(e-1)*u+d
     wp=sum(B3)+l1+l2+e*db
     assert w==wp and w<=N,(l,e,w,N)
     # Check all four *constrained* stages and final contradiction
     assert len(set(S))==l and len(set(B3+[b,l1]))==l and len(set(R+[mv]))==l and len(set(B3+[l1,l2]))==l
     assert l1>max(S) and l2>max(S) and mv>max(B3+[b,l1]) and w>max(R+[mv]) and wp>max(B3+[l1,l2])
     assert max(l1,l2,mv,w)<=N
     assert l1!=l2 and l1 not in B3 and l2 not in B3
     return {'l':l,'e':e,'Mcol':Mcol,'w':w,'N':N}
 return False

tot=0;good=0;special=0;fail=[]
for l in (6,7,8):
 local=0
 for bits in range(1<<(2*l-1)):
  red={1}|{x+2 for x in range(2*l-1) if (bits>>x)&1}
  if min(len(red),2*l-len(red))<l-1:continue
  z=verify(l,1,red)
  if z=='parity':special+=1;continue
  tot+=1;local+=1
  if z:good+=1
  elif len(fail)<10:fail.append((l,sorted(red)))
 print('BALANCED',l,'checked',local,flush=True)
print('TOTAL',tot,'PASS',good,'FAIL',tot-good,'PARITY',special, 'samples',fail)
assert tot==good
open(__import__('os').path.join(__import__('os').environ.get('OUT','.'),'balanced_results.json'),'w').write(json.dumps({'checked':tot,'pass':good,'fail':fail,'parity_cases':special},indent=2))
