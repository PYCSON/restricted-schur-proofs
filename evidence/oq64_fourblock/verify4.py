#!/usr/bin/env python3
"""Bookkeeping for the four-block lower bound (no search involved).

Colouring of [1, V-1]:  red = {1} u [j+2, m],  blue = [2, j+1] u [m+1, V-1], where
  e = k - l >= 0,  1 <= j <= l-1,
  m = e + (l-1)j + l(l+1)/2 - 1,
  V = j(j+3)/2 + (l-j)m + (l-j)(l-j+1)/2 + 2e.
Fact: a k-multiset with exactly l distinct values from a set S has sum
  >= (sum of the l smallest elements of S) + (k-l)*min S.
Red: min k-sum = 1+(j+2)+...+(j+l)+(k-l) = m+1 > max red.  Blue: min k-sum = V.
Hence S_2(k;l) >= V(k,l,j).  Every bound below is witnessed by an explicit j.
"""
import sympy as sp
def F(k, l): return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)
def V(k, l, j):
    e = k - l; m = e + (l-1)*j + l*(l+1)//2 - 1
    return j*(j+3)//2 + (l-j)*m + (l-j)*(l-j+1)//2 + 2*e
def bestV(k, l, full=False):
    if full or l < 8:
        js = range(1, l)
    else:  # V - F is concave in j (coefficient 2-l), vertex j* = (l^2-5l+4-2e)/(4(l-2))
        e = k - l; js0 = (l*l - 5*l + 4 - 2*e) // (4*(l-2))
        js = [j for j in range(js0-3, js0+5) if 1 <= j <= l-1]
    return max((V(k, l, j), j) for j in js)
def WS_ABRS(k): return (k**3 + 4*k*k - 5*k + 2)//2
# cross-check the windowed optimiser against the full loop
for l in range(5, 260):
    for k in range(l, l + l//4 + 6):
        assert bestV(k, l) == bestV(k, l, full=True), (k, l)
print("windowed optimiser == full loop for 5<=l<260")
L = 5000
emax = {}
for l in range(5, L+1):
    e = 0
    while bestV(l+e+1, l)[0] > F(l+e+1, l): e += 1
    emax[l] = e
first = min(l for l in emax if emax[l] >= 1)
print("smallest l with S2(l+1;l) > F(l+1,l) via four-block:", first)
print("emax(l)>=1 for all l in [%d,%d]:" % (first, L), all(emax[l] >= 1 for l in range(first, L+1)))
C = None
for c in range(10, 60):
    if all(emax[l] >= max(1, (l - c)//8) for l in range(24, L+1)):
        C = c; print("for all 24<=l<=%d: emax(l) >= max(1, floor((l-%d)/8))" % (L, c)); break
for l in (24, 25, 26, 30, 32, 40, 50, 64, 100, 200, 500, 1000, 2000, 5000):
    print(f"  l={l}: four-block beats F for k=l+1..l+{emax[l]}  =>  K(l) >= {l+emax[l]+1}  (K/l >= {(l+emax[l]+1)/l:.4f})")
# symbolic tail: for l > L use real e <= (l-C)/8 and j=(l-r)/4 (l = r mod 4); G decreasing in e
l, e = sp.symbols('l e', positive=True)
for r in range(4):
    j = (l - r)/sp.Integer(4)
    m = e + (l-1)*j + l*(l+1)/2 - 1
    Vs = j*(j+3)/2 + (l-j)*m + (l-j)*(l-j+1)/2 + 2*e
    Fs = (l+e)**2 + ((l+1)*(l-2)/2 + 2)*(l+e) + l*(l-2)
    G = sp.expand(Vs - Fs)
    dGde = sp.expand(sp.diff(G, e))
    Gc = sp.expand(G.subs(e, (l - C)/sp.Integer(8)))
    rr = [x for x in sp.Poly(Gc, l).nroots() if abs(sp.im(x)) < 1e-12]
    print(f" r={r}: dG/de={dGde} (<0 for l>=1); G(e=(l-{C})/8)={Gc}; real roots {[round(float(sp.re(x)),2) for x in rr]}")
firstd = min(k for k in range(5, 400) if bestV(k, k)[0] > WS_ABRS(k))
print("diagonal k=l: smallest k with four-block > ABRS bound (k^3+4k^2-5k+2)/2:", firstd,
      "; holds for all k in [%d,%d]:" % (firstd, L), all(bestV(k, k)[0] > WS_ABRS(k) for k in range(firstd, L+1)))
for k in (22, 25, 30, 50, 100):
    v, j = bestV(k, k); print(f"  k={k}: four-block {v} (j={j}) vs ABRS {WS_ABRS(k)}  ratio to k^3: {v/k**3:.4f}")
