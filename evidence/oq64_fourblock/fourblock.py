#!/usr/bin/env python3
# Four-block colourings R{1} | B[2,j+1] | R[j+2,m] | B[m+1,M] for S_2(k;l)
# (solutions x_1+..+x_k=y whose summands take exactly l distinct values).
# Closed-form min/max sums; returns the largest M for which the colouring is good
# (so S_2(k;l) >= M+1), maximised over j.  Verified separately by exactcheck.py.
import sys
def F(k, l): return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)
def minsum(vals, k, l):   # vals sorted ascending, len>=l
    return sum(vals[:l]) + (k-l)*vals[0]
def best4(k, l):
    E = (l-1)*(l-2)//2; D = l*(l-1)//2
    best = None
    jmax = (l-1)**2 + l + 2*k   # generous
    for j in range(1, jmax+1):
        m = (k-l) + (l-1)*(j+2) + E           # largest m with min red sum > m
        if m < j+2: continue
        # small-blue-only sums (need j >= l)
        if j >= l:
            mn = sum(range(2, l+2)) + (k-l)*2
            mx = sum(range(j+2-l, j+2)) + (k-l)*(j+1)
            if mn <= j+1: continue            # lands in small blue
            if mx > m: continue               # may land in big blue
        # min blue sum using >=1 big element: take smallest l distinct overall
        # among small blues (2..j+1) and big (m+1..), requiring at least one big
        small = list(range(2, j+2))
        if j >= l:
            vals = small[:l-1] + [m+1]
        else:
            vals = small + list(range(m+1, m+1+(l-j)))
        V = sum(vals) + (k-l)*2
        M = V - 1
        if best is None or M > best[0]:
            best = (M, j, m)
    return best
if __name__ == "__main__":
    lo, hi = int(sys.argv[1]), int(sys.argv[2])
    for l in range(lo, hi+1):
        row = []
        Kneed = None
        for k in range(l, l+3*l+50):
            M, j, m = best4(k, l)
            if M + 1 > F(k, l):
                Kneed = k
        # Kneed = largest k where four-block beats F  => K(l) >= Kneed+1
        M, j, m = best4(l+1, l)
        print(f"l={l:3d} k=l+1: F={F(l+1,l):8d} best4={M+1:8d} (j={j},m={m}) margin={M+1-F(l+1,l):6d}  "
              f"largest k with best4>F: {Kneed}  => K(l) >= {Kneed+1 if Kneed else '-'}")
