"""Checks the constructive proof of prefix dominance for reduced case-II windows (majority blue, 1 in D,
S u D = [1, l+j]) and probes case I (majority red) for a 'good tuple' (y != m1, r' among the q+1 least)."""
import sys, itertools
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def w_of(S, D, q, e, y, rp, d):
    b = y + rp - d
    Rp = [x for x in S if x != y]; u = min(Rp); r = min(x for x in S if x != rp)
    z = sorted(x for x in S if x not in (r, rp))[:q-1]
    db = min(x for x in D if x != b); S0 = sum(S) + (e-1)*u
    return sum(Rp) + sum(D) + q*S0 + sum(z) + r + d + e*db + (e-1)*u
def Pw(l,e,j):
    q=l-j
    return (q+1)*(l*j+l*(l+1)//2)+j*(j+1)//2+(q+1)*(e-1)*(j+1)+(q+1)*j+(q+1)*(q+2)//2-j+e
def construct_II(S, D, l, j):
    q = l - j; Sset = set(S); m1 = S[0]
    p = 1
    while p < j and D[p] == p + 1: p += 1          # D contains [1,p], p+1 not in D (or p = j)
    istar = max(i for i in range(1, j+1) if D[i-1] - i <= q + p - 1)
    if istar > p:
        b = D[istar-1]; g = b - m1
        for y in S:
            if y > b and (y - g) in Sset: return (y, m1, y - g)
        return None
    if istar == p and p >= 2:
        return (p + 2, m1, p + 3) if {p+2, p+3} <= Sset else None   # b = p
    if p == j: return (j + 2, j + 1, j + 3)        # the prefix itself, b = j
    # istar == p == 1
    D2 = D[1]; return (D2 - q, q + 2, 2)
l = int(sys.argv[1]); es = [1, 2, 3, 5, 8]
nII = badII = nI = noGoodI = 0
for j in range(2, l - 1):
    q = l - j
    for rest in itertools.combinations(range(2, l + j), j - 1):        # case II: D = {1} u rest, D_j < l+j
        D = [1] + list(rest); S = [x for x in range(1, l + j + 1) if x not in D]
        nII += 1; t = construct_II(S, D, l, j)
        ok = t is not None
        if ok:
            y, rp, d = t; b = y + rp - d
            ok = (y in S and rp in S and d in S and d not in (y, rp) and b in D and b != 1 and y != S[0] and rp in S[:q+1])
            if ok:
                for e in es:
                    if w_of(S, D, q, e, y, rp, d) > Pw(l, e, j): ok = False
        if not ok:
            badII += 1
            if badII < 5: print('caseII FAIL', D, t)
    for Dt in itertools.combinations(range(2, l + j), j):              # case I: 1 in S
        D = list(Dt); S = [x for x in range(1, l + j + 1) if x not in D]; Sset = set(S); nI += 1
        good = any((y + rp - d) in Dt and d not in (y, rp) and y != 1
                   for rp in S[:q+1] for y in S for d in S)
        if not good:
            noGoodI += 1
            if noGoodI < 5: print('caseI no good tuple', D)
print(f'l={l} caseII windows={nII} failures={badII} | caseI windows={nI} without good tuple={noGoodI}')
