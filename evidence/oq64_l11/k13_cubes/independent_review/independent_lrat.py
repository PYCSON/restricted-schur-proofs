#!/usr/bin/env python3
"""Independent T19 LRAT checker. No imports of the supplied check_cert, cubecert, regen_cnf.
Checks explicit positive-hint RUP chains and deletions against CNF reconstructed independently from JSON.
A negative hint (RAT subproof) is rejected, not treated as proof. Each certified added clause must reach a contradiction.
"""
from pathlib import Path
import argparse, collections, json,lzma,sys,time
# Release adaptation (paths only): the certificate directory is taken from --certs (default: ../certs).
R=Path(__file__).resolve().parent
F=L=R.parent/'certs'

def clauses_from_json(j):
 V=j['vertices']; n=len(V)
 unit_red=j['unit_red'];out=[(unit_red+1,)]
 for e in j['edges']:
  x=[e['a']+1]+[v+1 for m,v in e['others']]+[e['w']+1]
  assert len(x)==12 and len(set(x))==12
  out.append(tuple(-y for y in x));out.append(tuple(x))
 for i,col in j['cube_units']:
  if i!=unit_red:out.append(((i+1) if col==0 else -(i+1),))
 return n,out

def rup_proof(n,cnf,stream):
 # each initially stored clause gets a literal tuple, positive IDs 1..len(cnf)
 db={i+1:tuple(c) for i,c in enumerate(cnf)}
 adds=deletes=steps=0; maxid=len(db); empty=False
 # use stamp+polarity arrays avoids repeated dictionary construction
 stamp=[0]*(n+1);value=[0]*(n+1)
 for line in stream:
  if not line.strip():continue
  nums=line.split()
  cid=int(nums[0]); assert cid>0
  if nums[1]==b'd':
   assert nums[-1]==b'0' and cid>=maxid,('malformed delete',cid,maxid)
   for a in nums[2:-1]:
    k=int(a); assert k in db,('deleted missing id',cid,k)
    del db[k];deletes+=1
   continue
  assert cid>maxid,('non-increasing LRAT ID',cid,maxid)
  maxid=cid
  sep=nums.index(b'0',1)
  newcl=tuple(int(x) for x in nums[1:sep]); assert len(newcl)==len(set(newcl))
  assert all(0<abs(v)<=n for v in newcl),('bad literal',cid)
  tail=nums[sep+1:]; assert tail and tail[-1]==b'0'
  hints=[int(h) for h in tail[:-1]]
  assert hints and all(h>0 for h in hints),('missing/RAT hints',cid)
  adds+=1
  # assign complement of newcl (negating candidate)
  def assign(lit):
   nonlocal steps
   v=abs(lit); val=1 if lit>0 else -1
   if stamp[v]==adds:return value[v]==val
   stamp[v]=adds;value[v]=val;steps+=1;return True
  already_conflict=False
  for v in newcl:
   if not assign(-v):already_conflict=True;break
  contradiction=already_conflict
  if not contradiction:
   for hid in hints:
    cl=db.get(hid)
    assert cl is not None, ('unknown/deleted antecedent',cid,hid)
    unass=0; sat=False; unit=0
    for lit in cl:
     k=abs(lit)
     if stamp[k]==adds:
      if (value[k]==1)==(lit>0):sat=True;break
     else:unass+=1;unit=lit
     if unass>1: # still check rest for SAT for appropriate classification
      pass
    if sat:continue
    if unass==0:contradiction=True;break
    if unass>1:raise AssertionError(('not a RUP unit/conflict hint',cid,hid,unass))
    assert assign(unit)
  assert contradiction, ('RUP failed no contradiction',cid)
  db[cid]=newcl
  if not newcl:empty=True;break
 assert empty,'no empty clause derived'
 return {'additions':adds,'deletions':deletes,'assignments':steps,'max_id':maxid,'empty':empty}

def check(pre,log=False):
 start=time.monotonic()
 jpath=F/f'certC{pre}_11_13.json.xz';lpath=L/f'certC{pre}_11_13.lrat.xz'
 with lzma.open(jpath,'rt') as z:j=json.load(z)
 assert j['prefix']==pre
 n,cnf=clauses_from_json(j)
 with lzma.open(lpath,'rb') as z:result=rup_proof(n,cnf,z)
 result.update(prefix=pre,variables=n,original_clauses=len(cnf),seconds=round(time.monotonic()-start,3))
 if log:print('A4 PASS',result,flush=True)
 return result

if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('prefix',nargs='+');p.add_argument('--output',default='');p.add_argument('--certs',default='');a=p.parse_args()
 if a.certs:F=L=Path(a.certs).resolve()
 outcomes=[]
 for i,pre in enumerate(a.prefix):
  try:outcomes.append(check(pre,True))
  except Exception as e:
   print('A4 FAIL',pre,repr(e),flush=True)
   if a.output:Path(a.output).write_text(json.dumps(outcomes,indent=2))
   raise
 if a.output:Path(a.output).write_text(json.dumps(outcomes,indent=2))
