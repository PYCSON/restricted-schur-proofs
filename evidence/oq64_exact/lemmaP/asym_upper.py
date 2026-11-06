"""Analytic check of the upper constant in Theorem Q (exact sympy, sqrt(2) symbolic).
G_P(l,e,j) = -A j^2 + beta j + gamma with A = e+l-1, beta = e*l + (l^2-l-2)/2, gamma = -e^2 - e(l^2+l-2)/2 + 2l.
max over real j is gamma + beta^2/(4A); it is < 0 iff Disc := beta^2 + 4*A*gamma < 0.
Claim: with e = a*l + c (c = 0) and l = l0 + u (u >= 0), Disc is a polynomial in u all of whose coefficients are < 0.
Also dG_P/de < 0, so the same holds for every real e >= a*l + c."""
import sympy as sp
u, c = sp.symbols('u c')
a = (sp.sqrt(2) - 1) / 2
def disc(l, e):
    A = e + l - 1; beta = e*l + (l**2 - l - 2)/sp.Integer(2); gamma = -e**2 - e*(l**2 + l - 2)/sp.Integer(2) + 2*l
    return sp.expand(beta**2 + 4*A*gamma)
for l0, cc in [(19, 0), (50, 0), (100, 0), (19, sp.Rational(-1, 2)), (1000, sp.Rational(-1, 2)), (19, sp.Rational(-7, 10))]:
    l = l0 + u; e = a*l + cc
    P = sp.Poly(sp.expand(disc(l, e)), u)
    co = [sp.nsimplify(x) for x in P.all_coeffs()]
    signs = [sp.sign(sp.N(x, 50)) for x in co]
    print(f'l0={l0} c={cc}: degree {P.degree()}, coefficient signs (high->low) {signs}',
          ' ALL NEGATIVE' if all(s < 0 for s in signs) else ' not all negative', flush=True)
