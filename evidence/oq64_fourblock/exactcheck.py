#!/usr/bin/env python3
# Independent exact checker (fresh code, no shared code with numfast/numeng).
# A colouring of [1,N] is good for (k,l) iff no colour class S contains x_1..x_k, y
# with x_1+...+x_k = y and the summands taking EXACTLY l distinct values
# (then y > every summand, so the solution has exactly l+1 distinct integers).
# DP over elements: D[c][d] = bitset of sums using c summands with d distinct values.
import sys
def sums_exact(S, k, l, N):
    mask = (1 << (N + 1)) - 1
    D = [[0] * (l + 1) for _ in range(k + 1)]
    D[0][0] = 1
    maxmult = k - l + 1
    for v in sorted(S):
        for c in range(k - 1, -1, -1):
            for d in range(min(l - 1, c), -1, -1):
                src = D[c][d]
                if not src:
                    continue
                for mu in range(1, min(maxmult, k - c) + 1):
                    sh = (src << (mu * v)) & mask
                    if sh:
                        D[c + mu][d + 1] |= sh
    return D[k][l]
def check(k, l, N, red):
    red = set(x for x in red if 1 <= x <= N)
    blue = set(range(1, N + 1)) - red
    out = []
    for name, S in (("red", red), ("blue", blue)):
        bits = 0
        for x in S:
            bits |= 1 << x
        hit = sums_exact(S, k, l, N) & bits
        out.append((name, len(S), hit))
    return out
if __name__ == "__main__":
    k, l, N = map(int, sys.argv[1:4])
    # red blocks given as a:b pairs
    red = []
    for blk in sys.argv[4:]:
        a, b = map(int, blk.split(":"))
        red.extend(range(a, b + 1))
    for name, size, hit in check(k, l, N, red):
        if hit:
            y = (hit & -hit).bit_length() - 1
            print(f"{name}: size={size} MONOCHROMATIC solution with sum y={y}")
        else:
            print(f"{name}: size={size} no monochromatic solution")
