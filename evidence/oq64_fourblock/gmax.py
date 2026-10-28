import sympy as sp
l, e, j = sp.symbols('l e j', real=True)
m = e + (l-1)*j + l*(l+1)/2 - 1
V = j*(j+3)/2 + (l-j)*m + (l-j)*(l-j+1)/2 + 2*e
Fk = (l+e)**2 + ((l+1)*(l-2)/2 + 2)*(l+e) + l*(l-2)
G = sp.expand(V - Fk)
a = sp.Poly(G, j).coeff_monomial(j**2); b = sp.Poly(G, j).coeff_monomial(j); c0 = sp.Poly(G, j).coeff_monomial(1)
print("a =", sp.factor(a))
jstar = sp.simplify(-b/(2*a)); print("j* =", sp.factor(jstar))
Gmax = sp.simplify(c0 - b**2/(4*a))
# substitute e = (l-17)/8 (the first integer e above (l-18)/8 when l = 1 mod 8; for other residues the next e is larger)
G17 = sp.factor(sp.together(Gmax.subs(e, (l-17)/sp.Integer(8))))
print("Gmax at e=(l-17)/8:", G17)
num, den = sp.fraction(sp.together(G17))
print("numerator:", sp.expand(num)); print("denominator:", sp.factor(den))
print("real roots of numerator:", [sp.N(r, 6) for r in sp.Poly(sp.expand(num), l).real_roots()])
dG = sp.simplify(sp.diff(Gmax, e)); print("dGmax/de =", sp.factor(dG))
