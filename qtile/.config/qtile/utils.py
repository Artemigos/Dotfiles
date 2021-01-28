import os

def dbg_log_clear():
    with open(os.path.expanduser('~/qtile_dbg.log'), 'w+'):
        pass

def dbg_log(msg):
    with open(os.path.expanduser('~/qtile_dbg.log'), 'a') as f:
        f.write(msg)
        f.write('\n')

