"""Claude's extra tamper tests of GPT's unmodified gpt_r9_check.py (worker function) on the largest proof."""
import sys, lzma, time
sys.path.insert(0, sys.argv[1])
import gpt_r9_check as g
X = sys.argv[2] + '/S2_21_20'
w = 'RRRR' + 'B'*36; key = w + '_1'
for line in lzma.open(X + '/edges_l20_e1.txt.xz', 'rt'):
    k, data = line.rstrip('\n').split('\t', 1)
    if k == key: break
proof = f'{X}/proofs_e1/{key}.lrat.xz'
t = time.time(); r = g.worker((w, data, proof, 20, 1, 4861)); print('pristine', 'ACCEPTED' if r[1] else 'rejected', '|', r[2], f'| {time.time()-t:.1f}s')
lines = lzma.open(proof, 'rt').read().splitlines()
adds = [i for i, x in enumerate(lines) if x.split()[1] != 'd']; mid = adds[len(adds)//2]
def test(name, newlines):
    p = f'mut_{name}.lrat.xz'
    with lzma.open(p, 'wt') as f: f.write('\n'.join(newlines) + '\n')
    r = g.worker((w, data, p, 20, 1, 4861)); print(name, 'ACCEPTED' if r[1] else 'rejected', '|', r[2][:110])
t1 = lines[:]; p = t1[mid].split(); z = p.index('0'); h = int(p[z+1]); p[z+1] = str(h - 1 if h > 1 else 2); t1[mid] = ' '.join(p); test('middle_hint_changed', t1)
test('empty_clause_line_dropped', lines[:-1])
t3 = lines[:]; p = t3[mid].split(); t3[mid] = ' '.join(p[:1] + p[2:]); test('middle_clause_literal_dropped', t3)
t4 = lines[:]; p = t4[mid].split(); z = p.index('0'); t4[mid] = ' '.join(p[:z+1] + p[z+2:]); test('middle_first_hint_removed', t4)
r = g.worker((w, ';'.join(data.split(';')[:-1]), proof, 20, 1, 4861)); print('last_hyperedge_removed', 'ACCEPTED' if r[1] else 'rejected', '|', r[2][:110])
r = g.worker((w, data, proof, 20, 1, 4860)); print('N_4860', 'ACCEPTED' if r[1] else 'rejected', '|', r[2][:110])
r = g.worker(('RRRB' + 'B'*36, data, proof, 20, 1, 4861)); print('window_RRRB_with_RRRR_proof', 'ACCEPTED' if r[1] else 'rejected', '|', r[2][:110])
print('proof lines', len(lines), 'additions', len(adds))
