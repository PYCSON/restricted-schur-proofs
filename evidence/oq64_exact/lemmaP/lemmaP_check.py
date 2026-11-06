"""Check of the constructive proof of Lemma P (prefix dominance) on ALL windows of [1,2l] of case (U)
with 2 <= j <= l-2.  For each window W the proof names a parameter tuple (y, r', d); we check that it is
admissible for W and that w(W; tuple) <= w*(P_{j'}), the exact T1-fill minimum of the prefix window
P_{j'} (red = [1, j'], blue = the rest), where j' = |D ∩ [1, m_l]| if that is >= 2 and j' = j otherwise.
usage: lemmaP_check.py l e1 e2 ...   (prints the number of windows and of failures)"""
import sys, itertools
def F(k, l): return k*k + ((l+1)*(l-2)//2 + 2)*k + l*(l-2)
def w_of(S, D, q, e, y, rp, d):
    b = y + rp - d
    Rp = [x for x in S if x != y]; u = min(Rp); r = min(x for x in S if x != rp)
    z = sorted(x for x in S if x not in (r, rp))[:q-1]
    db = min(x for x in D if x != b); S0 = sum(S) + (e-1)*u
    return sum(Rp) + sum(D) + q*S0 + sum(z) + r + d + e*db + (e-1)*u
def Pw(l, e, j):
    q = l - j
    return (q+1)*(l*j + l*(l+1)//2) + j*(j+1)//2 + (q+1)*(e-1)*(j+1) + (q+1)*j + (q+1)*(q+2)//2 - j + e
def tuple_reduced(S, D, l, j, case):
    """S u D = [1, l+j]; returns (y, r', d)."""
    q = l - j; Sset = set(S); m1 = S[0]
    if case == 'II':                                   # 1 in D
        p = 1
        while p < j and D[p] == p + 1: p += 1
        if p == j: return (j + 2, j + 1, j + 3)
        istar = max(i for i in range(1, j + 1) if D[i-1] - i <= q + p - 1)
        if istar > p:
            b = D[istar-1]; g = b - m1
            for y in S:
                if y > b and (y - g) in Sset: return (y, m1, y - g)
            return None
        if p >= 2: return (p + 2, p + 1, p + 3)
        return (D[1] - q, q + 2, 2)
    # case I: 1 in S
    if 2 in Sset: return (D[-1] + 1, 1, 2)            # b = D_j
    for x in S[1:]:
        if x + 1 in Sset: return (x + 1, 1, x)         # b = 2 = D_1
    return None
def tuple_low(S, D, l, j, kind):
    Sset = set(S)
    if kind == 'L2':                                   # S = [2, l+1], 1 in D
        beta = min(x for x in D if x > 1); return (l + 1, beta - l + 1, 2)
    if kind == 'L0':                                   # S = [1, l]
        if D[1] <= 2*l - 1: return (l, D[1] + 1 - l, 1)   # b = D_2
        return (l, D[0] + 1 - l, 1)                       # j = 2, D = {D_1, 2l}: b = D_1
    # L1: S = [1, l+1] \ {a}
    a = D[0]; beta = min(x for x in D if x > l + 1)
    if beta - l != a: return (l + 1, beta - l, 1)
    if a != 2: return (l + 1, a + 1, 2)
    return (l + 1, 4, 3)
l = int(sys.argv[1]); es = [int(x) for x in sys.argv[2:]]
n = fails = 0
for bits in range(1 << (2*l - 1)):
    col = [None, 1] + [(bits >> (x - 2)) & 1 for x in range(2, 2*l + 1)]   # 1 = red = colour of 1
    R = [x for x in range(1, 2*l + 1) if col[x]]; B = [x for x in range(1, 2*l + 1) if not col[x]]
    if len(R) >= l + 2: M, D, case = R, B, 'I'
    elif len(B) >= l + 2: M, D, case = B, R, 'II'
    else: continue
    j = len(D)
    if not (2 <= j <= l - 2): continue
    q = l - j; S = M[:l]; ml = S[-1]; Dp = [x for x in D if x <= ml]
    n += 1
    if len(Dp) >= 2:
        jp = len(Dp); Sp = S; t = tuple_reduced(Sp, Dp, l, jp, case); ref = jp
        assert sorted(Sp + Dp) == list(range(1, l + jp + 1))
    else:
        kind = 'L2' if case == 'II' else ('L0' if not Dp else 'L1'); t = tuple_low(S, D, l, j, kind); ref = j
    ok = t is not None
    if ok:
        y, rp, d = t; b = y + rp - d
        ok = y in S and rp in S and d in S and d not in (y, rp) and b in D
        if ok:
            for e in es:
                if w_of(S, D, q, e, y, rp, d) > Pw(l, e, ref): ok = False; break
    if not ok:
        fails += 1
        if fails <= 5: print('FAIL', ''.join('R' if col[x] else 'B' for x in range(1, 2*l + 1)), case, t)
print(f'l={l} e={es} windows={n} failures={fails}')
