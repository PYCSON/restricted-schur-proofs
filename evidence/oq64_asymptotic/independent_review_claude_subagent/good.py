#!/usr/bin/env python3
"""Independent goodness checker.
A 2-colouring col[1..n] (values 'R'/'B') is GOOD for (k,l) iff no colour class C contains
x_1..x_k (repetition allowed) with exactly l distinct values and sum y in C.
DP: dp[c][t] = bitset of sums of c distinct elements of C (so far) + t extra copies (t<=e)."""
import itertools

def F(k, l):
    return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)

def sums_exact(C, k, l, n):
    """bitset (int) of all sums <= n of k-term multisets from C with exactly l distinct values"""
    e = k - l
    mask = (1 << (n+1)) - 1
    dp = [[0]*(e+1) for _ in range(l+1)]
    dp[0][0] = 1
    for x in sorted(C):
        if x > n: break
        for c in range(l-1, -1, -1):
            row = dp[c]; nxt = dp[c+1]
            for t in range(e, -1, -1):
                src = row[t]
                if not src: continue
                for a in range(0, e-t+1):
                    sh = x*(1+a)
                    if sh > n: break
                    nxt[t+a] |= (src << sh) & mask
    return dp[l][e]

def bad_witness(col, k, l):
    """return (colour, y) of a monochromatic solution, or None if good"""
    n = len(col)-1
    for c in 'RB':
        C = [x for x in range(1, n+1) if col[x] == c]
        if len(C) < l+1: continue
        S = sums_exact(C, k, l, n)
        for y in C:
            if (S >> y) & 1:
                return (c, y)
    return None

def is_good(col, k, l):
    return bad_witness(col, k, l) is None

def naive_bad(col, k, l):
    n = len(col)-1
    for c in 'RB':
        C = [x for x in range(1, n+1) if col[x] == c]
        Cs = set(C)
        for S in itertools.combinations(C, l):
            e = k-l
            for extra in itertools.combinations_with_replacement(S, e):
                y = sum(S)+sum(extra)
                if y in Cs: return (c, y)
    return None

def find_solution(col, k, l, y):
    """explicit multiset with exactly l distinct values of colour col[y] summing to y (search)"""
    c = col[y]; e = k-l
    C = [x for x in range(1, y) if col[x] == c]
    # DFS with pruning using DP bitsets from the top
    import functools
    best = None
    def rec(idx, cnt, t, s, chosen):
        nonlocal best
        if best is not None: return
        if cnt == l and t == e:
            if s == y: best = list(chosen)
            return
        if idx < 0: return
        x = C[idx]
        # include x with multiplicity 1+a
        if cnt < l:
            for a in range(e-t, -1, -1):
                v = x*(1+a)
                if s+v <= y:
                    chosen.append((x, 1+a)); rec(idx-1, cnt+1, t+a, s+v, chosen); chosen.pop()
                    if best is not None: return
        rec(idx-1, cnt, t, s, chosen)
    rec(len(C)-1, 0, 0, 0, [])
    return best

def gaiser(k, l):
    D = l*(l-1)//2
    s = k + D; t = k*s + D; Fv = F(k, l)
    col = [None] + ['R' if (x < s or x >= t) else 'B' for x in range(1, Fv)]
    return col

def threeblock(l, e, j):
    m = l*(l+1)//2 + l*j + e*(j+1) - 1
    V3 = j*(j+1)//2 + (l-j)*(m+1) + (l-j)*(l-j-1)//2 + e
    col = [None] + ['R' if (x <= j or x >= m+1) else 'B' for x in range(1, V3)]
    return col, V3, m

def fourblock(l, e, j):
    m = e + (l-1)*j + l*(l+1)//2 - 1
    V = j*(j+3)//2 + (l-j)*m + (l-j)*(l-j+1)//2 + 2*e
    col = [None] + ['R' if (x == 1 or (j+2 <= x <= m)) else 'B' for x in range(1, V)]
    return col, V, m
