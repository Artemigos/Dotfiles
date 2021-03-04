import subprocess
from libqtile import hook
from libqtile.window import Window

from utils import run_cmd

def apply_rules(win: Window, wid: int, wm_class: str, proc_name: str):
    if wm_class.startswith('Gimp'):
        win.floating = True
        win.togroup('IV')
    elif wm_class == 'spotify' or proc_name == 'spotify':
        win.togroup('music')

@hook.subscribe.client_new
def rules(win: Window):
    wid = win.window.wid
    classes = win.window.get_wm_class()

    if len(classes) == 0:
        proc_name = ''
        proc_id = run_cmd(['xdo', 'pid', str(wid)])
        if proc_id:
            proc_name = run_cmd(['ps', '-p', proc_id, '-o', 'comm=']) or ''
        apply_rules(win, wid, '', proc_name)
    else:
        for c in classes:
            apply_rules(win, wid, c, '')

