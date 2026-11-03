import sys, random
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import *
random.seed(3)
# extra naive validation at l=5
for trial in range(60):
    l=5; e=random.randint(1,2); k=l+e; n=random.randint(8,22)
    col=[None]+[random.choice('RB') for _ in range(n)]
    assert (bad_witness(col,k,l) is None)==(naive_bad(col,k,l) is None)
print('l=5 naive agreement ok')
# three-block: good on [1,V3-1] for small (l,e,j); check extension at V3
bad=0; tot=0
for l in range(3,10):
    for e in range(0,5):
        k=l+e
        for j in range(1,l):
            col,V3,m=threeblock(l,e,j)
            g=bad_witness(col,k,l)
            ext=[c for c in 'RB' if is_good(col+[c],k,l)]
            tot+=1
            if g is not None: bad+=1; print('NOT GOOD',l,e,j,V3,g)
print('three-block small cases tested',tot,'not good',bad)
for (l,k,j) in [(19,20,5),(20,21,5)]:
    e=k-l
    col,V3,m=threeblock(l,e,j)
    print(f'l={l} k={k} j={j}: m={m} V3={V3} F={F(k,l)} good on [1,V3-1]:',bad_witness(col,k,l) is None)
