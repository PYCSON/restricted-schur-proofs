// Exploration: does every window satisfy min_w(W) <= min_w(prefix_j) (same j, majority blue)?  Reports, over
// all reduced windows W' (|D'|>=2) and all low-case windows, the maximum of obj(W) - obj(P_j) and of
// obj(W) - max_j' obj(P_j'), split by majority colour.  usage: t1dom l e
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef long long ll;
static int L, ELO, EHI; static ll Nv[64];
static ll F(ll k, ll l) { return k * k + ((l + 1) * (l - 2) / 2 + 2) * k + l * (l - 2); }
#define NEG (-(1LL << 60))
static ll evalw(const int *col, int E, int early) {
    ll Nval = Nv[E];
    int R[256], B[256], nr = 0, nb = 0;
    for (int x = 1; x <= 2 * L; x++) { if (col[x]) R[nr++] = x; else B[nb++] = x; }
    int *M, *D, nd;
    if (nr >= L + 2) { M = R; D = B; nd = nb; } else if (nb >= L + 2) { M = B; D = R; nd = nr; } else return NEG;
    int j = nd, q = L - j;
    if (j < 2 || j > L - 2) return NEG;
    int S[256]; ll sS = 0, sD = 0;
    for (int i = 0; i < L; i++) { S[i] = M[i]; sS += S[i]; }
    for (int i = 0; i < nd; i++) sD += D[i];
    static int isD[1024]; for (int x = 0; x <= 4 * L + 2; x++) isD[x] = 0;
    for (int i = 0; i < nd; i++) isD[D[i]] = 1;
    int m1 = S[0], m2 = S[1];
    ll zsum[256], rval[256];
    ll P[257]; P[0] = 0; for (int i = 0; i < L; i++) P[i + 1] = P[i] + S[i];
    for (int a = 0; a < L; a++) {
        int rp = S[a]; int r = (rp != m1) ? m1 : m2; rval[a] = r;
        ll z;
        if (a == 0) z = P[q + 1] - P[2];
        else if (a <= q - 1) z = P[q + 1] - P[1] - S[a];
        else z = P[q] - P[1];
        zsum[a] = z;
    }
    ll best = -1;
    for (int yi = L - 1; yi >= 0; yi--) {
        int y = S[yi]; int u = (y != m1) ? m1 : m2;
        ll base = sS - y + sD + (ll)q * (sS + (ll)(E - 1) * u) + (ll)(E - 1) * u;
        for (int a = 0; a < L; a++) {
            int rp = S[a]; ll t = base + zsum[a] + rval[a];
            for (int di = 0; di < L; di++) {
                int d = S[di]; if (d == y || d == rp) continue;
                int b = y + rp - d; if (b < 1 || b > 2 * L || !isD[b]) continue;
                int db = (b != D[0]) ? D[0] : D[1];
                ll w = t + d + (ll)E * db;
                if (early && w <= Nval) return -1;
                if (best < 0 || w < best) best = w;
            }
        }
    }
    if (best < 0) return (1LL << 50);
    return best - Nval;
}

static ll Pobj[256], Pmax; static int E;
static ll worstJ[2], worstAll[2]; static int wcol[2][256], wcolA[2][256]; static long long cnt[2];
static void show(const int *col) { for (int x = 1; x <= 2 * L; x++) putchar(col[x] ? 'R' : 'B'); }
static void consider(const int *col, int mcol) {
    int nd = 0; for (int x = 1; x <= 2 * L; x++) nd += (col[x] != mcol);
    ll o = evalw(col, E, 0); if (o == NEG) return;
    cnt[mcol]++;
    ll d1 = o - Pobj[nd], d2 = o - Pmax;
    if (d1 > worstJ[mcol]) { worstJ[mcol] = d1; memcpy(wcol[mcol], col, sizeof(int) * 256); }
    if (d2 > worstAll[mcol]) { worstAll[mcol] = d2; memcpy(wcolA[mcol], col, sizeof(int) * 256); }
}
static void expand(int *col, int mcol, int pos, int jcur) {
    if (pos > 2 * L) { consider(col, mcol); return; }
    expand(col, mcol, pos + 1, jcur);
    if (jcur + 1 <= L - 2) { col[pos] = !mcol; expand(col, mcol, pos + 1, jcur + 1); col[pos] = mcol; }
}
int main(int argc, char **argv) {
    L = atoi(argv[1]); E = atoi(argv[2]); Nv[E] = F(L + E, L);
    int col[256];
    Pmax = NEG;
    for (int j = 2; j <= L - 2; j++) { for (int x = 1; x <= 2 * L; x++) col[x] = (x <= j); Pobj[j] = evalw(col, E, 0); if (Pobj[j] > Pmax) Pmax = Pobj[j]; }
    for (int c = 0; c < 2; c++) { worstJ[c] = worstAll[c] = NEG; cnt[c] = 0; }
    for (int mcol = 1; mcol >= 0; mcol--) {
        for (int jp = 2; jp <= L - 2; jp++) {
            int len = L + jp, free = len - 1;
            unsigned long long v = (1ULL << jp) - 1;
            while (v < (1ULL << free)) {
                int pos1min = (int)(v & 1ULL); int ok = mcol ? !pos1min : pos1min;
                if (ok) {
                    for (int x = 1; x <= 2 * L; x++) col[x] = mcol;
                    for (int i = 0; i < free; i++) if ((v >> i) & 1ULL) col[i + 1] = !mcol;
                    consider(col, mcol);
                }
                unsigned long long t = v | (v - 1); v = (t + 1) | (((~t & -~t) - 1) >> (__builtin_ctzll(v) + 1));
            }
        }
        for (int a = 0; a <= L; a++) {
            if (a == 0) { if (!mcol) continue; } else if (!mcol && a != 1) continue; else if (mcol && a == 1) continue;
            int ml = (a == 0) ? L : L + 1;
            for (int x = 1; x <= 2 * L; x++) col[x] = mcol;
            if (a) col[a] = !mcol;
            expand(col, mcol, ml + 1, a ? 1 : 0);
        }
    }
    printf("l=%d e=%d Pmax=%lld", L, E, Pmax);
    for (int c = 1; c >= 0; c--) {
        printf(" | maj=%s n=%lld max[obj-P_j]=%lld max[obj-Pmax]=%lld ", c ? "R" : "B", cnt[c], worstJ[c], worstAll[c]);
        show(wcol[c]); printf(" "); show(wcolA[c]);
    }
    printf("\n");
    return 0;
}
