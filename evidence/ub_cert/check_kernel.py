#!/usr/bin/env python3
"""Independent checker for the S_3(k;2) <= k^3+3k^2+2k-2 kernel certificates (written separately from the generator).
For each certificate JSON:
  (1) rebuild the CNF from the JSON and compare byte-for-byte with the .cnf file;
  (2) every vertex p satisfies 1 <= p <= F on the case region          [exact, sympy];
  (3) every edge (u,v,w) satisfies w == (k-1)*u + v identically, and u-v has constant nonzero sign on the region;
  (4) every red vertex satisfies 1 <= p <= a on the region; the blue vertex equals a+1 identically;
  (5) numeric instantiation over a grid of (k,a) in the region re-checks (2)-(4) on actual integers.
Region proofs: univariate k>=K via (a) substitution k=K+t, nonnegative coefficients, and (b) independently via real-root isolation.
Bivariate 4<=a<=k-3 via substitution a=4+s, k=7+s+t (nonnegative coefficients)."""
import sys, json, hashlib
import sympy as sp
k,a,s,t=sp.symbols('k a s t')
def poly_of(coeffs,mons):
    e=0
    for c,m in zip(coeffs,mons):
        MONO={'1':sp.Integer(1),'a':a,'k':k,'ak':a*k,'k^2':k**2,'ak^2':a*k**2,'k^3':k**3}
        e+=c*MONO[m]
    return sp.expand(e)
def nonneg_sub(expr,sub,vars_):
    p=sp.Poly(sp.expand(expr.subs(sub,simultaneous=True)),*vars_)
    return bool(all(c>=0 for c in p.coeffs()))
def pos_sub(expr,sub,vars_):
    e=sp.expand(expr.subs(sub,simultaneous=True))
    p=sp.Poly(e,*vars_)
    const=e.subs({v:0 for v in vars_})
    return bool(all(c>=0 for c in p.coeffs()) and const>0)
def uni_nonneg_roots(expr,K):   # expr(k)>=0 for all integers k>=K, via root isolation
    e=sp.Poly(sp.expand(expr),k)
    if e.is_zero: return True
    roots=[r for r in sp.real_roots(e)] if e.degree()>0 else []
    big=[r for r in roots if r>=K]
    if big: return False
    roots=None
    return bool(e.eval(K)>=0) and bool(e.LC()>0 or e.degree()==0)
def check(fn,cnffn):
    J=json.load(open(fn)); mons=J['monomials']; reg=J['region']
    F=poly_of(J['F'],mons); assert sp.expand(F-(k**3+3*k**2+2*k-2))==0
    V=[poly_of(c,mons) for c in J['vertices']]
    if reg['mode']=='uni':
        K=reg['K']; kind,val=reg['case'].split(':'); val=int(val)
        A=sp.Integer(val) if kind=='const' else k-val
        sub={k:K+t}; vars_=[t]
        def NN(e): 
            r1=nonneg_sub(e,sub,vars_); r2=uni_nonneg_roots(e,K)
            assert (not r1) or r2, "substitution proof claimed but roots disagree"
            return r1
        def PS(e): return pos_sub(e,sub,vars_)
        grid=[(kk,None) for kk in range(K,K+60)]
    else:
        A0,B0=reg['A0'],reg['B0']; A=a
        sub={a:A0+s,k:A0+B0+s+t}; vars_=[s,t]
        NN=lambda e: nonneg_sub(e,sub,vars_); PS=lambda e: pos_sub(e,sub,vars_)
        grid=[(kk,aa) for kk in range(A0+B0,A0+B0+40) for aa in range(A0,kk-B0+1)]
    ok=True
    for p in V:
        if not (NN(p-1) and NN(F-p)): ok=False; print(' vertex out of range',p)
    for (u,v,w) in J['edges']:
        if sp.expand(V[w]-((k-1)*V[u]+V[v]))!=0: ok=False; print(' bad identity',u,v,w)
        d=V[u]-V[v]
        if not (PS(d) or PS(-d)): ok=False; print(' u-v sign not definite',V[u],V[v])
    for r in J['red']:
        if not (NN(V[r]-1) and NN(A-V[r])): ok=False; print(' bad red fact',V[r])
    for bl in J['blue']:
        if sp.expand(V[bl]-(A+1))!=0: ok=False; print(' bad blue fact',V[bl])
    # numeric instantiation
    for kk,aa in grid:
        sb={k:kk} if aa is None else {k:kk,a:aa}
        Fv=int(F.subs(sb)); Av=int(A.subs(sb)) if A.free_symbols else int(A)
        val=[int(p.subs(sb)) for p in V]
        assert all(1<=x<=Fv for x in val)
        for (u,v,w) in J['edges']:
            assert val[u]!=val[v] and val[w]==(kk-1)*val[u]+val[v]
        assert all(1<=val[r]<=Av for r in J['red'])
        assert all(val[bl]==Av+1 for bl in J['blue'])
    # rebuild CNF
    n=len(V); Vv=lambda x,c:3*x+c+1; cl=[]
    for i in range(n): cl.append([Vv(i,c) for c in range(3)])
    for (u,v,w) in J['edges']:
        for c in range(3): cl.append([-Vv(u,c),-Vv(v,c),-Vv(w,c)])
    for i in J['red']: cl.append([Vv(i,0)])
    for i in J['blue']: cl.append([Vv(i,1)])
    cnf=f"p cnf {3*n} {len(cl)}\n"+"".join(" ".join(map(str,c))+" 0\n" for c in cl)
    same=(cnf==open(cnffn).read())
    print(f"{J['name']}: region={reg} vertices={n} edges={len(J['edges'])} symbolic_ok={ok} numeric_grid={len(grid)} cnf_match={same}")
    return ok and same
allok=True
for nm in sys.argv[1:]:
    allok&=check(f"{nm}.json",f"{nm}.cnf")
print("ALL OK" if allok else "FAILURE")
