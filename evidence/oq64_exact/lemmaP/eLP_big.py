"""e_L(l) = max e with max_j V3 - F >= 1 (three-block good on [1,F]); e_P(l) = least e with max_j (w*(P_j) - F) <= 0.
Exact integers; the maximum over j uses that both are concave quadratics in j.  Prints l, e_L, e_P, e_P - e_L, (l + e_L + 1) - (1+a*)l, (l + max(3,e_P)) - (1+a*)l."""
import sys, math
from fractions import Fraction
def F(k, l): return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)
def Pw(l, e, j):
    q = l - j
    return (q+1)*(l*j + l*(l+1)//2) + j*(j+1)//2 + (q+1)*(e-1)*(j+1) + (q+1)*j + (q+1)*(q+2)//2 - j + e
def V3(l, e, j):
    m = l*(l+1)//2 + l*j + e*(j+1) - 1
    return j*(j+1)//2 + (l-j)*(m+1) + (l-j)*(l-j-1)//2 + e
def maxj(f, l, e):
    # f(l,e,j) is a quadratic in j with leading coefficient -(e+l-1) < 0: evaluate near the vertex only
    a = f(l, e, 1) - 2*f(l, e, 2) + f(l, e, 3)          # second difference = 2*(leading coeff)
    assert a < 0
    b1 = f(l, e, 3) - f(l, e, 2)                           # f(j+1)-f(j) at j=2
    # f(j+1)-f(j) = b1 + a*(j-2); vertex where this changes sign
    jv = 2 + (-b1) // a if a != 0 else 2
    cands = {2, l - 2} | {min(max(x, 2), l - 2) for x in range(jv - 2, jv + 3)}
    best = max(f(l, e, j) for j in cands)
    return best
astar = (math.sqrt(2) - 1) / 2
L1, L2, step = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
for l in range(L1, L2 + 1, step):
    e0 = max(1, int(astar * l) - 8)
    # e_L: largest e with max_j V3 - F >= 1 ; G decreasing in e
    e = e0
    assert maxj(V3, l, e) - F(l + e, l) >= 1 or e == 1
    while maxj(V3, l, e + 1) - F(l + e + 1, l) >= 1: e += 1
    eL = e if maxj(V3, l, e) - F(l + e, l) >= 1 else 0
    e = max(1, eL)
    while maxj(Pw, l, e) - F(l + e, l) > 0: e += 1
    eP = e
    print(l, eL, eP, eP - eL, round(l + eL + 1 - (1 + astar) * l, 4), round(l + max(3, eP) - (1 + astar) * l, 4), flush=True)
