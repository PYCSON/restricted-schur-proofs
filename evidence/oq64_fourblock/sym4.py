import sympy as sp
l, e, j = sp.symbols('l e j', integer=True, positive=True)
k = l + e
E = (l-1)*(l-2)/sp.Integer(2); D = l*(l-1)/sp.Integer(2)
F = k**2 + ((l+1)*(l-2)/sp.Integer(2) + 2)*k + l*(l-2)
m = e + (l-1)*(j+2) + E                     # red block [j+2, m]; min red k-sum is m+1
V = j*(j+3)/sp.Integer(2) + (l-j)*m + (l-j)*(l-j+1)/sp.Integer(2) + 2*e   # min blue k-sum (j <= l-1)
G = sp.expand(V - F)                        # colouring of [1,V-1] good; beats F iff G>0
print("m =", sp.expand(m)); print("V =", sp.expand(V)); print("F =", sp.expand(F))
print("G = V - F =", sp.collect(G, [l, e, j]))
for r in range(4):
    Gr = sp.expand(G.subs(j, (l - r)/sp.Integer(4)))
    print(f"j=(l-{r})/4:  G =", sp.collect(Gr, [l, e]))
