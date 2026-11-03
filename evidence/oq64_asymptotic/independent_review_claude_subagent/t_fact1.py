import sys
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import F, sums_exact
def check_rep(ms,k,l,a,b,target):
    return len(ms)==k and len(set(ms))==l and min(ms)>=a and max(ms)<=b and sum(ms)==target
def fact1_construct(a,b,k,l,v):
    """the proof's construction for value v in [ka+D, kb-D]"""
    e=k-l
    for c in range(a,b-l+2):
        S=list(range(c,c+l)); base=sum(S)
        if base+e*c<=v<=base+e*(c+l-1):
            need=v-base; ext=[c]*e; i=0
            # move extras up one unit at a time
            while sum(ext)<need:
                if ext[i]<c+l-1: ext[i]+=1
                else: i+=1
            return S+ext
    # gap value (e=1 only)
    assert e==1
    for c in range(a,b-l+1):
        if v==l*c+(l*(l-1))//2+c+l:
            if c+l+1<=b:
                return list(range(c,c+l-1))+[c+l+1]+[c+l-2]
            else:
                return [c-1]+list(range(c+2,c+l+1))+[c+2]
    return None
tot=0; bad=0; dpbad=0
for l in range(3,16):
    D=l*(l-1)//2
    for e in range(1,6):
        k=l+e
        for a in range(1,6):
            for n in range(l+2,l+8):
                b=a+n-1
                lo,hi=k*a+D,k*b-D
                # exact set via DP on C=[a,b]
                S=sums_exact(list(range(a,b+1)),k,l,hi+5)
                got={y for y in range(hi+6) if (S>>y)&1}
                if got!=set(range(lo,hi+1)): dpbad+=1; print('DP: Sigma(a,b) != interval',l,e,a,b)
                for v in range(lo,hi+1):
                    ms=fact1_construct(a,b,k,l,v); tot+=1
                    if ms is None or not check_rep(ms,k,l,a,b,v): bad+=1; print('construct fail',l,e,a,b,v,ms); break
print('Fact 1: constructive values checked',tot,'failures',bad,'; DP interval mismatches',dpbad)
# n = l+1 boundary (not claimed): show the gap at e=1
l=6;e=1;k=7;D=15;a=1;b=7
S=sums_exact(list(range(a,b+1)),k,l,200); got={y for y in range(200) if (S>>y)&1}
print('n=l+1,e=1 missing:',sorted(set(range(k*a+D,k*b-D+1))-got))
# all-red window chain
fails=0;cnt=0
for l in range(3,60):
    D=l*(l-1)//2
    for e in range(1,40):
        k=l+e; Fv=F(k,l); cnt+=1
        lo1,hi1=k+D,2*k*l-D
        ok = lo1>2*l and hi1<=Fv and (hi1-lo1+1)>=l+2
        t=k*lo1+D; top2=k*hi1-D
        ok &= t>hi1 and top2>=Fv and t<=Fv
        ms=[1]*(k-l+1)+list(range(2,l))+[t]
        ok &= len(ms)==k and len(set(ms))==l and sum(ms)==Fv
        if not ok: fails+=1; print('all-red fail',l,e)
print('all-red chain checked',cnt,'(l,e) pairs; failures',fails)
