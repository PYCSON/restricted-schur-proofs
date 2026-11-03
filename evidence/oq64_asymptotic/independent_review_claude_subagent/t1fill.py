#!/usr/bin/env python3
"""Independent implementation of the T1-fill template (THEOREM_ASYMPTOTIC.md section 3)."""
import itertools
from good import F

def other(c): return 'B' if c == 'R' else 'R'

def window_info(l, col):
    W = range(1, 2*l+1)
    R = [x for x in W if col[x] == 'R']; B = [x for x in W if col[x] == 'B']
    if len(R) >= len(B): Mc, Mw, Dw = 'R', R, B
    else: Mc, Mw, Dw = 'B', B, R
    return Mc, Mw, Dw

def wbound(l, j, e, caseI):
    """text's worst-case bound, written from the text (not from t1fill_bound.py)"""
    q = l - j
    sS1 = sum(j+i for i in range(1, l+1))
    sDW = sum(2*l-j+i for i in range(1, j+1))
    u = 1 if caseI else j+2
    sz = sum(j+i+2 for i in range(1, q))
    r = j+3; d = l+j; db = 2*l
    return sS1 + sDW + q*(sS1+(e-1)*u) + sz + r + d + e*db + (e-1)*u

class Fail(Exception): pass

def build(l, e, col, S1, y, rp, d, u, r, zs, db, Mc, Dw, N=None, chi=None, checkN=True):
    """Build all hyperedges explicitly, check every property; return dict of values.
    col: window colours (index <= 2l). chi: optional full colouring to compare forced colours."""
    k = l+e; Dc = other(Mc)
    if N is None: N = F(k, l)
    forced = {}
    def colour(x):
        if x <= 2*l: return col[x]
        if x not in forced: raise Fail(('uncoloured summand', x))
        return forced[x]
    def edge(ms, c):
        if len(ms) != k: raise Fail(('summand count', len(ms), k))
        if len(set(ms)) != l: raise Fail(('distinct count', len(set(ms)), l, sorted(set(ms))))
        if min(ms) < 1: raise Fail('nonpositive')
        for v in set(ms):
            if colour(v) != c: raise Fail(('summand colour', v, colour(v), c))
        return sum(ms)
    def force(x, c, tag):
        if x <= 2*l and col[x] != c: raise Fail(('forced into window with wrong colour', tag, x))
        if x in forced and forced[x] != c: return ('CLASH', x)
        forced[x] = c
        if chi is not None and x < len(chi) and chi[x] != c:
            return ('CHI', tag, x)
        return None
    S1 = list(S1)
    assert len(S1) == l and all(col[x] == Mc for x in S1)
    b = y + rp - d
    if b not in Dw: raise Fail('b not in D_W')
    Rp = [x for x in S1 if x != y]
    if u not in Rp: raise Fail('u not in R\'')
    if d not in Rp: raise Fail('d not in R\'')
    if r == rp or r not in S1: raise Fail('r')
    if len(zs) != len(set(zs)) or any(z in (r, rp) or z not in S1 for z in zs): raise Fail('z')
    base = S1 + [u]*(e-1)
    L1 = edge(base+[r], Mc); L2 = edge(base+[rp], Mc)
    Zs = [edge(base+[z], Mc) for z in zs]
    out = {}
    for tag, x in [('L1', L1), ('L2', L2)] + [('Z', z) for z in Zs]:
        res = force(x, Dc, tag)
        if res: out['early'] = res; return out
    B3 = [x for x in Dw if x != b] + Zs
    if len(B3) != l-2: raise Fail(('|B3|', len(B3)))
    if db not in B3: raise Fail('db not in B3')
    Mv = edge(B3 + [b, L1] + [db]*e, Dc)
    res = force(Mv, Mc, 'Mv')
    if res: out['early'] = res; return out
    w = edge(Rp + [Mv] + [u]*(e-1) + [d], Mc)
    wp = edge(B3 + [L1, L2] + [db]*e, Dc)
    if w != wp: raise Fail(('identity fails', w, wp))
    allv = [L1, L2, Mv, w] + Zs
    out.update(dict(L1=L1, L2=L2, Zs=Zs, Mv=Mv, w=w, maxval=max(allv)))
    r1 = force(w, Dc, 'w')
    r2 = force(wp, Mc, 'wp')
    out['res'] = (r1, r2)
    return out

def proof_choices(l, e, col):
    """yield parameter sets exactly as the proof prescribes, for every admissible triple
    (case I: only triples with y != 1, per the relabelling)."""
    Mc, Mw, Dw = window_info(l, col)
    j = len(Dw); q = l - j
    S1 = Mw[:l]; Dset = set(Dw)
    caseI = (Mc == 'R')
    for y in S1:
        for rp in S1:
            for d in S1:
                if d in (y, rp): continue
                b = y + rp - d
                if b not in Dset: continue
                if caseI and y == 1: continue
                Rp = [x for x in S1 if x != y]
                u = min(Rp)
                r = min(x for x in S1 if x != rp)
                zs = [x for x in S1 if x not in (r, rp)][:q-1]
                db = min(x for x in Dw if x != b)
                yield dict(S1=S1, y=y, rp=rp, d=d, u=u, r=r, zs=zs, db=db, Mc=Mc, Dw=Dw)

def triples_exist(l, col, require_y_ne1=False):
    Mc, Mw, Dw = window_info(l, col)
    S1 = Mw[:l]; Dset = set(Dw)
    for y in S1:
        for rp in S1:
            for d in S1:
                if d in (y, rp): continue
                if require_y_ne1 and y == 1: continue
                if y+rp-d in Dset: return True
    return False
