#!/usr/bin/env python3
if not __debug__: raise SystemExit('REFUSE optimized Python')
import math,csv,json

def F(l,e):
 k=l+e;return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def V(l,e,j):
 m=l*(l+1)//2 +l*j+e*(j+1)-1;q=l-j
 return j*(j+1)//2 +q*(m+1)+q*(q-1)//2+e

def wbound(l,e,j,case):
 q=l-j
 S=l*(l+1)//2 +l*j
 D=j*(4*l-j+1)//2
 u=1 if case=='I' else j+2
 Z=(q-1)*(j+2)+q*(q-1)//2
 return S+D+q*(S+(e-1)*u)+Z+(j+3)+(l+j)+2*l*e+(e-1)*u

def U(l,e):
 return all(wbound(l,e,j,c)<=F(l,e) for j in range(2,l-1) for c in ('I','II'))

def J(l,e):
 if e<2:return False
 q=l-1;N=F(l,e)
 # Case I and II: AP x-extras interval, forced runs; basic four required inequalities
 S=(l+1)*(l+2)//2-2; A=S+e+2; span=(e-1)*(l-1)-2
 P=(l-1)*(l+2)//2+e
 V0=2*l*(e+1)+q*A+q*(q-1)//2
 if not (S+e*(l+1)<=N and span+1>=q and P<=q*(span+1-q) and V0+P<=N):return False
 S=l*(l+3)//2;A=S+2*e;span=(l-1)*e
 P=(l-1)*(l+2)//2+2*e
 V0=(e+1)+q*A+q*(q-1)//2
 return S+e*(l+1)<=N and span+1>=q and P<=q*(span+1-q) and V0+P<=N

a0=(1+math.sqrt(2))/2
rows=[]
for l in range(6,81):
 eU=next(e for e in range(1,60) if U(l,e) and all(U(l,s) for s in range(e,e+30)))
 eJ=next(e for e in range(2,60) if J(l,e) and all(J(l,s) for s in range(e,e+30)))
 good=[e for e in range(1,60) if any(V(l,e,j)>F(l,e) for j in range(1,l))]
 eL=max(good,default=0)
 kup=l+max(eU,eJ)
 klo=l+eL+1
 if l<=49:assert kup<a0*l+9, (l,kup,a0*l)
 if 19<=l<=49:assert klo>a0*l-4,(l,klo,a0*l)
 rows.append({'ell':l,'eU':eU,'eJ':eJ,'eL':eL,'K_upper':kup,'K_lower_from_threeblock':klo})
 if l<=20 or l%10==0:print(rows[-1],flush=True)
with open('/mnt/data/rsn_r6_review/output/finite_table.csv','w',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
print('FINITE PASS count',len(rows),'max additive upper 6..49',max(r['K_upper']-a0*r['ell'] for r in rows if r['ell']<=49))
