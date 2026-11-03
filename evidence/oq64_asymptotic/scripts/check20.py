if not __debug__: raise SystemExit("refusing to run under python -O")
import sys, time
sys.argv=[sys.argv[0]]
exec(open('goodcheck.py').read().split("if __name__")[0])
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
l,e,j=20,1,5; k=l+e
m=l*(l+1)//2+l*j+e*(j+1)-1
V=j*(j+1)//2+(l-j)*(m+1)+(l-j)*(l-j-1)//2+e
print('l,e,j=',l,e,j,'m=',m,'V3=',V,'F=',F(k,l),flush=True)
t0=time.time()
col=[None]+['R' if (x<=j or x>m) else 'B' for x in range(1,V)]
print('[1,V3-1] good:',is_good(col,k,l),'time',round(time.time()-t0),'s',flush=True)
