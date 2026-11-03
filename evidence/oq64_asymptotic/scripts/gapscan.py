if not __debug__: raise SystemExit("refusing to run under python -O")
import sys, math
sys.argv=[sys.argv[0]]
exec(open('t1fill_bound.py').read().split("for l in [int(x)")[0])
a=(math.sqrt(2)-1)/2
def eL_fast(l):
    # largest e such that some j has V3(l,e,j)-1 >= F(l+e,l)  (3-block colouring of [1,F] good)
    best=0
    e=max(1,int(a*l)-10)
    while True:
        if any(V3(l,e,j)-1>=F(l+e,l) for j in range(1,l)): best=e; e+=1
        else:
            if e>a*l+5: break
            e+=1
    return best
def eU_fast(l):
    e=max(1,int(a*l)-10)
    while not ok(l,e): e+=1
    return e
worstU=-9; worstL=9
for l in list(range(20,201))+list(range(250,3001,250)):
    eu=eU_fast(l); el=eL_fast(l)
    worstU=max(worstU,eu-a*l); worstL=min(worstL,el-a*l)
    if l%50==0 or l<=24 or l>=250: print(l,'eL',el,'eU',eu,'a*l=%.2f'%(a*l),'eU-a*l=%.2f'%(eu-a*l),'eL-a*l=%.2f'%(el-a*l),'gap K: %d..%d'%(l+el+1,l+eu),flush=True)
print('max eU-a*l',round(worstU,3),'min eL-a*l',round(worstL,3))
