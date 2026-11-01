#!/usr/bin/env python3
"""Independent checks that our LRAT replay does NOT accept invalid proofs. No originals modified."""
import io, json, lzma
from pathlib import Path
from independent_lrat import clauses_from_json,rup_proof
ROOT=Path(__file__).resolve().parent
F=ROOT/'core/evidence/oq64_l11/k13_cubes/full_t19/certs'
L=ROOT/'lrat';p='000000';b=f'certC{p}_11_13'
with lzma.open(F/f'{b}.json.xz','rt') as x:j=json.load(x)
n,clauses=clauses_from_json(j)
with lzma.open(L/f'{b}.lrat.xz','rb') as f:raw=f.readlines()
assert rup_proof(n,clauses,raw)['empty']
print('PASS valid proof')

def must_reject(name,seq,cnf=None):
 try:rup_proof(n,clauses if cnf is None else cnf,seq)
 except (AssertionError,KeyError,ValueError,IndexError) as e:
  print('PASS rejected',name,repr(e)[:130]);return
 raise SystemExit('FAIL false acceptance '+name)

# Delete terminal empty clause and verify no proof is accepted.
must_reject('missing_empty_clause',raw[:-1])
# Replace first antecedent by a clause ID outside the initially known database.
bits=raw[0].split();idx=bits.index(b'0')+1;bits[idx]=b'999999999';mut=raw[:];mut[0]=b' '.join(bits)+b'\n'
must_reject('false_antecedent_ID',mut)
# Break all proof with an incompatible color unit clause, without changing original files.
changed=clauses[:];changed[0]=(-changed[0][0],)
must_reject('flipped_red_unit',raw,changed)
