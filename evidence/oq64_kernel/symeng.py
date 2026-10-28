#!/usr/bin/env python3
"""Symbolic forcing engine for the exact-version S_2(k;l) <= F(k,l) on the region k >= k0.

Vertices are integer polynomials in k of degree <= 2, stored as (c0,c1,c2).
An identity ("edge") is   w = (k-c)*a + sum_i m_i*o_i   with
  - a  a vertex of degree <= 1 whose k-coefficient is 0 or 1 (big multiplicity k-c, c <= k0-1),
  - o_1..o_{l-1} further vertices with constant multiplicities m_i >= 1, sum m_i = c,
  - a,o_1..o_{l-1} pairwise distinct for every integer k >= k0 (sign-definite differences),
  - 1 <= w <= F(k,l) for every integer k >= k0.
Then for every k >= k0 the integers a(k),o_i(k),w(k) form a solution of x_1+..+x_k=x_{k+1} with exactly
l+1 distinct integers (w exceeds every summand), so they cannot all have the same colour.

Search: DPLL over colours of constants 2..; at each node unit-propagate over generated identities among
same-coloured vertices; stop a branch at a contradiction.  Output: the set of vertices/edges used and the
proof tree (for a CNF/LRAT certificate built separately)."""
import sys, itertools, json, time
from functools import lru_cache

def padd(p, q): return (p[0]+q[0], p[1]+q[1], p[2]+q[2])
def pscale(m, p): return (m*p[0], m*p[1], m*p[2])
def pmulk(c, a):   # (k-c)*a for a=(a0,a1,0)
    return (-c*a[0], a[0]-c*a[1], a[1])
def pval(p, k): return p[0] + p[1]*k + p[2]*k*k

class Region:
    def __init__(self, k0): self.k0 = k0
    @lru_cache(maxsize=None)
    def minval(self, p):
        """exact minimum of p(k) over integers k >= k0 (or None if unbounded below)"""
        c0, c1, c2 = p; k0 = self.k0
        if c2 < 0: return None
        if c2 == 0:
            if c1 < 0: return None
            return pval(p, k0)
        # c2 > 0: vertex at -c1/(2c2)
        v = -c1 / (2*c2)
        cands = [k0]
        for kk in (int(v)-1, int(v), int(v)+1, int(v)+2):
            if kk >= k0: cands.append(kk)
        return min(pval(p, kk) for kk in cands)
    def pos(self, p):
        m = self.minval(p); return m is not None and m > 0
    def nonneg(self, p):
        m = self.minval(p); return m is not None and m >= 0

def compositions(c, parts):
    if parts == 1:
        yield (c,); return
    for first in range(1, c-parts+2):
        for rest in compositions(c-first, parts-1):
            yield (first,)+rest

class Engine:
    def __init__(self, l, k0, cmax=None, Kgen=10**6, max_nonconst_others=None, verbose=False):
        self.l = l; self.k0 = k0
        self.D = l*(l-1)//2
        self.F = (l*l-2*l, self.D+1, 1)
        self.R = Region(k0)
        self.cmax = min(cmax if cmax else k0-1, k0-1)
        self.Kgen = Kgen
        self.mnc = max_nonconst_others if max_nonconst_others is not None else l-1
        self.comps = {c: list(compositions(c, l-1)) for c in range(l-1, self.cmax+1)}
        self.verbose = verbose
        self.edges = {}      # w -> list of (a, c, others(tuple of (m,o)))  (all discovered)
        self.nodes = 0
    def le_F(self, w): return self.R.nonneg(padd(self.F, pscale(-1, w)))
    def distinct(self, xs):
        for i in range(len(xs)):
            for j in range(i+1, len(xs)):
                d = padd(xs[i], pscale(-1, xs[j]))
                if not (self.R.pos(d) or self.R.pos(pscale(-1, d))): return False
        return True
    def gen_moves(self, Vx, newset):
        """yield (w, a, c, others) for identities among Vx using at least one vertex from newset (if given)"""
        l = self.l
        Vs = sorted(Vx, key=lambda p: pval(p, self.Kgen))
        Fg = pval(self.F, self.Kgen)
        for a in Vs:
            if a[2] != 0 or a[1] not in (0, 1): continue
            rest = [o for o in Vs if o != a]
            for c in range(l-1, self.cmax+1):
                base = pmulk(c, a)
                if pval(base, self.Kgen) + (c) > Fg + 10**4: break
                for O in itertools.combinations(rest, l-1):
                    if newset is not None and a not in newset and not any(o in newset for o in O): continue
                    if sum(1 for o in O if o[1] != 0 or o[2] != 0) > self.mnc: continue
                    for m in self.comps[c]:
                        w = base
                        for mi, o in zip(m, O): w = padd(w, pscale(mi, o))
                        if pval(w, self.Kgen) > Fg: continue
                        if not self.le_F(w): continue
                        if not self.R.pos(w): continue
                        if not self.distinct((a,)+O): continue
                        yield w, a, c, tuple(zip(m, O))
    def propagate(self, col, trail):
        """col: dict vertex->colour (0/1). Unit propagation to fixpoint. Returns contradiction edge or None."""
        new = {0: set(v for v, x in col.items() if x == 0), 1: set(v for v, x in col.items() if x == 1)}
        first = True
        while True:
            added = {0: set(), 1: set()}
            for X in (0, 1):
                Vx = [v for v, x in col.items() if x == X]
                ns = None if first else new[X]
                if not first and not ns: continue
                for (w, a, c, oth) in self.gen_moves(Vx, ns):
                    cw = col.get(w)
                    if cw == X:
                        return (w, a, c, oth, X)
                    if cw is None:
                        col[w] = 1-X; trail.append((w, 1-X, (a, c, oth))); added[1-X].add(w)
                        self.edges.setdefault(w, []).append((a, c, oth))
            first = False
            if not added[0] and not added[1]: return None
            new = added
    def solve(self, col, depth=0, branch_vals=None, maxdepth=12):
        self.nodes += 1
        trail = []
        con = self.propagate(col, trail)
        if con is not None:
            w, a, c, oth, X = con
            self.edges.setdefault(w, []).append((a, c, oth))
            return {'contradiction': [w, a, c, oth, X], 'forced': trail}
        if depth >= maxdepth: return None
        # branch on smallest uncoloured constant
        x = 1
        while (x, 0, 0) in col: x += 1
        node = {'forced': trail, 'branch': x, 'children': []}
        for X in (0, 1):
            col2 = dict(col); col2[(x, 0, 0)] = X
            sub = self.solve(col2, depth+1, maxdepth=maxdepth)
            if sub is None: return None
            node['children'].append(sub)
        return node

def run(l, k0, prefix_len=None, maxdepth=14, **kw):
    E = Engine(l, k0, **kw)
    col = {(1, 0, 0): 0}
    t = time.time()
    tree = E.solve(col, maxdepth=maxdepth)
    return E, tree, time.time()-t

if __name__ == '__main__':
    l = int(sys.argv[1]); k0 = int(sys.argv[2])
    md = int(sys.argv[3]) if len(sys.argv) > 3 else 14
    mnc = int(sys.argv[4]) if len(sys.argv) > 4 else None
    E, tree, dt = run(l, k0, maxdepth=md, max_nonconst_others=mnc)
    print(f"l={l} k0={k0}: {'PROOF FOUND' if tree else 'no proof'} nodes={E.nodes} edges={sum(len(v) for v in E.edges.values())} time={dt:.1f}s")
    if tree:
        json.dump({'l': l, 'k0': k0, 'tree': tree}, open(f'tree_{l}_{k0}.json', 'w'))
