"""Exact goodness check of a 2-colouring of [1,n] for the exact-version S_2(k;l) problem, via bitset DP:
for each colour class X, the set of sums sum m_i x_i (l distinct x_i in X, m_i>=1, sum m_i = k) is computed
exactly (as a bitmask of sums <= n); the colouring is good iff that set misses X for both colours."""
def sumset(X, k, l, n):
    mask = (1 << (n+1)) - 1
    dp = [[0]*(k+1) for _ in range(l+1)]
    dp[0][0] = 1
    for x in sorted(X):
        for j in range(min(l-1, len(X)), -1, -1):
            for t in range(k-1, -1, -1):
                cur = dp[j][t]
                if not cur: continue
                # remaining distinct values after this one: l-j-1, each needs multiplicity >= 1
                for m in range(1, k - t - (l-j-1) + 1):
                    sh = cur << (m*x)
                    if not (sh & mask): break
                    dp[j+1][t+m] |= sh & mask
    return dp[l][k]
def good(col, k, l):
    """col: list/str of length n with col[i] in {0,1} for integer i+1"""
    n = len(col)
    for X in (0, 1):
        S = [i+1 for i in range(n) if col[i] == X]
        bm = 0
        for x in S: bm |= 1 << x
        if sumset(S, k, l, n) & bm: return False
    return True
def blocks_to_col(blocks, n):
    """blocks: list of (colour, start) in increasing start; first start must be 1"""
    col = [None]*n
    for idx, (c, st) in enumerate(blocks):
        en = blocks[idx+1][1]-1 if idx+1 < len(blocks) else n
        for i in range(st, min(en, n)+1): col[i-1] = c
    return col
if __name__ == '__main__':
    import sys
    # verify the k=l construction for l=5..9
    for l in range(4, 10):
        D = l*(l-1)//2; a = (l*l+3*l-2)//2; b = (l-1)*a+D; n = b+l*(l+1)//2-1
        col = blocks_to_col([(0,1),(1,2),(0,a+1),(1,b+1)], n)
        col1 = blocks_to_col([(0,1),(1,2),(0,a+1),(1,b+1)], n+1)
        F = (l**3+3*l*l-2*l)//2
        print(f"l={l}: construction n={n} (F(l,l)={F}): good={good(col,l,l)}; extended to n+1 good={good(col1,l,l)}")
