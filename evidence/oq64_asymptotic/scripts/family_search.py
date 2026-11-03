if not __debug__: raise SystemExit("refusing to run under python -O")
# generalized "small set" constructions: colour X = Ss (|Ss|=j<l) plus [m+1,V-1]; colour Y = [1,m] minus Ss.
import sys, random, itertools
def F(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def V(l,e,Ss):
    Ss=sorted(Ss); j=len(Ss); s=set(Ss)
    Y=[]; x=1
    while len(Y)<l:
        if x not in s: Y.append(x)
        x+=1
    m=sum(Y)+e*Y[0]-1
    if m<Ss[-1]: return None
    return sum(Ss)+sum(m+i for i in range(1,l-j+1))+e*Ss[0]
l=int(sys.argv[1]); e=int(sys.argv[2]); f=F(l+e,l); random.seed(5)
best=(0,None)
for j in range(1,l):
    base=list(range(1,j+1)); v=V(l,e,base)
    if v and v>best[0]: best=(v,base)
    # local search: move one element
    cur=base; cv=v
    for it in range(4000):
        c=list(cur); i=random.randrange(j); c[i]=random.randint(1,3*l)
        if len(set(c))<j: continue
        nv=V(l,e,c)
        if nv and nv>=cv: cur,cv=sorted(c),nv
    if cv>best[0]: best=(cv,cur)
print('l',l,'e',e,'F',f,'best V',best[0],'Ss',best[1],'beats F' if best[0]-1>=f else '')
