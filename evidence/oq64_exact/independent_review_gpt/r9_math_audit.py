#!/usr/bin/env python3
"""Independent symbolic and finite checks of v1.3 Lemmas 26--28 / Theorem 29.
No first-party code imported. Values of w are computed from the published definition.
"""
if not __debug__:
    raise SystemExit('REFUSE -O')
import argparse
import itertools
from fractions import Fraction
import sympy as s

L,j,e=s.symbols('L j e',integer=True)
q=L-j
T=L*(L+1)/2
F=(L+e)**2 + (((L+1)*(L-2))/2+2)*(L+e) + L*(L-2)
P=(q+1)*(L*j+T) + j*(j+1)/2 + (q+1)*(e-1)*(j+1) + (q+1)*j + (q+1)*(q+2)/2-j+e
GP=-e**2-e*(L**2+L-2)/2-(e+L-1)*j**2+(e*L+(L**2-L-2)/2)*j+2*L
Vj=j*(j+1)/2 + q*((L*(L+1)/2 + L*j + e*(j+1)-1)+1)+q*(q-1)/2+e

def symbolic():
    assert s.expand(P-F-GP)==0
    assert s.expand(P-Vj-(e*(j+1)+j*(L-2)+L*(L+3)/2))==0
    # Discrete increment of F and exact lower bound of G_P.
    dF=s.expand(F.subs(e,e+1)-F)
    assert s.simplify(dF-(2*(L+e)+1+(L+1)*(L-2)/2+2))==0
    U=s.expand((L+3)**2/4+2*L)
    gap=s.factor(dF-U)
    assert s.expand(gap-((L**2-8*L-1)/4+2*e))==0
    assert s.expand(s.diff(F,e)-dF+1)==0
    # Independent expansion of (8.2) for a reduced window, good tuple.
    delta,Delta,b,db,m1=s.symbols('delta Delta b db m1')
    sp=L*j+T
    dp=j*(j+1)/2
    sqp=(q+1)*j+(q+1)*(q+2)/2
    ww=(q+1)*(sp-delta)+(dp+delta)+(q+1)*(e-1)*m1+(sqp-Delta)-b+e*db
    wd=(-q*delta-(q+1)*(e-1)*(j+1-m1)-Delta+(j-b)+e*(db-1))
    assert s.expand(ww-P-wd)==0
    # Four low cases: calculate the differences from the published
    # upper bounds, not merely from the printed target expressions.
    a,beta,D1,D2,SD,E=s.symbols('a beta D1 D2 SD E')
    target_L2=-(q-1)*L*(j-1)-q*(j-1)-dp+j-L-1
    wl2=(q+1)*(-L*(j-1))+(1+2*L*(j-1)-dp) + (q+1)*(e-1)*(1-j) + (-(q+1)*(j-1)+(j-1)) + j-beta
    assert s.expand(wl2-target_L2-((e-1)*(j-1)*(-q-1)-(beta-(L+2))))==0
    target_L1=-(q-1)*L*(j-1)-(q-1)*(a-1)-dp-(q-1)*j-j
    wl1=(q+1)*(-L*(j-1)-(a-1))+(a+2*L*(j-1)-dp) + (q+1)*(e-1)*(-j) + (-(q+1)*(j-1)+j) + j-beta +e*(a-1)
    assert s.expand(wl1-target_L1-((e-1)*(a-1-(q+1)*j)-(beta-(L+2))))==0
    target_L0a=-(q-1)*L*j-dp-(q+1)*j
    wl0a=(q+1)*(-L*j)+(SD-dp)+(q+1)*(e-1)*(-j) + (-(q+1)*j+E) + (j-D2)+e*(D1-1)
    rhs=(SD-2*L*j)+E+j-D2+D1-1+(e-1)*(D1-1-(q+1)*j)
    assert s.expand(wl0a-target_L0a-rhs)==0
    # L0b: q=L-2, b=D1, d_b=2L and E<=1.
    wl0b=((q+1)*(-L*j)+(D1+2*L-dp)+(q+1)*(e-1)*(-j) + (-(q+1)*j+E)+(j-D1)+e*(2*L-1)).subs(j,2)
    assert s.expand(wl0b-(e-2*L**2+4*L+E-1))==0
    print('SYMPY (diff), L2, L1, L0a, L0b expansions PASS')
    print('SYMPY P0/GP/V3/difference/discrete monotonicity PASS')
    print('DISCRETE GAP =',gap)
    # Exact sqrt2 constant identities and vertex discriminant symbolic checks.
    a=(s.sqrt(2)-1)/2
    c0=16-11*s.sqrt(2)
    A=e+L-1
    beta=s.expand(GP.coeff(j,1)) # extracted after polynomial in j below
    pol=s.Poly(GP,j)
    beta=pol.nth(1); gamma=pol.nth(0)
    discr=s.expand(beta**2+4*A*gamma)
    x=s.symbols('x',real=True,nonnegative=True)
    upper=s.Poly(s.expand(discr.subs(e,a*L+c0-1).subs(L,55+x)),x)
    upper_coefs=[s.simplify(t) for t in upper.all_coeffs()]
    assert len(upper_coefs)==4
    assert all(float(t.evalf(35))<0 for t in upper_coefs)
    # direct exact negative check using sqrt2 isolating
    for v in upper_coefs:
        assert s.simplify(v)<0
    print('UPPER discriminant cubic coefficients:',upper_coefs)
    # Lower G(j) using V_3-F: real j quadratic. 
    Gj=s.expand(Vj-F)
    poly=s.Poly(Gj,j)
    aa=-poly.nth(2);bb=poly.nth(1);gg=poly.nth(0)
    assert s.simplify(aa-(L+e-1))==0
    H=s.expand(4*aa*gg+bb**2-aa**2-4*aa)
    lower=s.Poly(s.expand(H.subs(e,a*L-s.Rational(363,100)).subs(L,19+x)),x)
    lower_coefs=[s.simplify(z) for z in lower.all_coeffs()]
    assert all(float(z.evalf(35))>0 for z in lower_coefs)
    print('LOWER H coefficients:',lower_coefs)
    # Vertex of V3-F is safely at least 1.5 from the endpoints.
    jstar=bb/(2*aa)
    lo=s.expand((bb-3*aa).subs(e,a*L-s.Rational(363,100)).subs(L,19+x))
    hi=s.expand((2*aa*(L-s.Rational(3,2))-bb).subs(e,a*L-s.Rational(363,100)).subs(L,19+x))
    assert all(float(z.evalf(35))>=0 for z in s.Poly(lo,x).all_coeffs())
    assert all(float(z.evalf(35))>=0 for z in s.Poly(hi,x).all_coeffs())
    print('SYMPY asymptotic discriminants + vertex PASS')
    for ell in range(9,55):
        threshold=next(t for t in range(1,ell+6)
            if all(GP.subs({L:ell,j:jj,e:t})<=0 for jj in range(2,ell-1)))
        if ell<=18: assert threshold<=4
        else:
            assert s.simplify(threshold-a*ell-(16-11*s.sqrt(2)))<=0
            assert threshold<=int(s.ceiling(a*ell))
            if ell==22: assert s.simplify(threshold-a*ell-(16-11*s.sqrt(2)))==0
    print('FINITE e_P l=9..54 PASS; equality l=22')

def w_of(S,D,t,e):
    y,rp,d=t
    b=y+rp-d
    if b not in D or d==y or d==rp or y not in S or rp not in S or d not in S:
        return None
    ell=len(S);j=len(D);q=ell-j
    if j<2 or q<2: return None
    u=next(v for v in S if v !=y)
    Q=sum([v for v in S if v!=rp][:q])
    db=next(v for v in D if v!=b)
    return ((q+1)*sum(S)+sum(D)+(q+1)*(e-1)*u
            +rp+Q-b+e*db)

def exact_min(S,D,e):
    SS=set(S); DD=set(D)
    if len(D)<2: return None
    best=10**30; triple=None
    for rp in S:
        candidates=[v for v in S if v!=rp]
        q=len(S)-len(D)
        Q=sum(candidates[:q]); rpQ=rp+Q
        for y in S:
            u=S[1] if y==S[0] else S[0]
            for b in D:
                d=y+rp-b
                if d in SS and d!=y and d!=rp:
                    db=D[1] if b==D[0] else D[0]
                    w=((q+1)*sum(S)+sum(D)+(q+1)*(e-1)*u
                       +rpQ-b+e*db)
                    if w<best:
                        best=w;triple=(y,rp,d,b)
    return best,triple

def prefix_w(ell,j,e):
    return int(P.subs({L:ell,globals()['j']:j,globals()['e']:e}))

def selected_low(ell,j,M,S,D):
    # Selection from §8.2, used to find mistakes in the proposed triples.
    mell=S[-1]; low=[v for v in D if v<=mell]
    if len(low)>1: return None
    high=[v for v in D if v>mell]
    beta=min(high)
    if len(low)==1 and low[0]==1:
        return ('L2',(ell+1,beta-ell+1,2))
    if len(low)==1:
        a=low[0];r=beta-ell
        if r!=a: return ('L1',(ell+1,r,1))
        if a!=2: return ('L1',(ell+1,a+1,2))
        return ('L1',(ell+1,4,3))
    if len(high)==2 and high[-1]==2*ell:
        return ('L0b',(ell,high[0]+1-ell,1))
    return ('L0a',(ell,high[1]+1-ell,1))

def window_check(ell,e,complete=True,max_windows=0):
    # All 2^(2ell-1) strings with χ(1)=R; only unbalanced with 2<=j<=ell-2.
    errors=[]; count=0; false_good=[]; low_types={}
    for mask in range(1<<(2*ell-1)):
        if max_windows and mask>=max_windows: break
        R=[1]+[i for i in range(2,2*ell+1) if mask>>(i-2)&1]
        B=[i for i in range(2,2*ell+1) if not(mask>>(i-2)&1)]
        if not (2<=min(len(R),len(B))<=ell-2): continue
        S=sorted(R if len(R)>len(B) else B)[:ell]
        D=sorted(B if len(R)>len(B) else R)
        jj=len(D)
        ans=exact_min(S,D,e)
        if ans is None or ans[1] is None:
            errors.append(('no admissible',ell,e,mask,D,S))
            break
        mm=ans[0]
        if mm>max(prefix_w(ell,jj,e),0):
            errors.append(('dominance fails',ell,e,mask,D,S,mm,prefix_w(ell,jj,e)))
            break
        low=selected_low(ell,jj,'R' if len(R)>len(B) else 'B',S,D)
        if low:
            name,t=low;low_types[name]=low_types.get(name,0)+1
            w=w_of(S,D,t,e)
            if w is None or w>prefix_w(ell,jj,e):
                errors.append(('low tuple fails',ell,e,mask,name,t,w,prefix_w(ell,jj,e),D,S))
                break
            y,rp,d=t
            q=ell-jj
            if rp not in S[:q+1]:
                if len(false_good)<4: false_good.append((name,ell,e,jj,tuple(S),tuple(D),t))
        count+=1
    print(f'EXHAUST ell={ell} e={e} checked={count} errors={len(errors)} lowcases={low_types}')
    if errors: print('COUNTEREXAMPLE:',errors[0])
    if false_good: print('ADMISSIBLE_NOT_GOOD:',false_good[:2])
    return errors, false_good

if __name__=='__main__':
    arg=argparse.ArgumentParser();arg.add_argument('--min-l',type=int,default=6)
    arg.add_argument('--max-l',type=int,default=8)
    arg.add_argument('--es',type=str,default='1,2,3')
    opt=arg.parse_args()
    symbolic()
    for ell in range(opt.min_l,opt.max_l+1):
        for ee in map(int,opt.es.split(',')):
            result,_=window_check(ell,ee)
            if result: raise SystemExit(1)
