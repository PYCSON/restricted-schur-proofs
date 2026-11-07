#!/usr/bin/env python3
"""Theorem 29 (preprint v1.3), the upper constant c0 = 16 - 11*sqrt(2): exact checks with sympy.

Let G_P(l,e,j) = -A j^2 + beta j + gamma with A = e + l - 1 (eq. (3) of the preprint) and
Disc = beta^2 + 4 A gamma.  G_P < 0 for every real j iff Disc < 0, and dG_P/de < 0.
(1) For l = 55 + u, u >= 0, and e = a* l + c0 - 1: every coefficient of Disc as a polynomial in u
    is negative (exact arithmetic in Q(sqrt 2)).  Hence e_P(l) <= ceil(a* l + c0 - 1) < a* l + c0.
(2) For 19 <= l <= 54: e_P(l) computed exactly satisfies e_P(l) - a* l <= c0, with equality at l = 22,
    and e_P(l) >= 4 (so max(3, e_P) = e_P).
Prints a summary line; exits 1 on any failure.  The same facts are checked by the second party's
../independent_review_gpt/r9_math_audit.py.
"""
import sys
import sympy as sp

if not __debug__:
    sys.exit('refusing to run with assertions disabled')

l, e, j, u = sp.symbols('l e j u')
s2 = sp.sqrt(2)
a = (s2 - 1) / 2
c0 = 16 - 11 * s2
GP = -e**2 - e * (l**2 + l - 2) / 2 - (e + l - 1) * j**2 + (e * l + (l**2 - l - 2) / 2) * j + 2 * l
poly = sp.Poly(sp.expand(GP), j)
A = -poly.coeff_monomial(j**2); beta = poly.coeff_monomial(j); gamma = poly.coeff_monomial(1)
assert sp.simplify(A - (e + l - 1)) == 0
assert sp.simplify(sp.diff(GP, e)) == sp.simplify(-2 * e - (l**2 + l - 2) / 2 - j**2 + l * j)
disc = sp.expand(beta**2 + 4 * A * gamma)

# (1) l >= 55
d55 = sp.Poly(sp.expand(disc.subs(e, a * l + c0 - 1).subs(l, 55 + u)), u)
coefs = [sp.nsimplify(sp.radsimp(c)) for c in d55.all_coeffs()]
assert len(coefs) == 4, coefs
signs = []
for c in coefs:
    c = sp.radsimp(c)
    # exact sign of p + q*sqrt(2): compare p^2 and 2 q^2 with the signs of p, q
    p, q = c.as_coefficients_dict()[1], c.as_coefficients_dict()[s2]
    p, q = sp.Rational(p), sp.Rational(q)
    if p < 0 and q < 0: neg = True
    elif p >= 0 and q >= 0: neg = False
    elif p < 0: neg = p * p > 2 * q * q      # p < 0 <= q
    else: neg = 2 * q * q > p * p            # q < 0 <= p
    signs.append(neg)
assert all(signs), (coefs, signs)

# (2) 19 <= l <= 54, exact e_P
def eP(L):
    t = 1
    while True:
        if all(GP.subs({l: L, e: t, j: J}) <= 0 for J in range(2, L - 1)):
            return t
        t += 1
tight = None
for L in range(19, 55):
    t = eP(L)
    assert t >= 4, (L, t)
    gap = sp.nsimplify(t - a * L - c0)
    assert sp.simplify(gap) <= 0, (L, t, gap)
    if sp.simplify(gap) == 0: tight = (L, t)
assert tight == (22, 5), tight
print(f'c0 = 16 - 11 sqrt2 ~ {float(c0):.4f}: Disc coefficients at l = 55+u all negative ({len(coefs)} coefficients); '
      f'e_P(l) - a* l <= c0 for 19 <= l <= 54, equality only at l = 22 (e_P = 5); e_P >= 4 throughout. PASS')
