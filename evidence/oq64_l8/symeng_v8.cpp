// symeng.cpp -- fast version of symeng.py (same semantics).
// Symbolic forcing engine for the exact-version S_2(k;l) <= F(k,l) on the region k >= k0.
// Vertices: integer polynomials c0 + c1 k + c2 k^2.  Identity: w = (k-c)*a + sum m_i o_i, with a of degree <= 1
// and k-coefficient in {0,1}, l-1 others with m_i >= 1, sum m_i = c <= k0-1, summands pairwise distinct for all
// integers k >= k0, 1 <= w <= F on the region.  DPLL over colours of the constants 1,2,3,... with unit propagation.
// Output: every identity used for a forced colour or a contradiction (file), later minimised + certified in Python.
// usage: symeng l k0 maxdepth out.txt [max_nonconst_others] [max_nodes]
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
typedef __int128 i128;
struct P { ll c0, c1, c2; bool operator==(const P &o) const { return c0 == o.c0 && c1 == o.c1 && c2 == o.c2; } };
struct PH { size_t operator()(const P &p) const { return std::hash<ll>()(p.c0 * 1000003LL ^ (p.c1 * 998244353LL) ^ (p.c2 * 7919LL)); } };
static int L, K0, CMAX, MNC, MAXDEPTH, MAXSL; static ll MAXNODES; static string PREFIX;
static P Fp;
static const ll KG = 1000000;
static inline i128 ev(const P &p, i128 k) { return (i128)p.c0 + (i128)p.c1 * k + (i128)p.c2 * k * k; }
// exact minimum over integers k >= K0 ; returns false if unbounded below
static bool minval(const P &p, i128 &out) {
    if (p.c2 < 0) return false;
    if (p.c2 == 0) { if (p.c1 < 0) return false; out = ev(p, K0); return true; }
    long double v = -(long double)p.c1 / (2.0L * p.c2);
    i128 best = ev(p, K0);
    ll base = (ll)floorl(v);
    for (ll kk = base - 1; kk <= base + 2; kk++) if (kk >= K0) { i128 x = ev(p, kk); if (x < best) best = x; }
    out = best; return true;
}
static inline bool posR(const P &p) { i128 m; return minval(p, m) && m > 0; }
static inline bool nonnegR(const P &p) { i128 m; return minval(p, m) && m >= 0; }
static vector<P> V; static unordered_map<P, int, PH> VID; static vector<ll> VG; // value at KG
static vector<ll> VK; // value at K0
static int getv(const P &p) {
    auto it = VID.find(p); if (it != VID.end()) return it->second;
    int id = V.size(); V.push_back(p); VID[p] = id; VG.push_back((ll)ev(p, KG)); VK.push_back((ll)ev(p, K0)); return id;
}
static unordered_map<ll, char> CMP; // pair -> 1 comparable, 2 not
static bool comparable(int i, int j) {
    if (i > j) swap(i, j);
    ll key = ((ll)i << 32) | (ll)j;
    auto it = CMP.find(key); if (it != CMP.end()) return it->second == 1;
    P d{V[i].c0 - V[j].c0, V[i].c1 - V[j].c1, V[i].c2 - V[j].c2};
    P nd{-d.c0, -d.c1, -d.c2};
    bool ok = posR(d) || posR(nd);
    CMP[key] = ok ? 1 : 2; return ok;
}
struct Edge { int a, c, w; vector<pair<int,int>> oth; };
static vector<Edge> EDGES; static vector<char> USED; static vector<Edge> OUTE;
static void flushEdges(size_t emark) {
    USED.resize(EDGES.size(), 0);
    for (size_t i = emark; i < EDGES.size(); i++) if (USED[i]) OUTE.push_back(EDGES[i]);
    EDGES.resize(emark); USED.resize(emark);
}
static vector<signed char> COL;  // per vertex, -1 unknown
static vector<int> REASON;
static ll NODES = 0;
static ll FG, FK;
static vector<vector<int>> COMPS; // compositions stored flat: for c, list of vectors
static map<int, vector<vector<int>>> COMPOS;
static void gencomp(int c, int parts, vector<int> &cur, vector<vector<int>> &out) {
    if (parts == 1) { cur.push_back(c); out.push_back(cur); cur.pop_back(); return; }
    for (int f = 1; f <= c - parts + 1; f++) { cur.push_back(f); gencomp(c - f, parts - 1, cur, out); cur.pop_back(); }
}
// move enumeration state
struct Found { int w; Edge e; };
static vector<int> VX; static vector<char> ISNEW;
static int CURA, CURC; static P BASE; static ll BASEG;
static int pick[16], pmul[16];
static bool contradiction; static Edge CONTRA; static int CONTRAX;
static vector<pair<int, Edge>> FORCED_THIS_ROUND;
static int CURX;
static void leaf(int cnt) {
    // build w
    P w = BASE; int nonconst = 0; bool hasnew = ISNEW[CURA];
    for (int i = 0; i < cnt; i++) {
        const P &o = V[pick[i]];
        w.c0 += pmul[i] * o.c0; w.c1 += pmul[i] * o.c1; w.c2 += pmul[i] * o.c2;
        if (o.c1 != 0 || o.c2 != 0) nonconst++;
        if (ISNEW[pick[i]]) hasnew = true;
    }
    if (!hasnew) return;
    if (nonconst > MNC) return;
    P Fw{Fp.c0 - w.c0, Fp.c1 - w.c1, Fp.c2 - w.c2};
    if (!nonnegR(Fw)) return;
    if (!posR(w)) return;
    // distinctness
    for (int i = 0; i < cnt; i++) { if (!comparable(CURA, pick[i])) return;
        for (int j = i + 1; j < cnt; j++) if (!comparable(pick[i], pick[j])) return; }
    auto it = VID.find(w);
    int wc = -1, wid = -1;
    if (it != VID.end()) { wid = it->second; wc = COL[wid]; }
    if (wc == CURX) {
        contradiction = true; CONTRA.a = CURA; CONTRA.c = CURC; CONTRA.w = getv(w); CONTRA.oth.clear();
        for (int i = 0; i < cnt; i++) CONTRA.oth.push_back({pmul[i], pick[i]});
        CONTRAX = CURX; return;
    }
    if (wc == -1) {
        if (wid < 0) { wid = getv(w); COL.push_back(-1); REASON.push_back(-1); ISNEW.push_back(0); }
        if (COL[wid] != -1) return;
        Edge e; e.a = CURA; e.c = CURC; e.w = wid; for (int i = 0; i < cnt; i++) e.oth.push_back({pmul[i], pick[i]});
        FORCED_THIS_ROUND.push_back({wid, e});
        COL[wid] = 1 - CURX;  // assign immediately (consistent with sequential processing)
        REASON[wid] = -2;     // placeholder, fixed below
    }
}
static vector<int> NEWSUF;
static ll SLS[16]; static int NSL;
static void rec(int pos, int startIdx, int remParts, int remMult, ll partialG, ll partialK, int depthpick, bool hasNew) {
    if (contradiction) return;
    if (!hasNew && (startIdx >= (int)VX.size() || NEWSUF[startIdx] == 0) && remParts > 0) return;
    if (remParts == 0) { if (remMult == 0) leaf(depthpick); return; }
    for (int idx = startIdx; idx < (int)VX.size(); idx++) {
        int o = VX[idx]; if (o == CURA) continue;
        if (COL[o] != CURX) continue;
        int maxm = remMult - (remParts - 1);
        // multiplicity m from 1..maxm
        // sorted ascending by value at K0: if even multiplicity 1 overflows at K0, later ones overflow too
        if (partialK + VK[o] > FK) break;
        // slope-class limit: classes of non-constant vertices (c1 + 1000*c2)
        int added = 0;
        if (V[o].c1 != 0 || V[o].c2 != 0) {
            ll cls = V[o].c1 + 1000 * V[o].c2; bool seen = false;
            for (int q = 0; q < NSL; q++) if (SLS[q] == cls) { seen = true; break; }
            if (!seen) { if (NSL >= MAXSL) continue; SLS[NSL++] = cls; added = 1; }
        }
        for (int m = 1; m <= maxm; m++) {
            ll pk = partialK + (ll)m * VK[o];
            if (pk > FK) break;
            ll pg = partialG + (ll)m * VG[o];
            if (pg > FG) break;
            pick[depthpick] = o; pmul[depthpick] = m;
            rec(pos + 1, idx + 1, remParts - 1, remMult - m, pg, pk, depthpick + 1, hasNew || ISNEW[o]);
            if (contradiction) { NSL -= added; return; }
        }
        NSL -= added;
    }
}
// one propagation to fixpoint; returns true if contradiction
static vector<int> TRAIL;
static bool propagate(int onlynew) {
    // first round: all coloured vertices are new (root), or only the branch vertex (child nodes)
    ISNEW.assign(V.size(), 0);
    for (size_t i = 0; i < ISNEW.size(); i++) ISNEW[i] = (onlynew < 0) ? (COL[i] != -1) : ((int)i == onlynew);
    while (true) {
        FORCED_THIS_ROUND.clear();
        for (CURX = 0; CURX < 2 && !contradiction; CURX++) {
            VX.clear();
            for (size_t i = 0; i < V.size(); i++) if (COL[i] == CURX) VX.push_back(i);
            sort(VX.begin(), VX.end(), [](int x, int y) { return VK[x] < VK[y] || (VK[x] == VK[y] && VG[x] < VG[y]); });
            NEWSUF.assign(VX.size() + 1, 0);
            for (int i = (int)VX.size() - 1; i >= 0; i--) NEWSUF[i] = NEWSUF[i + 1] + (ISNEW[VX[i]] ? 1 : 0);
            if (NEWSUF[0] == 0) continue;
            for (int a : VX) {
                if (contradiction) break;
                const P pa = V[a];  // copy: V may reallocate inside rec()
                if (pa.c2 != 0 || (pa.c1 != 0 && pa.c1 != 1)) continue;
                for (int c = L - 1; c <= CMAX && !contradiction; c++) {
                    // base = (k-c)*a = -c*a0 + (a0 - c*a1)k + a1 k^2
                    BASE = P{-c * pa.c0, pa.c0 - c * pa.c1, pa.c1};
                    BASEG = (ll)ev(BASE, KG);
                    if (BASEG > FG) continue;
                    ll BASEK = (ll)ev(BASE, K0);
                    if (BASEK > FK) continue;
                    CURA = a; CURC = c;
                    NSL = 0; rec(0, 0, L - 1, c, BASEG, BASEK, 0, ISNEW[a]);
                }
            }
        }
        // record forced edges
        for (auto &fe : FORCED_THIS_ROUND) { REASON[fe.first] = EDGES.size(); EDGES.push_back(fe.second); TRAIL.push_back(fe.first); }
        if (contradiction) { EDGES.push_back(CONTRA); return true; }
        if (FORCED_THIS_ROUND.empty()) return false;
        // next round: only new vertices count as new
        for (size_t i = 0; i < ISNEW.size(); i++) ISNEW[i] = 0;
        ISNEW.resize(V.size(), 0);
        for (auto &fe : FORCED_THIS_ROUND) ISNEW[fe.first] = 1;
    }
}
static bool solve(int depth, int newv) {
    NODES++;
    if (NODES % 50 == 0) { fprintf(stderr, "nodes=%lld depth=%d verts=%zu edges=%zu\n", NODES, depth, V.size(), EDGES.size()); }
    if (NODES > MAXNODES) return false;
    size_t trailmark = TRAIL.size();
    size_t emark = EDGES.size();
    contradiction = false;
    bool con = propagate(newv);
    contradiction = false;
    if (con) {
        // trace back the edges used for this contradiction
        vector<int> stack; stack.push_back((int)EDGES.size() - 1);
        while (!stack.empty()) {
            int ei = stack.back(); stack.pop_back();
            if ((int)USED.size() < (int)EDGES.size()) USED.resize(EDGES.size(), 0);
            if (USED[ei]) continue;
            USED[ei] = 1;
            const Edge &e = EDGES[ei];
            vector<int> vs; vs.push_back(e.a); for (auto &mo : e.oth) vs.push_back(mo.second);
            if (ei == (int)EDGES.size() - 1) vs.push_back(e.w);   // contradiction edge: w's colour also used
            for (int x : vs) { int r = REASON[x]; if (r >= 0) stack.push_back(r); }
        }
        // undo
        while (TRAIL.size() > trailmark) { COL[TRAIL.back()] = -1; TRAIL.pop_back(); }
        flushEdges(emark);
        return true;
    }
    if (depth >= MAXDEPTH) {
        static bool dumped = false;
        if (!dumped) {   // record the open branch: every coloured vertex with its value at k0 and its colour
            dumped = true;
            FILE *pf = fopen("open_branch.txt", "w");
            for (size_t i = 0; i < V.size() && i < COL.size(); i++) if (COL[i] != -1)
                fprintf(pf, "%lld %lld %lld | %lld | %d\n", V[i].c0, V[i].c1, V[i].c2, (ll)ev(V[i], K0), (int)COL[i]);
            fclose(pf);
            fprintf(stderr, "open branch at depth %d dumped to open_branch.txt\n", depth);
        }
        while (TRAIL.size() > trailmark) { COL[TRAIL.back()] = -1; TRAIL.pop_back(); } flushEdges(emark); return false; }
    // branch on smallest uncoloured constant
    ll x = 1;
    while (true) { auto it = VID.find(P{x, 0, 0}); if (it == VID.end() || COL[it->second] == -1) break; x++; }
    int xi = getv(P{x, 0, 0}); if ((int)COL.size() < (int)V.size()) { COL.resize(V.size(), -1); REASON.resize(V.size(), -1); ISNEW.resize(V.size(), 0); }
    bool ok = true;
    for (int X = 0; X < 2 && ok; X++) {
        if (depth < (int)PREFIX.size() && X != PREFIX[depth] - '0') continue;   // cube: follow the fixed prefix of decisions
        COL[xi] = X; REASON[xi] = -1;
        ok = solve(depth + 1, xi);
        COL[xi] = -1;
    }
    while (TRAIL.size() > trailmark) { COL[TRAIL.back()] = -1; TRAIL.pop_back(); }
    flushEdges(emark);
    return ok;
}
int main(int argc, char **argv) {
    L = atoi(argv[1]); K0 = atoi(argv[2]); MAXDEPTH = atoi(argv[3]); const char *out = argv[4];
    MNC = argc > 5 ? atoi(argv[5]) : L - 1; MAXNODES = argc > 6 ? atoll(argv[6]) : 100000000LL; MAXSL = argc > 7 ? atoi(argv[7]) : 99; ll FEXTRA = argc > 8 ? atoll(argv[8]) : 0;
    CMAX = K0 - 1;
    if (argc > 9 && atoi(argv[9]) > 0 && atoi(argv[9]) < CMAX) CMAX = atoi(argv[9]);   // optional cap on c (keeps every identity valid: c <= k0-1)
    if (getenv("PREFIX")) PREFIX = getenv("PREFIX");
    int D = L * (L - 1) / 2;
    Fp = P{(ll)L * L - 2 * L + FEXTRA, (ll)D + 1, 1};
    FG = (ll)ev(Fp, KG); FK = (ll)ev(Fp, K0);
    int one = getv(P{1, 0, 0}); COL.assign(V.size(), -1); REASON.assign(V.size(), -1); ISNEW.assign(V.size(), 0);
    COL[one] = 0;
    auto t0 = chrono::steady_clock::now();
    // vertices may be created inside leaf(); keep arrays in sync there (handled by push_back in leaf)
    bool ok = solve(0, -1);
    double dt = chrono::duration<double>(chrono::steady_clock::now() - t0).count();
    printf("l=%d k0=%d: %s nodes=%lld vertices=%zu used_edges=%zu time=%.1fs\n", L, K0, ok ? "PROOF FOUND" : "no proof", NODES, V.size(), OUTE.size() + EDGES.size(), dt);
    FILE *f = fopen(out, "w");
    flushEdges(0);
    for (size_t ei = 0; ei < OUTE.size(); ei++) {
        auto &e = OUTE[ei];
        fprintf(f, "%lld %lld %lld | %d |", V[e.a].c0, V[e.a].c1, V[e.a].c2, e.c);
        for (auto &mo : e.oth) fprintf(f, " %d:%lld,%lld,%lld", mo.first, V[mo.second].c0, V[mo.second].c1, V[mo.second].c2);
        fprintf(f, " | %lld %lld %lld\n", V[e.w].c0, V[e.w].c1, V[e.w].c2);
    }
    fclose(f);
    return ok ? 0 : 1;
}
