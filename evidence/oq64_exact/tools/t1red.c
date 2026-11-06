// Exact enumeration of the windows of [1,2l] (minority size 2 <= j <= l-2) that are NOT refuted by the
// T1-fill template at a given e, using the reduction:
//   For a window W let S1 = the l smallest majority elements and m_l = max S1.  Recolouring every position
//   > m_l to the majority colour gives W' with D(W') = D(W) ∩ [1, m_l].  Every T1-fill parameter choice
//   valid for W' is valid for W, and w(W) <= w(W') - t(Sigma0 - 2l) <= w(W') where t = |D(W) \ D(W')|.
//   Hence min_w(W) <= min_w(W') whenever |D(W')| >= 2.
// So: (1) enumerate all W' (|D'| >= 2, all positions after m_l majority); if W' is refuted, so is every W
// over it; otherwise check every W over W' individually.  (2) enumerate directly the windows with
// |D ∩ [1, m_l]| <= 1.  Survivors (obj > 0) are printed as  SURV <window> <obj>.
// usage: t1red l e
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef long long ll;
static int L, E; static ll Nval;
static ll F(ll k, ll l) { return k * k + ((l + 1) * (l - 2) / 2 + 2) * k + l * (l - 2); }
#define NEG (-(1LL << 60))
// col[x]: 1 = colour of 1 ('R'), 0 = other.  early: return -1 as soon as some parameter choice gives w <= N.
static ll evalw(const int *col, int early) {
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
    for (int a = 0; a < L; a++) {
        int rp = S[a]; int r = (rp != m1) ? m1 : m2; rval[a] = r; ll z = 0; int c = 0;
        for (int i = 0; i < L && c < q - 1; i++) { if (S[i] == r || S[i] == rp) continue; z += S[i]; c++; }
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
    if (best < 0) return (1LL << 50);  // no triple at all: report as survivor
    return best - Nval;
}
static long long nWp = 0, nWpSurv = 0, nChecked = 0, nSurv = 0, nSmall = 0;
static void show(const int *col) { for (int x = 1; x <= 2 * L; x++) putchar(col[x] ? 'R' : 'B'); }
static void report(const int *col) {
    nChecked++; ll o = evalw(col, 0);
    if (o == NEG) return;
    if (o > 0) { nSurv++; printf("SURV "); show(col); printf(" %lld\n", o); }
}
// all windows over W': positions mlpos+1..2L may be recoloured to the minority, keeping j <= L-2
static void expand(int *col, int mcol, int pos, int jcur) {
    if (pos > 2 * L) { report(col); return; }
    expand(col, mcol, pos + 1, jcur);                       // keep majority
    if (jcur + 1 <= L - 2) { col[pos] = !mcol; expand(col, mcol, pos + 1, jcur + 1); col[pos] = mcol; }
}
int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: t1red l e\n"); return 1; }
    L = atoi(argv[1]); E = atoi(argv[2]); Nval = F(L + E, L);
    int col[256];
    for (int mcol = 1; mcol >= 0; mcol--) {               // majority = colour of 1 (red) or the other colour
        for (int jp = 2; jp <= L - 2; jp++) {
            int len = L + jp;                              // m_l = len; positions 1..len-1 hold jp minority + l-1 majority
            // choose the minority positions among 1..len-1; position 1 must be majority iff mcol==1
            int free = len - 1;
            // iterate over bitmasks of size `free` with exactly jp bits (bit i <-> position i+1)
            if (free > 62) return 2;
            unsigned long long v = (jp == 0) ? 0 : ((1ULL << jp) - 1);
            while (v < (1ULL << free)) {
                int pos1min = (int)(v & 1ULL);             // is position 1 minority?
                int ok = mcol ? !pos1min : pos1min;
                if (ok) {
                    for (int x = 1; x <= 2 * L; x++) col[x] = mcol;
                    for (int i = 0; i < free; i++) if ((v >> i) & 1ULL) col[i + 1] = !mcol;
                    nWp++;
                    if (evalw(col, 1) != -1) { nWpSurv++; expand(col, mcol, len + 1, jp); }
                }
                unsigned long long t = v | (v - 1); v = (t + 1) | (((~t & -~t) - 1) >> (__builtin_ctzll(v) + 1));
            }
        }
        // windows with at most one minority element below m_l: S1 inside [1, l+1]
        for (int a = 0; a <= L; a++) {                     // a = 0: no low minority (S1=[1,l]); else S1=[1,l+1]\{a}
            if (a == 0) { if (!mcol) continue; }            // majority blue needs 1 in the minority, i.e. a = 1
            else if (!mcol && a != 1) continue;
            else if (mcol && a == 1) continue;
            int ml = (a == 0) ? L : L + 1;
            for (int x = 1; x <= 2 * L; x++) col[x] = mcol;
            if (a) col[a] = !mcol;
            nSmall++;
            expand(col, mcol, ml + 1, a ? 1 : 0);
        }
    }
    printf("DONE l=%d e=%d N=%lld reducedWindows=%lld reducedNotRefuted=%lld windowsCheckedIndividually=%lld survivors=%lld lowCases=%lld\n",
           L, E, Nval, nWp, nWpSurv, nChecked, nSurv, nSmall);
    return 0;
}
