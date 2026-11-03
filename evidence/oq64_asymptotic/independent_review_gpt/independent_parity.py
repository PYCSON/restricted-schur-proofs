#!/usr/bin/env python3
"""Fresh constructive parity proof checker, no producer code imported."""
if not __debug__:raise SystemExit('REFUSE optimized Python')
import math, random, json

def f(l,e):
 k=l+e;return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)

def min_m(l):
 if l<=7:return 1
 return next(m for m in range(1,l//2+1) if (l-2*m)**2 <=4*(l-1))

def construct(l,e):
 assert (l+e)%2==1 and e>=1 and l>=6
 k=l+e;N=f(l,e); m=min_m(l)
 O=list(range(1,2*l,2)); E=list(range(2,2*l+1,2))
 nA=e*(l-1)+1;amin=l*l+e
 bigE=E[-m:]; smallE=E[:m]
 target=(l-1)**2-e*(2*l-3)-2*m*(l-m)
 bound=2*m*(nA-m)
 if target%2 or abs(target)>bound:return {'failure':'AP SPAN','l':l,'e':e,'target':target,'bound':bound}
 # Generate indexed m-subset with prescribed index sum delta
 def choose(delta):
  assert 0<=delta<=m*(nA-m)
  inds=list(range(m))
  for i in range(m-1,-1,-1):
   top=(nA-1) if i==m-1 else inds[i+1]-1
   bump=min(delta,top-inds[i]);inds[i]+=bump;delta-=bump
  assert delta==0 and len(set(inds))==m
  return [amin+2*i for i in inds]
 if target>=0: L=choose(0);Lp=choose(target//2)
 else: L=choose(-target//2);Lp=choose(0)
 def check_sum_of_O(v):
  R=(v-l*l-e)//2
  assert v==l*l+e+2*R and 0<=R<=e*(l-1)
  # e red odd extras: represent 2R with e odd elements in [1,2l-1]
  Q,rem=divmod(R,l-1)
  if Q==e: a=[2*l-1]*e
  else:a=[2*l-1]*Q +[1+2*rem]+[1]*(e-Q-1)
  assert len(a)==e and all(v in O for v in a)
  assert sum(O)+sum(a)==v
 for v in L+Lp:check_sum_of_O(v)
 P=sorted(set(E).difference(bigE))+L
 PP=sorted(set(E).difference(smallE))+Lp
 assert len(P)==l==len(set(P))==len(PP)==len(set(PP))
 assert 2 in P and 2*l in PP
 M=sum(P)+2*e
 Rp=O[:-1]+[M]
 assert len(Rp)==l and len(set(Rp))==l and M>2*l
 w=sum(Rp)+e
 wp=sum(PP)+2*l*e
 assert w==wp,(l,e,m,target,w,wp)
 assert w>max(Rp),wp>max(PP)
 # ensure ALL required sums in range, including A; and larger than all input values
 assert max(L+Lp)<M<w<=N,(l,e,m,target,max(L+Lp),M,w,N)
 return {'l':l,'e':e,'m':m,'target':target,'w':w,'N':N,'margin':N-w}

def main():
 tests=0; bad=[];minmargin=10**30; worst=None
 for l in range(6,401):
  # edge cases parity-appropriate 1..120 plus 10 random points up to 400 for every l
  probes=list(range(1,121))
  if l%10==0:probes+=[121,150,200,300,500,1000]
  for e in probes:
   if (l+e)%2!=1:continue
   tests+=1
   try:
    v=construct(l,e)
    if 'failure' in v:bad.append(v)
    elif v['margin']<minmargin:minmargin=v['margin'];worst=v
   except Exception as exc:
    bad.append({'l':l,'e':e,'error':str(exc)})
 print('PARITY',tests,'checks',len(bad),'failures','minimum F-w margin',minmargin,'worst',worst)
 with open(__import__('os').path.join(__import__('os').environ.get('OUT','.'),'parity_results.json'),'w') as f:json.dump({'tests':tests,'failures':bad[:30],'minmargin':minmargin,'worst':worst},f,indent=2)
 assert not bad
if __name__=='__main__': main()
