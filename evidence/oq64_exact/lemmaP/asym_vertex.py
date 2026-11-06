"""Vertex range for the lower-bound argument (Theorem Q'): with e = a*l - 3.63 and l = 19 + u, show
3/2 <= j* <= l - 3/2, where j* = beta/(2A) is the vertex of G_L = V3 - F.  Then the integer j nearest to j*
lies in [1, l-1].  Both differences are (polynomial in u)/(positive), with all numerator coefficients >= 0."""
import sympy as sp
u = sp.symbols('u'); a = (sp.sqrt(2) - 1) / 2
lS, eS, jS = sp.symbols('l e j')
m = lS*(lS+1)/2 + lS*jS + eS*(jS+1) - 1
V3 = jS*(jS+1)/2 + (lS-jS)*(m+1) + (lS-jS)*(lS-jS-1)/2 + eS
k = lS + eS; F = k**2 + ((lS+1)*(lS-2)/2 + 2)*k + lS*(lS-2)
G = sp.Poly(sp.expand(V3 - F), jS)
A = -G.coeff_monomial(jS**2); beta = G.coeff_monomial(jS)
sub = {lS: 19 + u, eS: a*(19 + u) - sp.Rational(363, 100)}
A_ = sp.expand(A.subs(sub)); b_ = sp.expand(beta.subs(sub))
for name, num in [('j* - 3/2', b_ - 3*A_), ('l - 3/2 - j*', 2*A_*(19 + u) - 3*A_ - b_)]:
    P = sp.Poly(sp.expand(num), u)
    print(name, '* 2A: coefficient signs', [sp.sign(sp.N(c, 50)) for c in P.all_coeffs()])
PA = sp.Poly(A_, u); print('A coefficient signs', [sp.sign(sp.N(c, 50)) for c in PA.all_coeffs()])
