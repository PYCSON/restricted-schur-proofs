#!/usr/bin/env python3
# print best four-block colouring parameters for (k,l): "V j m" and exactcheck red blocks
import sys
from fourblock import best4, F
k, l = int(sys.argv[1]), int(sys.argv[2])
M, j, m = best4(k, l)
print(k, l, M, f"1:1 {j+2}:{m}", "F=%d V=%d j=%d m=%d" % (F(k, l), M+1, j, m))
