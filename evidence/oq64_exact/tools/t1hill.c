// Adversarial search for windows of [1,2l] that survive the exact-minimum T1-fill template.
// Objective(window) = min_w - N  (positive: T1-fill does NOT refute the window at this e).
// Only windows with a minority colour of size 2 <= j <= l-2 are considered (other windows are
// handled by separate lemmas).  usage: t1hill l e iters restarts seed
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef long long ll;
static int L, E;
static ll Nval;
static ll F(ll k, ll l) { return k * k + ((l + 1) * (l - 2) / 2 + 2) * k + l * (l - 2); }
static unsigned long long rs = 88172645463325252ULL;
static unsigned long long rnd(void) { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; }
#define NEG (-(1LL << 60))
// col[x] = 1 red, 0 blue, x = 1..2L
static ll objective(const int *col) {
    int R[256], B[256], nr = 0, nb = 0;
    for (int x = 1; x <= 2 * L; x++) { if (col[x]) R[nr++] = x; else B[nb++] = x; }
    int *M, *D, nm, nd;
    if (nr >= L + 2) { M = R; nm = nr; D = B; nd = nb; }
    else if (nb >= L + 2) { M = B; nm = nb; D = R; nd = nr; }
    else return NEG;
    int j = nd, q = L - j;
    if (j < 2 || j > L - 2) return NEG;
    (void)nm;
    int S[256]; ll sS = 0, sD = 0;
    for (int i = 0; i < L; i++) { S[i] = M[i]; sS += S[i]; }
    for (int i = 0; i < nd; i++) sD += D[i];
    int isD[1024]; memset(isD, 0, sizeof isD);
    for (int i = 0; i < nd; i++) isD[D[i]] = 1;
    int m1 = S[0], m2 = S[1];
    ll zsum[256], rval[256];
    for (int a = 0; a < L; a++) {
        int rp = S[a]; int r = (rp != m1) ? m1 : m2; rval[a] = r;
        ll z = 0; int c = 0;
        for (int i = 0; i < L && c < q - 1; i++) { if (S[i] == r || S[i] == rp) continue; z += S[i]; c++; }
        zsum[a] = z;
    }
    ll best = -1;
    for (int yi = 0; yi < L; yi++) {
        int y = S[yi]; int u = (y != m1) ? m1 : m2;
        ll base = sS - y + sD + (ll)q * (sS + (ll)(E - 1) * u) + (ll)(E - 1) * u;
        for (int a = 0; a < L; a++) {
            int rp = S[a]; ll t = base + zsum[a] + rval[a];
            for (int di = 0; di < L; di++) {
                int d = S[di]; if (d == y || d == rp) continue;
                int b = y + rp - d;
                if (b < 1 || b > 2 * L || !isD[b]) continue;
                int db = (b != D[0]) ? D[0] : D[1];
                ll w = t + d + (ll)E * db;
                if (best < 0 || w < best) best = w;
            }
        }
    }
    if (best < 0) return (1LL << 50);   // no triple: should not happen for 2 <= j (lemma); flag loudly
    return best - Nval;
}
static void show(const int *col) { for (int x = 1; x <= 2 * L; x++) putchar(col[x] ? 'R' : 'B'); }
static ll prefix_obj(int j) { int col[256]; for (int x = 1; x <= 2 * L; x++) col[x] = (x <= j); return objective(col); }
int main(int argc, char **argv) {
    if (argc >= 2 && strcmp(argv[1], "C") == 0) {  // usage: t1hill C < file of "l e RBRB..." lines : print objective
        char buf[600]; int l, e;
        while (scanf("%d %d %599s", &l, &e, buf) == 3) {
            L = l; E = e; Nval = F(L + E, L); int col[256];
            for (int x = 1; x <= 2 * L; x++) col[x] = (buf[x - 1] == 'R');
            ll o = objective(col); if (o == NEG) printf("None\n"); else printf("%lld\n", o);
        }
        return 0;
    }
    if (argc >= 4 && strcmp(argv[1], "X") == 0) {  // usage: t1hill X l e : exhaustive over all windows
        L = atoi(argv[2]); E = atoi(argv[3]); Nval = F(L + E, L);
        int col[256]; ll mx = NEG, mxp = NEG; long long surv = 0, survp = 0, cnt = 0; unsigned long long best = 0;
        unsigned long long NW = 1ULL << (2 * L - 1);
        for (unsigned long long w = 0; w < NW; w++) {
            col[1] = 1; for (int x = 2; x <= 2 * L; x++) col[x] = (int)((w >> (x - 2)) & 1);
            ll o = objective(col); if (o == NEG) continue; cnt++;
            int pre = 1, sw = 0; for (int x = 2; x <= 2 * L; x++) { if (col[x] && sw) { pre = 0; break; } if (!col[x]) sw = 1; }
            if (o > 0) { surv++; if (pre) survp++; if (argc >= 5) { printf("SURV "); show(col); printf(" %lld\n", o); } }
            if (o > mx) { mx = o; best = w; }
            if (pre && o > mxp) mxp = o;
        }
        col[1] = 1; for (int x = 2; x <= 2 * L; x++) col[x] = (int)((best >> (x - 2)) & 1);
        printf("EXH l=%d e=%d N=%lld windows=%lld max_obj=%lld max_prefix_obj=%lld survivors=%lld prefix_survivors=%lld argmax=", L, E, Nval, cnt, mx, mxp, surv, survp); show(col); printf("\n");
        return 0;
    }
    if (argc >= 4 && strcmp(argv[1], "P") == 0) {  // usage: t1hill P l e0
        L = atoi(argv[2]); int e0 = atoi(argv[3]);
        for (E = e0; E < 4 * L; E++) {
            Nval = F(L + E, L); ll mx = NEG; int jb = -1;
            for (int j = 2; j <= L - 2; j++) { ll o = prefix_obj(j); if (o > mx) { mx = o; jb = j; } }
            printf("l=%d e=%d max_prefix_obj=%lld at j=%d\n", L, E, mx, jb); fflush(stdout);
            if (mx <= 0) break;
        }
        return 0;
    }
    if (argc < 6) { fprintf(stderr, "usage: t1hill l e iters restarts seed\n"); return 1; }
    L = atoi(argv[1]); E = atoi(argv[2]); long iters = atol(argv[3]); int restarts = atoi(argv[4]);
    rs ^= (unsigned long long)atoll(argv[5]) * 2654435761ULL;
    Nval = F(L + E, L);
    int col[256], cur[256], bestcol[256]; ll bestobj = NEG;
    for (int rr = 0; rr < restarts; rr++) {
        // start: prefix window red=[1,j] (rr even) or a random window (rr odd)
        int j0 = 2 + (int)(rnd() % (L - 3));
        for (int x = 1; x <= 2 * L; x++) cur[x] = 0;
        if (rr % 2 == 0) { for (int x = 1; x <= j0; x++) cur[x] = 1; }
        else { cur[1] = 1; for (int x = 2; x <= 2 * L; x++) cur[x] = (int)(rnd() & 1); }
        ll co = objective(cur);
        for (long it = 0; it < iters; it++) {
            memcpy(col, cur, sizeof(int) * (2 * L + 1));
            int nflip = 1 + (int)(rnd() % 3);
            for (int f = 0; f < nflip; f++) { int x = 2 + (int)(rnd() % (2 * L - 1)); col[x] ^= 1; }
            ll o = objective(col);
            if (o >= co) { co = o; memcpy(cur, col, sizeof(int) * (2 * L + 1)); }
        }
        if (co > bestobj) { bestobj = co; memcpy(bestcol, cur, sizeof(int) * (2 * L + 1)); }
        printf("restart %d obj %lld  ", rr, co); show(cur); printf("\n"); fflush(stdout);
    }
    printf("BEST l=%d e=%d N=%lld obj=%lld window=", L, E, Nval, bestobj); show(bestcol); printf("\n");
    return 0;
}
