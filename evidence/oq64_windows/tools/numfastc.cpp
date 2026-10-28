// numfastc.cpp -- numfast + certificate edges (conflict cones with lazily computed reasons).
// Output edges are a generator artefact only: they are re-checked by mkcnfw.py and the CNF is certified by LRAT.
// numfast.cpp -- fast numeric DPLL for one (k, l, n), same search as numeng2.py but WITHOUT certificate output.
// Question: does every 2-colouring of [1,n] contain a monochromatic solution of x_1+...+x_k = x_{k+1}
// that uses exactly l+1 distinct integers?   (UNSAT = yes, i.e. S_2(k;l) <= n.)
// Propagation is complete: for each colour X, dp[X][c][e] is the bitset of sums of c distinct integers of colour X
// with e extra copies in total (each chosen integer v contributes v*(1+m), m >= 0). The sums with c = l and
// e = k-l are exactly the right-hand sides of monochromatic solutions; one landing on an integer of colour X is a
// conflict, one landing on an uncoloured integer forces the other colour. The DP is updated incrementally when an
// integer gets a colour and restored from a snapshot on backtracking. Branch on the smallest uncoloured integer
// (colour 0 first); integer 1 has colour 0 (symmetry).
// This program is a search tool only: its UNSAT answers are NOT certified (use numeng2.py + LRAT for that).
// usage: numfast k l n [max_seconds] [prefix-colours, e.g. "RBBR..." fixing 1..len]
#include <bits/stdc++.h>
using namespace std;
typedef unsigned long long u64;
static int K, L, NN, EX, WD;           // EX = k-l extra copies, WD = words per bitset
static vector<u64> DP[2];              // DP[X][(c*(EX+1)+e)*WD + w]
static vector<signed char> COL;
static vector<u64> MASK[2];
static long long NODES = 0, MAXDEPTH = 0;
static double TMAX = 1e18; static chrono::steady_clock::time_point T0;
static inline u64 *row(int X, int c, int e) { return &DP[X][((size_t)c * (EX + 1) + e) * WD]; }
static inline void orShift(u64 *dst, const u64 *src, int sh) {          // dst |= src << sh  (truncated to WD words)
    int ws = sh >> 6, bs = sh & 63;
    if (ws >= WD) return;
    if (bs == 0) { for (int i = WD - 1; i >= ws; i--) dst[i] |= src[i - ws]; }
    else {
        for (int i = WD - 1; i > ws; i--) dst[i] |= (src[i - ws] << bs) | (src[i - ws - 1] >> (64 - bs));
        dst[ws] |= src[0] << bs;
    }
}
static void addElem(int X, int v) {                 // incremental 0/1-knapsack update with multiplicities
    for (int c = L - 1; c >= 0; c--)
        for (int e = EX; e >= 0; e--) {
            const u64 *src = row(X, c, e);
            bool any = false; for (int i = 0; i < WD; i++) if (src[i]) { any = true; break; }
            if (!any) continue;
            for (int m = 0; e + m <= EX; m++) {
                long long sh = (long long)v * (1 + m); if (sh > NN) break;
                orShift(row(X, c + 1, e + m), src, (int)sh);
            }
        }
}
static vector<long long> TS; static vector<char> ISDEC; static long long CLOCK = 0;
static inline void setColD(int v, int X, bool dec) { COL[v] = X; MASK[X][v >> 6] |= 1ULL << (v & 63); TS[v] = ++CLOCK; ISDEC[v] = dec; }
static inline void setCol(int v, int X) { setColD(v, X, false); }
typedef pair<vector<pair<int,int>>, int> Edge;      // ((mult, value) sorted, w)
static set<Edge> EDGES;
static map<long long, Edge> RCACHE;                 // keyed by assignment timestamp
static vector<u64> HBUF;
// witness: w as a k-sum (exactly L distinct values, EX extra copies) of integers coloured X with TS < tsLimit
static Edge witness(int w, int X, long long tsLimit) {
    vector<int> E; for (int v = 1; v < w; v++) if (COL[v] == X && TS[v] < tsLimit) E.push_back(v);
    int W = (w + 1 + 63) / 64, R = (L + 1) * (EX + 1);
    size_t need = (size_t)(E.size() + 1) * R * W; if (HBUF.size() < need) HBUF.resize(need);
    auto T = [&](size_t i, int c, int e) { return &HBUF[((i * R) + c * (EX + 1) + e) * W]; };
    fill(HBUF.begin(), HBUF.begin() + (size_t)R * W, 0ULL); T(0, 0, 0)[0] = 1;
    int saveWD = WD, saveNN = NN; WD = W; NN = w;
    for (size_t i = 0; i < E.size(); i++) {
        memcpy(T(i + 1, 0, 0), T(i, 0, 0), sizeof(u64) * R * W);
        int v = E[i];
        for (int c = L - 1; c >= 0; c--) for (int e = EX; e >= 0; e--) {
            const u64 *src = T(i, c, e); bool any = false; for (int t = 0; t < W; t++) if (src[t]) { any = true; break; }
            if (!any) continue;
            for (int m = 0; e + m <= EX; m++) { long long sh = (long long)v * (1 + m); if (sh > w) break; orShift(T(i + 1, c + 1, e + m), src, (int)sh); }
        }
    }
    WD = saveWD; NN = saveNN;
    auto bit = [&](const u64 *b, long long s) { return s >= 0 && s <= w && ((b[s >> 6] >> (s & 63)) & 1); };
    if (!bit(T(E.size(), L, EX), w)) { fprintf(stderr, "witness failure w=%d X=%d\n", w, X); exit(3); }
    vector<pair<int,int>> summ; int cnt = L, e = EX; long long s = w;
    for (size_t i = E.size(); i >= 1 && cnt > 0; i--) {
        int v = E[i - 1];
        if (bit(T(i - 1, cnt, e), s)) continue;
        bool ok = false;
        for (int m = 0; m <= e; m++) if (bit(T(i - 1, cnt - 1, e - m), s - (long long)v * (1 + m))) { summ.push_back({1 + m, v}); cnt--; e -= m; s -= (long long)v * (1 + m); ok = true; break; }
        if (!ok) { fprintf(stderr, "backtrack failure\n"); exit(3); }
    }
    if (!(cnt == 0 && e == 0 && s == 0)) { fprintf(stderr, "witness incomplete\n"); exit(3); }
    sort(summ.begin(), summ.end());
    return {summ, w};
}
static void addCone(Edge root) {
    vector<Edge> st{root}; set<Edge> seen;   // per-cone visited set (reasons depend on the current branch)
    while (!st.empty()) {
        Edge ed = st.back(); st.pop_back();
        if (!seen.insert(ed).second) continue;
        EDGES.insert(ed);
        vector<int> us; for (auto &p : ed.first) us.push_back(p.second); us.push_back(ed.second);
        for (int u : us) {
            if (ISDEC[u]) continue;
            auto it = RCACHE.find(TS[u]);
            if (it == RCACHE.end()) it = RCACHE.emplace(TS[u], witness(u, 1 - COL[u], TS[u])).first;
            if (!seen.count(it->second)) st.push_back(it->second);
        }
    }
}
// returns true on conflict; queue holds newly coloured integers whose DP update is pending
static bool propagate(vector<int> &queue, vector<int> &trail) {
    size_t qi = 0;
    vector<u64> fresh(WD);
    while (true) {
        for (; qi < queue.size(); qi++) addElem(COL[queue[qi]], queue[qi]);
        bool progress = false;
        for (int X = 0; X < 2; X++) {
            const u64 *S = row(X, L, EX);
            for (int i = 0; i < WD; i++) if (S[i] & MASK[X][i]) {     // conflict
                int w = i * 64 + __builtin_ctzll(S[i] & MASK[X][i]);
                addCone(witness(w, X, CLOCK + 1)); return true; }
            for (int i = 0; i < WD; i++) {
                u64 f = S[i] & ~MASK[0][i] & ~MASK[1][i];
                if (i == 0) f &= ~1ULL;                                          // bit 0 is not an integer
                while (f) {
                    int b = __builtin_ctzll(f); f &= f - 1;
                    int v = i * 64 + b; if (v > NN) break;
                    setCol(v, 1 - X); trail.push_back(v); queue.push_back(v); progress = true;
                }
            }
        }
        if (!progress && qi == queue.size()) return false;
    }
}
static vector<int> GOOD;
static bool solve(int depth) {          // returns true if this subtree is closed (no good colouring)
    NODES++; MAXDEPTH = max(MAXDEPTH, (long long)depth);
    if ((NODES & 1023) == 0) {
        double el = chrono::duration<double>(chrono::steady_clock::now() - T0).count();
        if ((NODES & ((1 << 18) - 1)) == 0) fprintf(stderr, "t=%.0fs nodes=%lld depth=%d maxdepth=%lld\n", el, NODES, depth, MAXDEPTH);
        if (el > TMAX) throw runtime_error("timeout");
    }
    int v = 1; while (v <= NN && COL[v] != -1) v++;
    if (v > NN) { GOOD.assign(COL.begin(), COL.end()); return false; }
    for (int X = 0; X < 2; X++) {
        vector<u64> snap0 = DP[0], snap1 = DP[1];
        vector<int> trail, queue;
        setColD(v, X, true); trail.push_back(v); queue.push_back(v);
        bool conf = propagate(queue, trail);
        bool closed = conf ? true : solve(depth + 1);
        for (int u : trail) { MASK[COL[u]][u >> 6] &= ~(1ULL << (u & 63)); COL[u] = -1; }
        DP[0].swap(snap0); DP[1].swap(snap1);
        if (!closed) return false;
    }
    return true;
}
int main(int argc, char **argv) {
    K = atoi(argv[1]); L = atoi(argv[2]); NN = atoi(argv[3]); EX = K - L;
    if (argc > 4) TMAX = atof(argv[4]);
    string prefix = argc > 5 ? argv[5] : "R";
    WD = (NN + 1 + 63) / 64;
    for (int X = 0; X < 2; X++) { DP[X].assign((size_t)(L + 1) * (EX + 1) * WD, 0); row(X, 0, 0)[0] = 1; MASK[X].assign(WD, 0); }
    COL.assign(NN + 1, -1); TS.assign(NN + 1, 0); ISDEC.assign(NN + 1, 0);
    T0 = chrono::steady_clock::now();
    vector<int> trail, queue;
    for (size_t i = 0; i < prefix.size() && (int)i + 1 <= NN; i++) {
        int X = prefix[i] == 'R' ? 0 : 1; setColD(i + 1, X, true); trail.push_back(i + 1); queue.push_back(i + 1);
    }
    string res;
    try {
        if (propagate(queue, trail)) res = "UNSAT (conflict at root)";
        else res = solve(0) ? "UNSAT" : "GOOD_COLOURING";
    } catch (runtime_error &) { res = "TIMEOUT"; }
    double el = chrono::duration<double>(chrono::steady_clock::now() - T0).count();
    printf("%s: k=%d l=%d n=%d nodes=%lld maxdepth=%lld edges=%zu %.1fs\n", res.c_str(), K, L, NN, NODES, MAXDEPTH, EDGES.size(), el);
    if (argc > 6) { FILE *f = fopen(argv[6], "w"); for (auto &ed : EDGES) { for (auto &p : ed.first) fprintf(f, "%d:%d ", p.first, p.second); fprintf(f, "| %d\n", ed.second); } fclose(f); }
    if (!GOOD.empty()) {
        // print the colouring as runs
        printf("colouring runs:");
        int st = 1; for (int v = 2; v <= NN + 1; v++) if (v == NN + 1 || GOOD[v] != GOOD[st]) { printf(" %c[%d,%d]", GOOD[st] ? 'B' : 'R', st, v - 1); st = v; }
        printf("\n");
    }
    return 0;
}
