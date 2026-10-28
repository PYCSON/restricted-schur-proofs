#!/usr/bin/env python3
"""For 24 <= l <= L: the largest e such that some four-block colouring (Theorem 5,
witnessed by an explicit j) beats F(l+e, l). Prints the exceptions to e = floor((l-18)/8)."""
import sys
def F(k, l): return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)
def V(k, l, j):
    e = k - l; m = e + (l-1)*j + l*(l+1)//2 - 1
    return j*(j+3)//2 + (l-j)*m + (l-j)*(l-j+1)//2 + 2*e
def bestV(k, l):
    # V - F is concave in j (coefficient 2-l); vertex j* = (l^2-5l+4-2e)/(4(l-2))
    e = k - l; j0 = (l*l - 5*l + 4 - 2*e) // (4*(l-2))
    return max((V(k, l, j), j) for j in range(max(1, j0-3), min(l-1, j0+5)+1))
L = int(sys.argv[1]) if len(sys.argv) > 1 else 3000
ex = []
for l in range(24, L+1):
    e = 0
    while bestV(l+e+1, l)[0] > F(l+e+1, l): e += 1
    if e != (l-18)//8: ex.append((l, e, (l-18)//8))
print("exceptions (l, e_max, floor((l-18)/8)) for 24<=l<=%d:" % L, ex)
