"""Analytic check of the lower constant (three-block family, Proposition 19), exact sympy.
G_L(l,e,j) = V3 - F = -A j^2 + beta j + gamma, A = e+l-1.  Some integer j has G_L >= 1 as soon as
H := 4*A*gamma + beta^2 - A^2 - 4*A >= 0 (integer j within 1/2 of the vertex loses at most A/4).
With e = a*l - c and l = l0 + u, check that all coefficients of H (as a polynomial in u) are >= 0, and that the
vertex lies in [1, l-1].  Then K(l) >= l + e_int + 1 > (1+a*)l - c for the integer e_int in (a*l-c-1, a*l-c]."""
import sympy as sp
u = sp.symbols('u')
a = (sp.sqrt(2) - 1) / 2
lS, eS, jS = sp.symbols('l e j')
m = lS*(lS+1)/2 + lS*jS + eS*(jS+1) - 1
V3 = jS*(jS+1)/2 + (lS-jS)*(m+1) + (lS-jS)*(lS-jS-1)/2 + eS
k = lS + eS; F = k**2 + ((lS+1)*(lS-2)/2 + 2)*k + lS*(lS-2)
G = sp.Poly(sp.expand(V3 - F), jS)
A = -G.coeff_monomial(jS**2); beta = G.coeff_monomial(jS); gamma = G.coeff_monomial(1)
assert sp.simplify(A - (eS + lS - 1)) == 0
H = sp.expand(4*A*gamma + beta**2 - A**2 - 4*A)
jstar = beta / (2*A)
for c in [sp.Rational(4), sp.Rational(37, 10), sp.Rational(73, 20), sp.Rational(363, 100)]:
    for l0 in [19, 50, 100, 300, 1000]:
        sub = {lS: l0 + u, eS: a*(l0 + u) - c}
        P = sp.Poly(sp.expand(H.subs(sub)), u)
        signs = [sp.sign(sp.N(x, 60)) for x in P.all_coeffs()]
        js = sp.N(jstar.subs({lS: l0, eS: a*l0 - c}), 8)
        ok = all(s >= 0 for s in signs)
        print(f'c={float(c):.3f} l0={l0}: signs {signs} {"ALL >= 0" if ok else "not all >= 0"}; j*(l0)={js}', flush=True)
        if ok: break
