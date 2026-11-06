// One-pass version of t1red for a range of e (elo..ehi).  Writes red_l<l>_e<e>.txt for each e; each file is
// meant to be byte-identical to the output of `t1red l e`.  Uses, besides the reduction lemma of t1red:
//   monotonicity in e (l >= 9): if a parameter choice gives w <= N at e, it gives w <= N at every e' >= e
//   (dw/de = (q+1)u + d_b < N(e+1) - N(e)).  So a (reduced) window refuted at e is refuted at all larger e.
// The C objective and the zsum formula are those of t1red2 (validated identical to t1red).
// usage: t1multi l elo ehi                      (whole range; writes red_l<l>_e<e>.txt)
//        t1multi l elo ehi mcol jlo jhi low tag  (one segment: majority colour mcol, 2<=jlo<=jp<=jhi, low cases iff low=1;
//                                                 writes red_l<l>_e<e>.<tag>.part, combined by t1combine.py)
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
static long long nWp = 0, nWpSurv[64], nChecked[64], nSurv[64], nSmall = 0;
static FILE *out[64];
static void show(FILE *f, const int *col) { for (int x = 1; x <= 2 * L; x++) fputc(col[x] ? 'R' : 'B', f); }
// W is checked at every e in [ELO, emax-1] (emax = first e at which its reduced window is refuted)
static void report(const int *col, int emax) {
    int refuted = 0;
    for (int e = ELO; e < emax; e++) {
        nChecked[e]++;
        if (refuted) continue;                        // refuted at a smaller e => refuted here (monotonicity)
        ll o = evalw(col, e, 0);
        if (o == NEG) { refuted = 1; continue; }      // not a (U) window with 2<=j<=l-2: never reported
        if (o > 0) { nSurv[e]++; fprintf(out[e], "SURV "); show(out[e], col); fprintf(out[e], " %lld\n", o); }
        else refuted = 1;
    }
}
static void expand(int *col, int mcol, int pos, int jcur, int emax) {
    if (pos > 2 * L) { report(col, emax); return; }
    expand(col, mcol, pos + 1, jcur, emax);
    if (jcur + 1 <= L - 2) { col[pos] = !mcol; expand(col, mcol, pos + 1, jcur + 1, emax); col[pos] = mcol; }
}
int main(int argc, char **argv) {
    if (argc < 4) { fprintf(stderr, "usage: t1multi l elo ehi\n"); return 1; }
    L = atoi(argv[1]); ELO = atoi(argv[2]); EHI = atoi(argv[3]);
    if (L < 9 || ELO < 1 || EHI < ELO || EHI > 60) { fprintf(stderr, "need l>=9, 1<=elo<=ehi<=60\n"); return 1; }
    int seg = (argc >= 9), smcol = -1, sjlo = 2, sjhi = L - 2, slow = 1; const char *tag = "";
    if (seg) { smcol = atoi(argv[4]); sjlo = atoi(argv[5]); sjhi = atoi(argv[6]); slow = atoi(argv[7]); tag = argv[8];
        if ((smcol != 0 && smcol != 1) || sjlo < 2 || sjhi > L - 2 || (slow != 0 && slow != 1)) { fprintf(stderr, "bad segment\n"); return 1; } }
    for (int e = ELO; e <= EHI; e++) {
        Nv[e] = F(L + e, L); nWpSurv[e] = nChecked[e] = nSurv[e] = 0;
        char fn[128];
        if (seg) snprintf(fn, sizeof fn, "red_l%d_e%d.%s.part", L, e, tag); else snprintf(fn, sizeof fn, "red_l%d_e%d.txt", L, e);
        out[e] = fopen(fn, "w"); if (!out[e]) { perror(fn); return 1; }
    }
    int col[256];
    for (int mcol = 1; mcol >= 0; mcol--) {
        if (seg && mcol != smcol) continue;
        for (int jp = sjlo; jp <= sjhi; jp++) {
            int len = L + jp; int free = len - 1;
            if (free > 62) return 2;
            unsigned long long v = (1ULL << jp) - 1;
            while (v < (1ULL << free)) {
                int pos1min = (int)(v & 1ULL);
                int ok = mcol ? !pos1min : pos1min;
                if (ok) {
                    for (int x = 1; x <= 2 * L; x++) col[x] = mcol;
                    for (int i = 0; i < free; i++) if ((v >> i) & 1ULL) col[i + 1] = !mcol;
                    nWp++;
                    int es = ELO;
                    while (es <= EHI && evalw(col, es, 1) != -1) es++;   // first e at which W' is refuted
                    for (int e = ELO; e < es; e++) nWpSurv[e]++;
                    if (es > ELO) expand(col, mcol, len + 1, jp, es);
                }
                unsigned long long t = v | (v - 1); v = (t + 1) | (((~t & -~t) - 1) >> (__builtin_ctzll(v) + 1));
            }
        }
        for (int a = 0; a <= L && slow; a++) {
            if (a == 0) { if (!mcol) continue; }
            else if (!mcol && a != 1) continue;
            else if (mcol && a == 1) continue;
            int ml = (a == 0) ? L : L + 1;
            for (int x = 1; x <= 2 * L; x++) col[x] = mcol;
            if (a) col[a] = !mcol;
            nSmall++;
            expand(col, mcol, ml + 1, a ? 1 : 0, EHI + 1);
        }
    }
    for (int e = ELO; e <= EHI; e++) {
        if (seg) fprintf(out[e], "PART l=%d e=%d N=%lld mcol=%d jlo=%d jhi=%d low=%d reducedWindows=%lld reducedNotRefuted=%lld windowsCheckedIndividually=%lld survivors=%lld lowCases=%lld\n",
                L, e, Nv[e], smcol, sjlo, sjhi, slow, nWp, nWpSurv[e], nChecked[e], nSurv[e], nSmall);
        else fprintf(out[e], "DONE l=%d e=%d N=%lld reducedWindows=%lld reducedNotRefuted=%lld windowsCheckedIndividually=%lld survivors=%lld lowCases=%lld\n",
                L, e, Nv[e], nWp, nWpSurv[e], nChecked[e], nSurv[e], nSmall);
        fclose(out[e]);
        printf("DONE l=%d e=%d survivors=%lld reducedNotRefuted=%lld\n", L, e, nSurv[e], nWpSurv[e]);
    }
    return 0;
}
