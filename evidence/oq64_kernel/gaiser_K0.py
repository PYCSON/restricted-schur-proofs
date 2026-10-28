"""Route (b): explicit threshold from Gaiser Sec.5 as summarised (arXiv:2608.08789v1).
For each l, enumerate 2-colourings of [1,2l-1], find chosen set u (smallest l elements of the colour that
first reaches l elements -- the colour of 1 if it has >= l elements), classify Case 1/2/3, and compute the
largest integer used by the identities. K0 = least k >= 3l-1 with T'(k) >= all of them (and stays so)."""
import itertools, sys
def Tp(k,l): return k*k+((l+1)*(l-2)//2+2)*k+l*(l-2)
def configs(l):
    N=2*l-1
    for bits in itertools.product([0,1],repeat=N-1):
        col=(0,)+bits            # colour of 1 fixed (symmetry)
        R=[i+1 for i in range(N) if col[i]==0]; B=[i+1 for i in range(N) if col[i]==1]
        X,Y=(R,B) if len(R)>=l else (B,R)
        u=X[:l]
        yield col,u,Y
def needs(l):
    out=[]   # list of (case, maxvalue as function of k: (a,b) meaning a*k+b) 
    E=(l-1)*(l-2)//2
    for col,u,Y in configs(l):
        if u==list(range(1,l+1)):
            out.append(('1',None)); continue
        if u==[2*i-1 for i in range(1,l+1)]:
            out.append(('2',(6,4*l*l-10*l+1))); continue
        j=next(i for i in range(l-1) if u[i+1]==u[i]+1)+1   # 1-based smallest j with u_{j+1}=u_j+1
        v=min(Y); U=sum(u); uj=u[j-1]
        # Q(k) = (k-l)v + l*U + l(k-l)uj + E  = (v+l*uj)k + (-l v + l U - l*l*uj + E)
        a=v+l*uj; b=-l*v+l*U-l*l*uj+E
        if l==3 and j==2: out.append(('3.3',(8,10),tuple(u),v))
        else: out.append(('3.1' if j<=l-2 else '3.2',(a,b),tuple(u),v))
    return out
for l in range(3,int(sys.argv[1])+1 if len(sys.argv)>1 else 9):
    N=needs(l)
    lin=[x[1] for x in N if x[1] is not None]
    worst=max(lin,key=lambda ab:(ab[0],ab[1]))
    k=3*l-1
    def ok(k): return all(Tp(k,l)>=a*k+b for a,b in lin)
    while not ok(k): k+=1
    # check it stays ok for larger k (quadratic minus linear is increasing once positive slope)
    assert all(ok(kk) for kk in range(k,k+500))
    cases={}
    for x in N: cases[x[0]]=cases.get(x[0],0)+1
    print(f"l={l}: K0={k}  (3l-1={3*l-1})  configs={len(N)} cases={cases}  worst identity value ~ {worst[0]}k+{worst[1]}")
