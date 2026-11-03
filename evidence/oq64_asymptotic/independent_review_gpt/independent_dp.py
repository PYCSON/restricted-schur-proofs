#!/usr/bin/env python3
"""Independent bitset DP for monochromatic distinct-summand k-sums. Does not read producer code."""
if not __debug__:raise SystemExit('REFUSE optimized Python')
import sys,time,json

def F(l,e):
 k=l+e;return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)

def V3(l,e,j):
 m=l*(l+1)//2+l*j+e*(j+1)-1
 q=l-j
 return m,j*(j+1)//2+q*(m+1)+q*(q-1)//2+e

def available_sums(color,l,e,n,relaxed=False):
 dp=[[0]*(e+1) for _ in range(l+1)]
 dp[0][0]=1
 mask=(1<<(n+1))-1
 for count,x in enumerate(color,1):
  if x>n:break
  for t in range(min(l,count),0,-1):
   for extra in range(e,-1,-1):
    val=dp[t][extra]
    for new_extra in range(extra+1):
     v=dp[t-1][extra-new_extra]
     if v:val|=v<<((1+new_extra)*x)
    dp[t][extra]=val&mask
 return dp[l][e]

def check(l,e,j):
 N=F(l,e);m,V=V3(l,e,j)
 n=V-1;red=list(range(1,j+1))+list(range(m+1,n+1));blue=list(range(j+1,m+1))
 assert len(red)+len(blue)==n
 start=time.monotonic()
 for c,values in [('red',red),('blue',blue)]:
  sums=available_sums(values,l,e,n)
  cmask=sum(1<<x for x in values)
  overlap=sums&cmask
  if overlap:return {'l':l,'e':e,'j':j,'color':c,'bad_sum':(overlap&-overlap).bit_length()-1}
 return {'l':l,'e':e,'j':j,'n':n,'F':N,'runtime_sec':time.monotonic()-start,'good':True,'extendable_at_F':V<=N}

if __name__=='__main__':
 cases=[(4,1,1),(5,1,2),(6,2,3),(7,1,2),(8,1,2),(19,1,5),(20,1,5)]
 res=[]
 for L,E,J in cases:
  row=check(L,E,J);print(row,flush=True);res.append(row)
 with open(__import__('os').path.join(__import__('os').environ.get('OUT','.'),'dp_results.json'),'w') as f:json.dump(res,f,indent=2)
 assert all(r.get('good') for r in res)
