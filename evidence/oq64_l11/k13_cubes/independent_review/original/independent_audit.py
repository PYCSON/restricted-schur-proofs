#!/usr/bin/env python3
"""Independent RSN T19 A1-A3/A5 audit. No imports from Claude's checkers.
Inputs: six user-supplied ZIPs extracted under core/ and lrat/.
Exact integer arithmetic, no finite sampling for symbolic inequalities.
"""
from pathlib import Path
import collections, hashlib, json, lzma, math, re, time, sys
ROOT=Path(__file__).resolve().parent
FOLDER=ROOT/'core/evidence/oq64_l11/k13_cubes/full_t19'
JDIR=FOLDER/'certs'; LDIR=ROOT/'lrat'
OUT=ROOT/'independent_audit_results.json'

def load_records():
    rec={}
    for ln in (FOLDER/'results.tsv').read_text().splitlines():
        if not ln.strip():continue
        a=ln.split('\t'); assert len(a)>=2 and re.fullmatch('[01]+',a[0]),'bad TSV line'
        assert a[0] not in rec,'duplicate prefix'
        rec[a[0]]='\t'.join(a[1:]);
    return rec

def posforall(p,k0=13,strict=True):
    # p integer coefficient polynomial degree <=2; f(k0+t) with t nonnegative integer.
    c0,c1,c2=p
    a=c2; b=c1+2*k0*c2; c=c0+k0*c1+k0*k0*c2
    thresh=1 if strict else 0
    if a<0:return False
    if a==0:
        return b>=0 and c>=thresh
    argmax=max(0, -b//(2*a))
    return min(a*t*t+b*t+c for t in {0,argmax,argmax+1})>=thresh

def main():
    start=time.monotonic(); records=load_records(); keys=sorted(records)
    assert len(keys)==222, f'got {len(keys)} prefixes'
    assert all(not q.startswith(p) for i,p in enumerate(keys) for q in keys[i+1:]),'prefix overlap'
    L=max(map(len,keys)); coverage=sum(1<<(L-len(p)) for p in keys)
    assert coverage==1<<L, 'incomplete prefix partition'
    assert all('PASS' in records[p] for p in keys)
    lens=dict(sorted(collections.Counter(map(len,keys)).items()))
    manifest={}
    for line in (FOLDER/'SHA256SUMS_certs').read_text().splitlines():
        if not line.strip():continue
        h,n=line.split(maxsplit=1);n=n.lstrip('*').strip()
        assert n not in manifest and re.fullmatch('[0-9a-f]{64}',h)
        manifest[n]=h
    wanted={f'certC{p}_11_13.{ext}.xz' for p in keys for ext in ('json','lrat')}
    assert set(manifest)==wanted,f'manifest extra/missing: {len(manifest)} vs {len(wanted)}'
    assert {p.name for p in JDIR.glob('*.json.xz')}=={x for x in wanted if x.endswith('.json.xz')}
    assert {p.name for p in LDIR.glob('*.lrat.xz')}=={x for x in wanted if x.endswith('.lrat.xz')}
    hcount=0; hbytes=0
    for name,h in manifest.items():
        path=(JDIR/name if name.endswith('json.xz') else LDIR/name)
        digest=hashlib.file_digest(path.open('rb'),'sha256').hexdigest()
        assert digest==h,f'hash mismatch {name}'
        hcount+=1;hbytes+=path.stat().st_size
    print('A1 PASS',len(keys),'prefixes, depth',lens,'coverage',coverage,'/',1<<L,'hashes',hcount,flush=True)
    stats={'prefix_count':len(keys),'depth_counts':lens,'coverage_denominator':1<<L,'coverage_numerator':coverage,'hashed_files':hcount,'hashed_bytes':hbytes,'total_edges':0,'max_edges':0,'total_distinct_pair_tests':0,'unique_symbolic_vertex_polynomials':set(),'sample_units':[],'per_cube':{}}
    for idx,pre in enumerate(keys):
        path=JDIR/f'certC{pre}_11_13.json.xz'
        with lzma.open(path,'rt') as fh:j=json.load(fh)
        assert j['l']==11 and j['k0']==13 and j['F']==[99,56,1] and j['F_extra']==0
        assert j['prefix']==pre
        V=[tuple(map(int,v)) for v in j['vertices']];nv=len(V)
        assert len(V)==len(set(V)),'duplicate vertices'
        assert 0<=j['unit_red']<nv and V[j['unit_red']]==(1,0,0)
        for q in V:
            assert len(q)==3 and posforall(tuple(x-y for x,y in zip(q,(1,0,0))),strict=False),f'vertex below 1 {pre} {q}'
            assert posforall(tuple(y-x for x,y in zip(q,(99,56,1))),strict=False),f'vertex above F {pre} {q}'
            stats['unique_symbolic_vertex_polynomials'].add(q)
        units=[(int(v),int(c)) for v,c in j['cube_units']]
        exp_units={(j['unit_red'],0)}
        for i,b in enumerate(pre):
            q=(i+2,0,0)
            assert q in V, f'missing constant prefix vertex: {pre} {q}'
            exp_units.add((V.index(q),int(b)))
        assert len(exp_units)==len(pre)+1 and set(units)==exp_units and len(units)==len(exp_units),'cube units mismatch'
        # Check every summand identity and exact pairwise distinctness on all integer k >= 13.
        local_pairs={};edges=j['edges']
        for n,e in enumerate(edges):
            a=e['a'];w=e['w'];c=e['c'];O=e['others']
            assert type(c)==int and 10<=c<=12 and len(O)==10, (pre,n,'mult count')
            assert all(type(m)==int and m>=1 and isinstance(o,int) and 0<=o<nv for m,o in O)
            assert sum(m for m,o in O)==c
            assert isinstance(a,int) and isinstance(w,int) and 0<=a<nv and 0<=w<nv
            A=V[a];W=V[w]
            assert A[2]==0, (pre,n,'a degree')
            RHS=[-c*A[0], A[0]-c*A[1], A[1]]
            for m,o in O:
                RHS=[RHS[i]+m*V[o][i] for i in range(3)]
            assert tuple(RHS)==W,(pre,n,'identity')
            indices=[a]+[o for m,o in O]
            assert len(set(indices))==11,(pre,n,'repeat summand')
            for i,x in enumerate(indices):
                for y in indices[i+1:]:
                    pair=(min(x,y),max(x,y))
                    if pair not in local_pairs:
                        difference=tuple(V[x][i]-V[y][i] for i in range(3))
                        ok=posforall(difference,strict=True) or posforall(tuple(-z for z in difference),strict=True)
                        local_pairs[pair]=ok
                    assert local_pairs[pair],(pre,n,'symbolic distinctness',V[x],V[y])
        assert len(edges)>0
        stats['total_edges']+=len(edges); stats['max_edges']=max(stats['max_edges'],len(edges));stats['total_distinct_pair_tests']+=len(local_pairs)
        mm=re.search(r'edges=(\d+)',records[pre]);assert mm and int(mm.group(1))==len(edges),'result.tsv edge mismatch'
        stats['per_cube'][pre]={'vertices':nv,'edges':len(edges),'checked_pairs':len(local_pairs),'units':len(units)}
        if idx<3:stats['sample_units'].append({'prefix':pre,'units':[(V[i],c) for i,c in units]})
        if (idx+1)%30==0:print('A3 progress',idx+1,'/222', 'edges',stats['total_edges'],'elapsed',round(time.monotonic()-start,1),flush=True)
    stats['unique_symbolic_vertex_polynomials']=len(stats['unique_symbolic_vertex_polynomials'])
    stats['elapsed_seconds']=round(time.monotonic()-start,2)
    OUT.write_text(json.dumps(stats,indent=2,ensure_ascii=False))
    print('A2-A3 PASS: certs',len(keys),'edges',stats['total_edges'],'max_edges',stats['max_edges'],'distinct pairs',stats['total_distinct_pair_tests'],'seconds',stats['elapsed_seconds'],flush=True)
    return stats

if __name__=='__main__':main()
