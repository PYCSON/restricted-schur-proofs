#!/usr/bin/env python3
"""Independent checker for a symbolic-kernel certificate cert_<l>_<k0>.json (does not import the generator).

Claim certified: for every integer k >= k0, every 2-colouring of [1,F(k,l)] has a monochromatic solution of
x_1+...+x_k = x_{k+1} with exactly l+1 distinct integers, PROVIDED the CNF (re-derived here from the JSON)
is UNSAT (checked separately with LRAT).

Checks per edge  w = (k-c)*a + sum_i m_i*o_i :
  E1  exactly l-1 others, integer m_i >= 1, sum m_i = c, and c <= k0-1 (so k-c >= 1 on the region)
  E2  a has degree <= 1 (so (k-c)*a has degree <= 2); identity holds coefficient-wise
  E3  the l summand polynomials are pairwise different at every integer k >= k0
Checks per vertex: 1 <= p(k) <= F(k) for every integer k >= k0.
Region tests: exact, via t = k-k0 >= 0 and a separate argument for quadratics (see positive_on_naturals).
Also: re-derive the DIMACS CNF and compare with cert_<l>_<k0>.cnf; numeric spot checks for many k.
usage: check_cert.py cert.json [numeric_kmax]"""
import sys, json
from fractions import Fraction

def poly_mul(p, q):
    r = [0]*(len(p)+len(q)-1)
    for i, x in enumerate(p):
        for j, y in enumerate(q): r[i+j] += x*y
    return r
def poly_add(p, q):
    n = max(len(p), len(q)); return [(p[i] if i < len(p) else 0)+(q[i] if i < len(q) else 0) for i in range(n)]
def trim(p):
    p = list(p)
    while len(p) > 1 and p[-1] == 0: p.pop()
    return p
def shift(p, k0):
    """coefficients of p(k0+t) in t"""
    r = [0]
    for c in reversed(p):          # Horner: r = r*(k0+t) + c
        r = poly_add(poly_mul(r, [k0, 1]), [c])
    return trim(r)
def positive_on_naturals(p):
    """p(t) > 0 for every integer t >= 0 ? (degree <= 2), exact."""
    p = trim(p)
    if len(p) == 1: return p[0] > 0
    if len(p) == 2:
        b, a = p; return a > 0 and b > 0 or (a == 0 and b > 0) or (a > 0 and b > 0)
    c, b, a = p
    if a < 0: return False
    if a == 0: return positive_on_naturals([c, b])
    # a > 0: minimum over reals at t* = -b/(2a); over integers t>=0 the minimum is at 0 or floor/ceil(t*)
    ts = Fraction(-b, 2*a)
    cand = {0}
    if ts > 0:
        fl = ts.numerator // ts.denominator
        cand |= {fl, fl+1}
    return all(c + b*t + a*t*t > 0 for t in cand if t >= 0)
def nonneg_on_naturals(p):
    p = trim(p); q = list(p); q[0] += 1
    return positive_on_naturals(q)   # integer-valued: p >= 0  <=>  p+1 > 0

cert = json.load(open(sys.argv[1]))
l, k0 = cert['l'], cert['k0']
V = [trim(v) for v in cert['vertices']]
F = trim(cert['F'])
D = l*(l-1)//2
FX = cert.get('F_extra', 0)
assert F == trim([l*l-2*l+FX, D+1, 1]), "F mismatch"
bad = []
# vertices: 1 <= p <= F on region
for i, p in enumerate(V):
    if not positive_on_naturals(shift(p, k0)): bad.append(('vertex<1', i))
    if not nonneg_on_naturals(shift(poly_add(F, [-x for x in p]), k0)): bad.append(('vertex>F', i))
for j, e in enumerate(cert['edges']):
    a = V[e['a']]; c = e['c']; oth = e['others']; w = V[e['w']]
    if len(oth) != l-1: bad.append(('E1 count', j))
    ms = [m for m, o in oth]
    if any((not isinstance(m, int)) or m < 1 for m in ms) or sum(ms) != c or not (c <= k0-1): bad.append(('E1 mult', j))
    if len(a) > 2: bad.append(('E2 deg a', j))
    rhs = poly_mul([-c, 1], a)
    for m, o in oth: rhs = poly_add(rhs, [m*x for x in V[o]])
    if trim(rhs) != w: bad.append(('E2 identity', j))
    S = [e['a']] + [o for m, o in oth]
    if len(set(S)) != len(S): bad.append(('E3 repeated vertex', j))
    for x in range(len(S)):
        for y in range(x+1, len(S)):
            d = poly_add(V[S[x]], [-z for z in V[S[y]]])
            if not (positive_on_naturals(shift(d, k0)) or positive_on_naturals(shift([-z for z in d], k0))):
                bad.append(('E3 distinct', j, S[x], S[y]))
# CNF re-derivation
lines = [f"p cnf {len(V)} {2*len(cert['edges'])+1}", f"{cert['unit_red']+1} 0"]
for e in cert['edges']:
    vs = [e['a']] + [o for m, o in e['others']] + [e['w']]
    lines.append(' '.join(str(-(x+1)) for x in vs) + ' 0')
    lines.append(' '.join(str(x+1) for x in vs) + ' 0')
cnf_path = sys.argv[1].replace('.json', '.cnf')
same = open(cnf_path).read().split('\n')[:len(lines)] == lines
if cert['vertices'][cert['unit_red']] not in ([1, 0, 0], [1]): bad.append(('unit not vertex 1',))
# numeric spot checks
kmax = int(sys.argv[2]) if len(sys.argv) > 2 else k0+200
def ev(p, k): return sum(c*k**i for i, c in enumerate(p))
numbad = 0
for k in list(range(k0, kmax+1)) + [10**3, 10**4, 10**6]:
    Fk = ev(F, k)
    vals = [ev(p, k) for p in V]
    for e in cert['edges']:
        S = [vals[e['a']]] + [vals[o] for m, o in e['others']]
        mult = [k-e['c']] + [m for m, o in e['others']]
        w = vals[e['w']]
        ok = (len(set(S)) == l and min(mult) >= 1 and sum(mult) == k and sum(m*x for m, x in zip(mult, S)) == w
              and all(1 <= x <= Fk for x in S+[w]) and w not in S)
        if not ok: numbad += 1
print(f"cert l={l} k0={k0} F_extra={FX}: vertices={len(V)} edges={len(cert['edges'])} symbolic_problems={len(bad)} cnf_matches={same} numeric_problems={numbad} (k={k0}..{kmax} + 3 large)")
for b in bad[:20]: print('  ', b)
sys.exit(0 if (not bad and same and numbad == 0) else 1)
