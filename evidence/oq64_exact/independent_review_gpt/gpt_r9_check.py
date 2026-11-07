#!/usr/bin/env python3
"""Independent RSN-002 round-9 window/LRAT checker. Python standard library only.

Use: python3 -I gpt_r9_check.py evidence/oq64_exact [--jobs 2]
     python3 -I gpt_r9_check.py evidence/oq64_exact --selftest
No imports from first-party encoders or LRAT checkers.
"""
if not __debug__:
    raise SystemExit('REFUSE python -O / PYTHONOPTIMIZE')
import argparse
import concurrent.futures as cf
import hashlib
import lzma
import os
from pathlib import Path
import shutil
import sys
import tempfile

GROUPS = (
    ('l12',12,1,1160,90), ('l12',12,2,1254,26),
    ('l13',13,1,1445,147), ('l13',13,2,1553,31),
    ('l14',14,1,1773,237), ('l14',14,2,1896,37),
    ('l15',15,1,2147,419), ('l15',15,2,2286,47),
    ('l16',16,1,2570,748), ('l16',16,2,2726,65), ('l16',16,3,2884,1),
    ('l17',17,1,3045,1345), ('l17',17,2,3219,97), ('l17',17,3,3395,3),
    ('l18',18,1,3575,2461), ('l18',18,2,3768,163), ('l18',18,3,3963,4),
    ('l19',19,2,4376,274), ('l19',19,3,4591,8),
    ('l20',20,2,5046,521), ('l20',20,3,5282,15),
    ('S2_20_19',19,1,4181,3558), ('S2_21_20',20,1,4861,4426),
)
assert len(GROUPS) == 23 and sum(t[4] for t in GROUPS) == 14723

class Bad(Exception):
    pass

def require(flag, why):
    if not flag:
        raise Bad(why)

def valid_window(w, ell):
    return (len(w) == 2*ell and w.startswith('R')
            and all(x in 'RB' for x in w))

def F(k, ell):
    return k*k + (((ell+1)*(ell-2))//2+2)*k + ell*(ell-2)

def read_catalog(root, group):
    directory, ell, e, n, expected = group
    folder = root / directory
    require(folder.is_dir(), f'group directory missing: {folder}')
    red_path = folder / f'red_l{ell}_e{e}.txt'
    per_path = folder / f'perwin_l{ell}_e{e}.txt'
    edge_path = folder / f'edges_l{ell}_e{e}.txt.xz'
    proofs = folder / f'proofs_e{e}'
    require(red_path.is_file() and per_path.is_file() and edge_path.is_file(),
            f'missing catalog file for {directory} e={e}')
    require(proofs.is_dir(), f'missing proofs dir {proofs}')
    if directory.startswith('l'):
        require(F(ell+e,ell) == n, f'wrong hard-coded F for {group}')

    red, done, nlines = set(), None, 0
    with red_path.open(encoding='utf8', newline=None) as fh:
        for raw in fh:
            s=raw.strip()
            if not s:
                continue
            nlines += 1
            if s.startswith('SURV '):
                require(done is None, 'SURV appears after DONE')
                pieces=s.split()
                require(len(pieces)==3, 'bad SURV syntax')
                w=pieces[1]
                require(valid_window(w,ell), f'bad SURV window {w!r}')
                require(w not in red, f'duplicate SURV {w}')
                try: obj=int(pieces[2]); require(obj>=1,'SURV obj not positive')
                except ValueError: raise Bad('noninteger SURV obj')
                red.add(w)
            elif s.startswith('DONE '):
                require(done is None,'multiple DONE records')
                done={}
                for field in s.split()[1:]:
                    require('=' in field, f'bad DONE token {field}')
                    key,value=field.split('=',1)
                    require(key and key not in done,'duplicate/blank DONE key')
                    done[key]=value
            else:
                raise Bad(f'unrecognized red-catalog line: {s[:100]}')
    require(done is not None, 'DONE missing')
    for key,value in [('l',ell),('e',e),('N',n),('survivors',len(red))]:
        require(done.get(key)==str(value),f'DONE {key} mismatch: {done.get(key)} != {value}')

    per=[]
    with per_path.open(encoding='utf8') as fh:
        for raw in fh:
            s=raw.strip()
            if not s: continue
            require(valid_window(s,ell), f'bad perwin line {s[:80]!r}')
            per.append(s)
    require(len(per)==len(set(per)), 'duplicate perwin window')
    j1={'R'+'B'*(2*ell-1)}
    j1.update('R'*(pos-1)+'B'+'R'*(2*ell-pos) for pos in range(2,2*ell+1))
    require(len(j1)==2*ell,'internal J1 count error')
    expected_per = red | (j1 if e<=2 else set())
    require(set(per)==expected_per,
            f'perwin incomplete/extra: missing={len(expected_per-set(per))} extra={len(set(per)-expected_per)}')
    require(len(per)==expected, f'window count {len(per)} != {expected}')

    actual_proofs={p.name for p in proofs.iterdir() if p.is_file()}
    expected_proofs={w+'_'+str(e)+'.lrat.xz' for w in per}
    require(actual_proofs==expected_proofs,
            f'proof filenames mismatch: missing={len(expected_proofs-actual_proofs)} extra={len(actual_proofs-expected_proofs)}')
    return edge_path,proofs,set(per)

def hyperedges(data,ell,e,n):
    """Parse and validate all solutions, preserving their exact order."""
    require(data.strip(), 'empty edge list')
    clauses=[]
    for idx, item in enumerate(data.split(';'),1):
        item=item.strip()
        require(item, f'empty hyperedge #{idx}')
        pieces=item.split('|')
        require(len(pieces)==2, f'hyperedge #{idx} missing/multiple |')
        toks=pieces[0].split()
        require(len(toks)==ell, f'hyperedge #{idx} distinct term count != ell')
        try:
            target=int(pieces[1].strip())
        except ValueError: raise Bad(f'hyperedge #{idx} bad output')
        require(1<=target<=n, f'hyperedge #{idx} out-of-range output')
        vals=[]; total=0; count=0
        for tok in toks:
            chunks=tok.split(':')
            require(len(chunks)==2, f'hyperedge #{idx} bad token {tok}')
            try:
                mult=int(chunks[0]); v=int(chunks[1])
            except ValueError: raise Bad(f'hyperedge #{idx} noninteger term')
            require(mult>=1 and 1<=v<=n, f'hyperedge #{idx} bad term bounds')
            count += mult
            total += mult*v
            vals.append(v)
        require(len(set(vals))==ell, f'hyperedge #{idx} repeated distinct value')
        require(count==ell+e, f'hyperedge #{idx} k summands mismatch')
        require(total==target, f'hyperedge #{idx} sum mismatch')
        require(target not in vals, f'hyperedge #{idx} output occurs as summand')
        s=tuple(sorted(vals+[target]))
        clauses.append(tuple(-v for v in s))
        clauses.append(s)
    return clauses

def rup(clause,hints,live,n):
    assign={}
    for lit in clause:
        require(1<=abs(lit)<=n, f'added literal {lit} out of range')
        var=abs(lit); val = -1 if lit>0 else 1
        prev=assign.get(var)
        require(prev is None or prev==val, 'inconsistent negated clause')
        assign[var]=val
    require(len(hints)>0, 'addition with no RUP hints')
    conflicted=False
    for hint in hints:
        if conflicted:
            continue  # Specification: hints after the first conflict are ignored.
        require(hint>0,'RAT/negative/zero hint unsupported')
        require(hint in live, f'hint {hint} is not live')
        values=[]; unit=None; unassigned=0; satisfied=False
        for lit in live[hint]:
            v=assign.get(abs(lit))
            if v is None:
                unassigned+=1; unit=lit
            elif (v==1 and lit>0) or (v==-1 and lit<0):
                satisfied=True
                break
        require(not satisfied,f'satisfied RUP hint {hint}')
        if unassigned==0:
            conflicted=True
        elif unassigned==1:
            assert unit is not None
            assign[abs(unit)]=1 if unit>0 else -1
        else:
            raise Bad(f'hint {hint} not unit/conflict ({unassigned} unassigned)')
    require(conflicted,'RUP hints ended without contradiction')

def verify_lrat(path,n,base):
    live={i+1:tuple(c) for i,c in enumerate(base)}
    last=len(base)
    empty=False
    rows=0
    with lzma.open(path,'rt',encoding='ascii') as f:
        for raw in f:
            rows+=1
            data=raw.split()
            require(data, f'LRAT empty line {rows}')
            try: idx=int(data[0])
            except ValueError: raise Bad(f'LRAT line {rows}: bad clause id')
            require(idx>0, f'LRAT line {rows}: id <=0')
            if len(data)>1 and data[1]=='d':
                require(idx<=last, f'LRAT line {rows}: deletion anchor beyond current id')
                require(len(data)>=4 and data[-1]=='0',
                        f'LRAT line {rows}: bad deletion format')
                try: dels=[int(x) for x in data[2:-1]]
                except ValueError: raise Bad(f'LRAT line {rows}: bad deletion id')
                for d in dels:
                    require(d>0 and d in live,
                            f'LRAT line {rows}: deletion of nonlive clause {d}')
                    del live[d]
                continue
            require(idx>last, f'LRAT line {rows}: addition id not increasing')
            try: nums=[int(x) for x in data[1:]]
            except ValueError: raise Bad(f'LRAT line {rows}: noninteger addition token')
            require(nums.count(0)==2 and nums[-1]==0,
                    f'LRAT line {rows}: expected two 0 delimiters')
            end=nums.index(0)
            cl=tuple(nums[:end]); hints=nums[end+1:-1]
            for lit in cl:
                require(1<=abs(lit)<=n, f'LRAT line {rows}: bad literal {lit}')
            try:
                rup(cl,hints,live,n)
            except Bad as ex:
                raise Bad(f'LRAT line {rows}: {ex}') from ex
            live[idx]=cl
            last=idx
            if not cl:
                empty=True
    require(empty, 'no empty clause added')
    return rows

def worker(job):
    w,edge_line,path,ell,e,n=job
    try:
        edges=hyperedges(edge_line,ell,e,n)
        base=[(i,) if col=='R' else (-i,) for i,col in enumerate(w,1)]
        base.extend(edges)
        rows=verify_lrat(path,n,base)
        return (w,True,f'{len(edges)//2} edges, {rows} LRAT lines')
    except (Bad, OSError, EOFError, lzma.LZMAError, UnicodeError, ValueError,
            MemoryError) as ex:
        return (w,False,f'{type(ex).__name__}: {ex}')

def examine_group(root,g,jobs=1,quiet=False):
    directory,ell,e,n,expected=g
    prefix=f'GROUP {directory} l={ell} e={e} N={n}'
    try:
        edge_path,proofs,per=read_catalog(root,g)
    except (Bad,OSError,ValueError) as ex:
        if not quiet:
            print(f'FAIL {directory} e={e} CATALOG: {ex}',flush=True)
            print(f'{prefix} windows={expected} pass=0 fail=1',flush=True)
        return (0,1)
    seen=set(); passed=0; failed=0
    def handle(result):
        nonlocal passed,failed
        w,ok,msg=result
        if ok: passed+=1
        else:
            failed+=1
            if not quiet: print(f'FAIL {directory} e={e} window={w}: {msg}',flush=True)
    try:
        with cf.ProcessPoolExecutor(max_workers=jobs) as pool:
            inflight=[]
            with lzma.open(edge_path,'rt',encoding='utf8') as f:
                for lineno,line in enumerate(f,1):
                    require('\t' in line, f'edges line {lineno}: no TAB')
                    key,data=line.rstrip('\n\r').split('\t',1)
                    suffix='_'+str(e)
                    require(key.endswith(suffix),f'edges line {lineno}: bad key suffix')
                    w=key[:-len(suffix)]
                    require(w in per,f'edges line {lineno}: unknown key {key[:100]}')
                    require(w not in seen,f'edges line {lineno}: duplicate key')
                    seen.add(w)
                    path=proofs/(key+'.lrat.xz')
                    inflight.append(pool.submit(worker,(w,data,path,ell,e,n)))
                    if len(inflight)>=max(2,2*jobs):
                        handle(inflight.pop(0).result())
            require(seen==per,f'edges key set incomplete: {len(per-seen)} missing')
            for future in inflight:
                handle(future.result())
    except (Bad,OSError,EOFError,lzma.LZMAError,UnicodeError,ValueError) as ex:
        failed+=1
        if not quiet: print(f'FAIL {directory} e={e} EDGES/CATALOG: {ex}',flush=True)
    except Exception as ex:
        failed+=1
        if not quiet: print(f'FAIL {directory} e={e} WORKER: {ex}',flush=True)
    if not quiet:
        print(f'{prefix} windows={expected} pass={passed} fail={failed}',flush=True)
    require(not (passed==expected and failed>0), 'internal counting error')
    return passed,failed

def atomic_bytes(path,data):
    tmp=path.with_name(path.name+'.mutating')
    tmp.write_bytes(data)
    os.replace(tmp,path)

def atomic_text_xz(path,s):
    atomic_bytes(path,lzma.compress(s.encode('utf8')))

def selftest(root):
    src=root/'l12'; group=GROUPS[0]
    require(src.is_dir(),'--selftest needs l12 directory')
    with tempfile.TemporaryDirectory(prefix='rsn_r9_') as tmp:
        pristine=Path(tmp)/'pristine'; pristine.mkdir()
        d=pristine/'l12'; d.mkdir(); (d/'proofs_e1').mkdir()
        for name in ['red_l12_e1.txt','perwin_l12_e1.txt','edges_l12_e1.txt.xz']:
            shutil.copy2(src/name,d/name)
        for p in (src/'proofs_e1').iterdir():
            if p.is_file(): shutil.copy2(p,d/'proofs_e1'/p.name)
        p,f=examine_group(pristine,group,2,quiet=True)
        require((p,f)==(90,0), f'selftest pristine did not pass: {p}/{f}')
        print('SELFTEST pristine PASS (90/90)',flush=True)
        base_proofs=sorted((d/'proofs_e1').glob('*.lrat.xz'))
        require(len(base_proofs)>=2,'need two distinct proofs')
        def altered(case,idx):
            dest=Path(tmp)/f'{case}_{idx}'
            shutil.copytree(pristine,dest,copy_function=os.link)
            return dest, dest/'l12'
        tests=[]
        def trunc(t):
            a=sorted((t/'proofs_e1').glob('*.lrat.xz'))[0]
            atomic_bytes(a,a.read_bytes()[:max(1,a.stat().st_size//2)])
        tests.append(('truncated proof',trunc))
        def bad_hint(t):
            for p in sorted((t/'proofs_e1').glob('*.lrat.xz')):
                raw=lzma.open(p,'rt').read().splitlines()
                for ix,line in enumerate(raw):
                    parts=line.split()
                    if len(parts)>4 and parts[1]!='d' and parts.count('0')==2:
                        end=parts.index('0')
                        if end+1<len(parts)-1:
                            parts[end+1]='999999999'
                            raw[ix]=' '.join(parts)
                            atomic_text_xz(p,'\n'.join(raw)+'\n')
                            return
            raise Bad('selftest could not find a positive hint')
        tests.append(('one hint id changed',bad_hint))
        def wrong_window_proof(t):
            path=t/'edges_l12_e1.txt.xz'
            with lzma.open(path,'rt') as f:
                lines=dict((key[:-2],data) for key,data in
                           (raw.rstrip('\n\r').split('\t',1) for raw in f))
            files=sorted((t/'proofs_e1').glob('*.lrat.xz'))
            target=files[0]
            w=target.name.removesuffix('_1.lrat.xz')
            require(w in lines,'selftest target not in edges')
            for source in reversed(files[1:]):
                ok=worker((w,lines[w],source,12,1,1160))[1]
                if not ok:
                    atomic_bytes(target,source.read_bytes())
                    return
            raise Bad('no provably invalid swapped proof found')
        tests.append(('proof from another window (pretested invalid)',wrong_window_proof))
        def bad_sum(t):
            path=t/'edges_l12_e1.txt.xz'
            lines=lzma.open(path,'rt').read().splitlines()
            key,edges=lines[0].split('\t',1)
            terms=edges.split(';')
            a,b=terms[0].rsplit('|',1)
            terms[0]=a+'| '+str(int(b.strip())+1)
            lines[0]=key+'\t'+';'.join(terms)
            atomic_text_xz(path,'\n'.join(lines)+'\n')
        tests.append(('hyperedge sum +1',bad_sum))
        def delete_edge(t):
            path=t/'edges_l12_e1.txt.xz'
            lines=lzma.open(path,'rt').read().splitlines()
            for ln,raw in enumerate(lines):
                key,edges=raw.split('\t',1)
                terms=edges.split(';')
                if len(terms)<2:
                    continue
                w=key[:-2]
                proof=t/'proofs_e1'/(key+'.lrat.xz')
                last_base=24+2*len(terms)
                used=set()
                with lzma.open(proof,'rt') as f:
                    for proofline in f:
                        fields=proofline.split()
                        if len(fields)<3 or fields[1]=='d':
                            continue
                        try:
                            start=fields.index('0')+1
                            stop=fields.index('0',start)
                            for h in fields[start:stop]:
                                ident=int(h)
                                if 24<ident<=last_base:
                                    used.add((ident-25)//2)
                        except (ValueError,IndexError):
                            continue
                        if used:
                            break
                for which in sorted(used):
                    changed=';'.join(terms[:which]+terms[which+1:])
                    # Test this actual proof before selecting the mutation:
                    # a redundant edge must not produce a false negative control.
                    if not worker((w,changed,proof,12,1,1160))[1]:
                        lines[ln]=key+'\t'+changed
                        atomic_text_xz(path,'\n'.join(lines)+'\n')
                        return
            raise Bad('no proof-used edge whose removal is detected')
        tests.append(('proof-used hyperedge removed (pretested invalid)',delete_edge))
        def bad_done(t):
            p=t/'red_l12_e1.txt';s=p.read_text()
            require('N=1160' in s,'DONE N not found')
            atomic_bytes(p,s.replace('N=1160','N=1161',1).encode())
        tests.append(('DONE N changed',bad_done))
        def missing_per(t):
            p=t/'perwin_l12_e1.txt'; lines=p.read_text().splitlines()
            atomic_bytes(p,('\n'.join(lines[1:])+'\n').encode())
        tests.append(('perwin line removed',missing_per))
        def extra_proof(t):
            atomic_bytes(t/'proofs_e1'/'bogus_1.lrat.xz',lzma.compress(b''))
        tests.append(('extra proof file',extra_proof))
        def bad_key(t):
            p=t/'edges_l12_e1.txt.xz'; lines=lzma.open(p,'rt').read().splitlines()
            key,edges=lines[0].split('\t',1)
            lines[0]='B'+key[1:]+'\t'+edges
            atomic_text_xz(p,'\n'.join(lines)+'\n')
        tests.append(('edge key flipped',bad_key))
        for i,(name,mutate) in enumerate(tests):
            dest,t=altered('test',i)
            try:
                mutate(t)
                passed,failed=examine_group(dest,group,2,quiet=True)
                require(failed>0 or passed!=90,'mutation escaped detection')
                print(f'SELFTEST tamper {i+1}/9 REJECTED: {name}',flush=True)
            finally:
                shutil.rmtree(dest)
    print('SELFTEST PASS: pristine accepted; all 9 mutations rejected',flush=True)

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('root',type=Path)
    ap.add_argument('--jobs',type=int,default=os.cpu_count() or 1)
    ap.add_argument('--group',action='append',default=[],metavar='DIR:l:e:N')
    ap.add_argument('--selftest',action='store_true')
    arg=ap.parse_args()
    if arg.jobs<1: ap.error('--jobs must be >=1')
    try:
        if arg.selftest:
            selftest(arg.root)
            return 0
        selected=[]
        for raw in arg.group:
            require(len(raw.split(':'))==4, 'expected DIR:l:e:N')
            parts=raw.split(':')
            key=(parts[0],int(parts[1]),int(parts[2]),int(parts[3]))
            options=[g for g in GROUPS if g[:4]==key]
            require(len(options)==1, f'unknown group {raw}')
            require(options[0] not in selected, f'duplicate group {raw}')
            selected.append(options[0])
        if not selected: selected=list(GROUPS)
        total_pass=total_fail=0
        for g in selected:
            passed,failed=examine_group(arg.root,g,arg.jobs)
            total_pass+=passed;total_fail+=failed
        print(f'TOTAL pass={total_pass} fail={total_fail}',flush=True)
        return 0 if total_fail==0 and total_pass==sum(g[4] for g in selected) else 1
    except (Bad,OSError,ValueError) as ex:
        print(f'FATAL: {ex}',file=sys.stderr)
        return 1

if __name__=='__main__':
    sys.exit(main())
