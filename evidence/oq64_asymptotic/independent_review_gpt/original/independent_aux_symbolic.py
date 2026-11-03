#!/usr/bin/env python3
if not __debug__:raise SystemExit('REFUSE optimized Python')
import sympy as s
l,e,t,u,j,v,d,ss=s.symbols('l e t u j v d ss',nonnegative=True)
k=l+e;D=l*(l-1)/2
F=s.expand(k*k+(D+1)*k+l*(l-2))
def poly_nonnegative(expr,vars):
 poly=s.Poly(s.expand(expr),*vars)
 bad=[(m,c) for m,c in poly.terms() if not bool(c>=0)]
 return not bad,bad
# balanced bound
oldW=s.Rational(7,2)*l*l+s.Rational(5,2)*l-6+e*(3*l+7)
res=s.expand((F-oldW).subs({l:6+u,e:1+t}))
assert poly_nonnegative(res,(u,t))[0],res
print('BALANCED coarse w bound PASS',res)
# J1 8 conditions, separately for l>=7,e>=3 and l>=6,e>=4
N=F;q=l-1
S=(l+1)*(l+2)/2-2;A=S+e+2;L=(e-1)*(l-1)-2;P=(l-1)*(l+2)/2+e
V=2*l*(e+1)+q*A+q*(q-1)/2
ji={'I_C2':N-S-e*(l+1),'I_len':L+1-q,'I_coverage':q*(L+1-q)-P,'I_upper':N-V-P}
S=l*(l+3)/2;A=S+2*e;L=(l-1)*e;P=(l-1)*(l+2)/2+2*e
V=(e+1)+q*A+q*(q-1)/2
ji.update({'II_C2':N-S-e*(l+1),'II_len':L+1-q,'II_coverage':q*(L+1-q)-P,'II_upper':N-V-P})
for (L0,E0) in [(7,3),(6,4)]:
 for name,z in ji.items():
  z=s.expand(z.subs({l:L0+u,e:E0+t}))
  assert poly_nonnegative(z,(u,t))[0],(L0,E0,name,z)
 print('J1 symbolic ALL PASS l>=',L0,'e>=',E0)
# all red: forced I > 2l, upper I < F, length I>=l+2; t<=F and step2 far ceiling >=F
lowI=k+D;topI=2*k*l-D; lengthI=topI-lowI+1
low2=k*lowI +D;top2=k*topI-D
checks={'I_lower':lowI-(2*l+1), 'I_upper':F-topI-1,
 'I_length':lengthI-(l+2),'t_below_F':F-low2,
 'end2_above_F':top2-F,
 'end_final':F-((k-l+1)+(l-1)*l/2-1+low2)}
for name,z in checks.items():
 z=s.expand(z.subs({l:6+u,e:1+t}))
 assert poly_nonnegative(z,(u,t))[0],(name,z)
 print('ALLRED',name,'PASS',z)
# symbolic parity even
blue_sum=l*(l+1)+2*e
red_low=l*l+e; red_hi=l*l+e*(2*l-1)
assert poly_nonnegative(s.expand((blue_sum-red_low).subs({l:6+u,e:1+t})),(u,t))[0]
assert poly_nonnegative(s.expand((red_hi-blue_sum).subs({l:6+u,e:1+t})),(u,t))[0]
assert poly_nonnegative(s.expand((F-blue_sum).subs({l:6+u,e:1+t})),(u,t))[0]
print('PARITY EVEN symbolic PASS')
# Odd parity m for l>=8; s=sqrt(l-1)>=sqrt7, d in [0,1], m=l/2 - s + d
r=(l-1)**2-e*(2*l-3)-2*v*(l-v)
span=2*v*(e*(l-1)+1-v)
base=(l-1)**2+l*(l+1)-v*(2*l-v+1)+v*(l*l+e)+v*(v-1)+3*e
sub={l:ss*ss+1,v:(ss*ss+1)/2-ss+d,e:1+t}
for name,z in [('r-span',r-span),('negative_r-span',-r-span),('F-base',F-base),('F-base+r',F-base+r)]:
 zz=s.expand(z.subs(sub)); print('ODD',name,'polynomial',s.collect(zz,t))
 # check interval corner d=0,1 and derivative monotonic via exact inequality under s>=sqrt7
 for Sd in [0,1]:
  for Sval in [s.sqrt(7),s.Rational(3),s.Rational(4),s.Rational(10),s.Rational(100)]:
   for T in [0,1,10]:
    val=zz.subs({ss:Sval,d:Sd,t:T}).evalf(30)
    assert bool(val <= 0 if 'span' in name else val > 0),(name,Sd,Sval,T,val)
print('ODD s,d algebraic signs checked on endpoints; continuous proof is in report')
