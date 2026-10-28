"""Pretty-print the proof tree (tree_<l>_<k0>.json): for each leaf, the branch decisions and the minimal chain
of forced deductions that leads to the contradiction."""
import json, sys
def fmt(p):
    c0,c1,c2=p; s=[]
    if c2: s.append(('' if c2==1 else str(c2))+'k^2')
    if c1: s.append(('' if c1==1 else ('-' if c1==-1 else str(c1)))+'k')
    if c0 or not s: s.append(str(c0))
    out='+'.join(s).replace('+-','-'); return out
def fmt_edge(a,c,oth):
    terms=[f"(k-{c})·{fmt(tuple(a))}"]+[f"{m}·{fmt(tuple(o))}" if m>1 else fmt(tuple(o)) for m,o in oth]
    return ' + '.join(terms)
C='RB'
d=json.load(open(sys.argv[1])); l=d['l']; k0=d['k0']
leaves=[]
def walk(node, decisions, facts):
    f=dict(facts)
    for (w,col,reason) in node['forced']: f[tuple(w)]=(col,reason)
    if 'contradiction' in node:
        leaves.append((decisions, f, node['contradiction'])); return
    x=node['branch']
    for X,ch in zip((0,1),node['children']):
        f2=dict(f); f2[(x,0,0)]=(X,'branch')
        walk(ch, decisions+[(x,C[X])], f2)
walk(d['tree'], [(1,'R')], {(1,0,0):(0,'branch')})
print(f"l={l} k>={k0}: {len(leaves)} leaves")
for dec, f, con in leaves[:int(sys.argv[2]) if len(sys.argv)>2 else 10**9]:
    w,a,c,oth,X=con
    need=[]; seen=set()
    def back(v):
        v=tuple(v)
        if v in seen: return
        seen.add(v)
        col,reason=f[v]
        if reason=='branch': return
        a2,c2,oth2=reason
        for u in [a2]+[o for m,o in oth2]: back(u)
        need.append((v,col,reason))
    for u in [a]+[o for m,o in oth]: back(u)
    back(w)
    print('CASE', ' '.join(f"{x}{c}" for x,c in dec))
    for v,col,(a2,c2,oth2) in need:
        print(f"   {fmt(v):>12} is {C[col]}   since  {fmt_edge(a2,c2,oth2)} = {fmt(v)} (all {C[1-col]})")
    print(f"   CONTRADICTION: {fmt_edge(a,c,oth)} = {fmt(tuple(w))}, all {C[X]}")
