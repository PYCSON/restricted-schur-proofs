#!/usr/bin/env python3
"""Adaptive cube driver for symeng_v13 (restartable, with in-cube checkpoints).
Each cube runs with CKPT_DEPTH (env, default 9) and CKPT_FILE=work/<prefix>/ckpt.txt, so a killed cube resumes
without redoing closed subtrees; a finished cube's edges = ckpt edges + final edges.
State lives in DIR: pending cubes are files DIR/q/<prefix>; finished cubes write DIR/done/<prefix>.edges and
DIR/done/<prefix>.log; a cube that hits the per-cube time limit is split into <prefix>0 and <prefix>1.
A cube whose search ends with "no proof" (depth limit) is recorded in DIR/fail/.
usage: cubedrive.py DIR WORKERS PER_CUBE_SEC DEADLINE_SEC -- engine args (l k0 maxdepth MNC MAXNODES MAXSL FEXTRA CAP)"""
import os, sys, time, subprocess
DIR, W, PER, DEAD = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
eng = sys.argv[sys.argv.index('--') + 1:]
ENGINE = os.environ.get('ENGINE', '/home/claude/explore/oq64/symeng_v16')
CKD = os.environ.get('CKPT_DEPTH', '9')
for d in ('q', 'done', 'fail', 'run'): os.makedirs(f'{DIR}/{d}', exist_ok=True)
t0 = time.time()
def log(s):
    with open(f'{DIR}/driver.log', 'a') as f: f.write(time.strftime('%H:%M:%S ') + s + '\n')
# cubes that were running when a previous driver was killed go back to the queue
for p in os.listdir(f'{DIR}/run'):
    os.rename(f'{DIR}/run/{p}', f'{DIR}/q/{p}'); log(f'requeue {p}')
running = {}
while True:
    for p, (proc, ts, wd) in list(running.items()):
        rc = proc.poll()
        if rc is None: continue
        del running[p]; os.remove(f'{DIR}/run/{p}')
        out = open(f'{wd}/out.txt').read()
        if 'PROOF FOUND' in out:
            with open(f'{DIR}/done/{p}.edges', 'w') as g:
                if os.path.exists(f'{wd}/ckpt.txt'):
                    for line in open(f'{wd}/ckpt.txt'):
                        if not line.startswith('#'): g.write(line)
                g.write(open(f'{wd}/edges.txt').read())
            open(f'{DIR}/done/{p}.log', 'w').write(out)
            log(f'done {p}: {out.strip()}')
        elif rc == 124:
            for b in '01': open(f'{DIR}/q/{p}{b}', 'w').close()
            log(f'timeout {p} after {time.time()-ts:.0f}s -> split')
        else:
            open(f'{DIR}/fail/{p}', 'w').write(f'rc={rc}\n{out}')
            log(f'FAIL {p} rc={rc}: {out.strip()}')
    pend = sorted(os.listdir(f'{DIR}/q'), key=lambda s: (len(s), s))
    if not pend and not running:
        log('ALL CUBES FINISHED'); print('ALL CUBES FINISHED', flush=True); break
    if time.time() - t0 > DEAD:
        log('deadline reached; stopping workers')
        for p, (proc, ts, wd) in running.items(): proc.terminate()
        print('DEADLINE', flush=True); break
    while pend and len(running) < W:
        p = pend.pop(0); os.rename(f'{DIR}/q/{p}', f'{DIR}/run/{p}')
        wd = f'{DIR}/work/{p}'; os.makedirs(wd, exist_ok=True)
        env = dict(os.environ, PREFIX=p, CKPT_DEPTH=CKD, CKPT_FILE=os.path.abspath(f'{wd}/ckpt.txt'))
        cmd = ['timeout', str(PER), ENGINE, eng[0], eng[1], eng[2], 'edges.txt'] + eng[3:]
        proc = subprocess.Popen(cmd, cwd=wd, env=env, stdout=open(f'{wd}/out.txt', 'w'), stderr=open(f'{wd}/err.txt', 'a'))
        running[p] = (proc, time.time(), wd); log(f'start {p}')
    time.sleep(5)
