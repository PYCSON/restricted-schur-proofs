"""Tilde version check: solutions with AT LEAST l distinct summand values (c(S) >= l+1).
Check Gaiser's RBR colouring at n=F-1 for many (k,l)."""
from dpcheck import blocks_to_col
def sumset_atleast(X, k, l, n):
    mask = (1 << (n+1)) - 1
    dp = [[0]*(k+1) for _ in range(k+1)]   # dp[j][t]: j distinct values, total multiplicity t
    dp[0][0] = 1
    for x in sorted(X):
        for j in range(k-1, -1, -1):
            for t in range(k-1, -1, -1):
                cur = dp[j][t]
                if not cur: continue
                for m in range(1, k - t + 1):
                    sh = cur << (m*x)
                    if not (sh & mask): break
                    dp[j+1][t+m] |= sh & mask
    out = 0
    for j in range(l, k+1): out |= dp[j][k]
    return out
def good_tilde(col, k, l):
    n = len(col)
    for X in (0, 1):
        S = [i+1 for i in range(n) if col[i] == X]
        bm = 0
        for x in S: bm |= 1 << x
        if sumset_atleast(S, k, l, n) & bm: return False
    return True
def F(k, l): return k*k+(((l+1)*(l-2))//2+2)*k+l*(l-2)
fails=[]
for l in range(2, 9):
    for k in range(max(l,2), l+12):
        D = l*(l-1)//2; s = k + D; t = k*s + D; n = F(k,l)-1
        col = blocks_to_col([(0,1),(1,s),(0,t)], n)
        g = good_tilde(col, k, l)
        if not g: fails.append((l,k))
print("RBR colouring at F-1 fails the tilde (>= l distinct summands) condition for (l,k):", fails)
