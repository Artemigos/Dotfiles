from libqtile.backend.x11.window import Window

def apply_rules(win: Window, wid: int, wm_class: str, proc_name: str):
    if wm_class.startswith('Gimp'):
        win.floating = True
        win.togroup('IV')
    elif wm_class == 'spotify' or proc_name == 'spotify':
        win.togroup('music')
