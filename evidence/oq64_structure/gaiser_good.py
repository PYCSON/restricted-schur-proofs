#!/usr/bin/env python3
"""Write Gaiser's three-block colouring of [1, F-1]: red [1,s-1], blue [s,t-1], red [t,F-1]; s=k+D, t=ks+D.
Output: n entries 0 (red) / 1 (blue).   usage: gaiser_good.py k l out.good"""
import sys
k, l = int(sys.argv[1]), int(sys.argv[2]); D = l * (l - 1) // 2
F = k * k + ((l + 1) * (l - 2) // 2 + 2) * k + l * (l - 2); s = k + D; t = k * s + D
col = [0 if (x < s or x >= t) else 1 for x in range(1, F)]
open(sys.argv[3], 'w').write(' '.join(map(str, col)) + '\n'); print(f'k={k} l={l} F={F} s={s} t={t} n={F-1}')
