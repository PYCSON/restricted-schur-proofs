#!/usr/bin/env python3
"""Combine the segment outputs of `t1multi l elo ehi mcol jlo jhi low tag` into red_l<l>_e<e>.txt.
The segments must be listed in enumeration order (mcol=1 before mcol=0, increasing jp, the low cases of a
colour after its jp range) and must cover every (mcol, jp) and both low-case blocks exactly once.
usage: t1combine.py l e tag1 tag2 ...    (writes red_l<l>_e<e>.txt; refuses to overwrite)"""
import sys, os, re
l, e = int(sys.argv[1]), int(sys.argv[2]); tags = sys.argv[3:]
out = f'red_l{l}_e{e}.txt'
if os.path.exists(out): raise SystemExit(f'{out} exists')
seq = []; surv = []; tot = dict(reducedWindows=0, reducedNotRefuted=0, windowsCheckedIndividually=0, survivors=0, lowCases=0); N = None
for t in tags:
    lines = open(f'red_l{l}_e{e}.{t}.part').read().splitlines()
    assert lines and lines[-1].startswith('PART '), (t, 'incomplete')
    p = dict(x.split('=') for x in lines[-1].split()[1:])
    assert int(p['l']) == l and int(p['e']) == e
    N = p['N'] if N is None else N; assert p['N'] == N
    mc = int(p['mcol']); seq += [(mc, j) for j in range(int(p['jlo']), int(p['jhi']) + 1)] + ([(mc, 'low')] if p['low'] == '1' else [])
    body = lines[:-1]; assert all(x.startswith('SURV ') for x in body)
    assert len(body) == int(p['survivors'])
    surv += body
    for k in tot: tot[k] += int(p[k])
want = [(1, j) for j in range(2, l - 1)] + [(1, 'low')] + [(0, j) for j in range(2, l - 1)] + [(0, 'low')]
assert seq == want, ('segments do not cover the enumeration in order', seq)
with open(out, 'w') as g:
    for x in surv: g.write(x + '\n')
    g.write(f"DONE l={l} e={e} N={N} reducedWindows={tot['reducedWindows']} reducedNotRefuted={tot['reducedNotRefuted']} "
            f"windowsCheckedIndividually={tot['windowsCheckedIndividually']} survivors={tot['survivors']} lowCases={tot['lowCases']}\n")
print('wrote', out, tot)
