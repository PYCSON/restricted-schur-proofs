#!/usr/bin/env python3
"""Independent check of Gaiser's restricted generalized Schur number S_r(k;2):
least n s.t. every r-colouring of [1,n] has a monochromatic solution of x_1+...+x_k = x_{k+1} using exactly
3 distinct integers, i.e.  i*u + (k-i)*v = w  with u != v, 1 <= i <= k-1  (w automatically differs from u, v).
usage: s3k2.py r k n CAD [lrat]  -> SAT/UNSAT (and LRAT proof checked if requested)"""
import sys, subprocess
if sys.argv[1]=='--cnf-only':          # regenerate the CNF only (no solver needed)
    sys.argv.pop(1); CNF_ONLY=True
else: CNF_ONLY=False
r,k,n=map(int,sys.argv[1:4]); CAD=sys.argv[4] if len(sys.argv)>4 else None; want_lrat=len(sys.argv)>5
V=lambda m,c: r*(m-1)+c+1
cl=[]
for m in range(1,n+1):
    cl.append([V(m,c) for c in range(r)])
    for c in range(r):
        for d in range(c+1,r): cl.append([-V(m,c),-V(m,d)])
cl.append([V(1,0)])          # colour symmetry: 1 has colour 0
sols=set()
for i in range(1,k):
    for u in range(1,n+1):
        if i*u+(k-i) > n: break
        for v in range(1,n+1):
            if v==u: continue
            w=i*u+(k-i)*v
            if w>n: break
            sols.add(tuple(sorted((u,v,w))))
for s in sols:
    for c in range(r): cl.append([-V(m,c) for m in s])
fn=f"s{r}_{k}_{n}.cnf"
open(fn,"w").write(f"p cnf {r*n} {len(cl)}\n"+"\n".join(" ".join(map(str,c))+" 0" for c in cl)+"\n")
if CNF_ONLY:
    print("wrote",fn); sys.exit(0)
args=[CAD,'-q',fn]+([f"s{r}_{k}_{n}.lrat",'--lrat=true','--binary=false'] if want_lrat else [])
out=subprocess.run(args,capture_output=True,text=True).stdout
res=[l for l in out.split('\n') if l.startswith('s ')][0]
print(f"r={r} k={k} n={n}: {res}  ({len(sols)} solution sets)")
if 'UNSAT' not in res:
    val=set(int(t) for l in out.split('\n') if l.startswith('v') for t in l.split()[1:] if int(t)>0)
    col=''.join('RBGYW'[next(c for c in range(r) if V(m,c) in val)] for m in range(1,n+1))
    # independent re-check of the witness
    bad=[s for s in sols if len({col[x-1] for x in s})==1]
    print("  witness re-check: monochromatic sets =",len(bad))
    open(f"wit_{r}_{k}_{n}.txt","w").write(col)
