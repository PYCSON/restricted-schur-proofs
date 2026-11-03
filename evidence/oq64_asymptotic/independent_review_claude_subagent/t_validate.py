import random, sys
sys.path.insert(0,__import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from good import *
random.seed(7)
# 1) DP vs naive on random small colourings
cnt=0
for trial in range(400):
    l=random.randint(2,4); e=random.randint(0,2); k=l+e
    n=random.randint(l+2, 26)
    col=[None]+[random.choice('RB') for _ in range(n)]
    a=bad_witness(col,k,l) is None; b=naive_bad(col,k,l) is None
    assert a==b,(l,e,n,col)
    cnt+=1
print('DP==naive on',cnt,'random colourings')
# 2) Gaiser three-segment colouring: good on [1,F-1], F not addable in either colour
for (k,l) in [(4,3),(5,3),(5,4),(6,4),(7,5),(8,5),(9,6),(8,7),(12,8),(21,20)]:
    col=gaiser(k,l); Fv=F(k,l)
    assert len(col)-1==Fv-1
    g=is_good(col,k,l)
    ext=[c for c in 'RB' if is_good(col+[c],k,l)]
    print(f'Gaiser k={k} l={l} F={Fv}: good on [1,F-1]={g}; extendable colours at F: {ext}')
