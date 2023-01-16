import os
import subprocess

def dbg_log_clear():
    with open(os.path.expanduser('~/qtile_dbg.log'), 'w+'):
        pass

def dbg_log(msg):
    with open(os.path.expanduser('~/qtile_dbg.log'), 'a') as f:
        f.write(msg)
        f.write('\n')

def run_cmd(cmd, timeout=5) -> str | None:
    try:
        prc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, timeout=timeout)
    except TimeoutError:
        return None
    if prc.returncode != 0:
        return None
    return str(prc.stdout, encoding='utf8').strip()

