#!/usr/bin/env python3
"""Fresh T1 proof graph checker on all sparse-window bitstrings (small ell)."""
if not __debug__:raise SystemExit('REFUSE python -O')
import itertools, sys, random, json, math

def F(l,e):
 k=l+e; return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def edge(summands, extra, e, expected, maxn, color, known):
 # list distinct bases, extra counts, check arithmetic and color prerequisites
 assert len(summands)==len(set(summands)) and len(summands)>0
 assert sum(extra.values())==e and all(x in summands and m>=0 for x,m in extra.items())
 assert all(known.get(x)==color for x in summands),('color',color,summands,[(x,known.get(x)) for x in summands])
 value=sum(summands)+sum(x*v for x,v in extra.items())
 assert value==expected and value<=maxn and value>max(summands),('val',value,expected,maxn)
 if value in known:assert known[value]!=color,('already forced same',value,color)
 else:known[value]=1-color
 return value

def t1(l,e,red, details=False):
 W=set(range(1,2*l+1)); N=F(l,e)
 blue=W-red; R=red;B=blue
 if min(len(R),len(B))<2 or min(len(R),len(B))>l-2:return None
 M=sorted(R if len(R)>len(B) else B)
 D=sorted(B if len(R)>len(B) else R)
 Mcol=0 if len(R)>len(B) else 1; Dcol=1-Mcol
 assert len(M)>=l+2 and len(D)>=2
 S=M[:l]; q=l-len(D);j=len(D)
 ds=set(D)
 known={v:(0 if v in R else 1) for v in W}
 for y in S:
  for rp in S:
   for d in S:
    b=y+rp-d
    if b not in ds:continue
    Rp=[v for v in S if v!=y]
    if d not in Rp:continue
    rr=min(v for v in S if v!=rp)
    z=sorted(v for v in S if v not in (rr,rp))[:q-1]
    if len(z)!=q-1:continue
    db=min(v for v in D if v!=b)
    Sigma=sum(S)+(e-1)*min(Rp)
    L1=Sigma+rr;L2=Sigma+rp
    Z=[Sigma+v for v in z]
    B3=sorted([v for v in D if v!=b]+Z)
    Mv=sum(B3)+b+L1+e*db
    w=sum(Rp)+Mv+(e-1)*min(Rp)+d
    wp=sum(B3)+L1+L2+e*db
    assert w==wp
    if w>N:continue
    try:
     trial=dict(known)
     for v,extra in [(rr,{min(Rp):e-1,rr:1}),(rp,{min(Rp):e-1,rp:1})]:
      # issue duplicate keys when rr= min(Rp) or rp=min(Rp), use aggregated dict
      ex={min(Rp):e-1}; ex[v]=ex.get(v,0)+1
      edge(S,ex,e,Sigma+v,N,Mcol,trial)
     for v in z:
      ex={min(Rp):e-1}; ex[v]=ex.get(v,0)+1
      edge(S,ex,e,Sigma+v,N,Mcol,trial)
     edge(B3+[b,L1],{db:e},e,Mv,N,Dcol,trial)
     ex={min(Rp):e-1};ex[d]=ex.get(d,0)+1
     edge(Rp+[Mv],ex,e,w,N,Mcol,trial)
     # final edge w'=w forced opposite, temporarily inspect prereqs/sum, check collision explicitly
     last=B3+[L1,L2]
     assert len(last)==l and len(set(last))==l
     assert all(trial.get(x)==Dcol for x in last)
     assert wp==sum(last)+e*db and wp<=N and wp>max(last)
     assert trial.get(w)==Dcol
     return {'l':l,'e':e,'red':sorted(R),'j':j,'y':y,'rp':rp,'d':d,'b':b,'w':w,'N':N,'ratio':round(w/N,5)} if details else True
    except AssertionError:
     raise
 return False

def main():
 out={'tested':0,'closed':0,'failures':[],'examples':[]}
 for l in range(6,10):
  e=math.ceil((math.sqrt(2)-1)/2*l+4)
  stop=(1<<(2*l-1)) if l<=8 else 15000
  rng=random.Random(20261102+l)
  for i in range(stop):
   bits=i if l<=8 else rng.getrandbits(2*l-1)
   red={1}|{j+2 for j in range(2*l-1) if bits>>j&1}
   if not (2<=min(len(red),2*l-len(red))<=l-2):continue
   out['tested']+=1
   ans=t1(l,e,red,True)
   if ans: out['closed']+=1
   else:
    if len(out['failures'])<20:out['failures'].append({'l':l,'e':e,'red':sorted(red)})
   if ans and len(out['examples'])<5:out['examples'].append(ans)
  print('l',l,'checked',out['tested'],'closed',out['closed'],'failure',len(out['failures']),flush=True)
 print(json.dumps({k:v for k,v in out.items() if k!='examples'},ensure_ascii=False,indent=2))
 with open('/mnt/data/rsn_r6_review/output/t1_results.json','w') as f:json.dump(out,f,ensure_ascii=False,indent=2)
 assert out['tested']==out['closed'],out['failures']
if __name__=='__main__':main()
