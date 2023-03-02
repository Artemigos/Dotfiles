from collections import deque
import os
import subprocess
from typing import List  # noqa: F401

from libqtile import layout, hook
from libqtile.backend.x11.window import Window
from libqtile.config import Click, Drag, Group, EzKey as Key, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from custom_bsp import CustomBsp
from utils import run_cmd
from widgets import screens, widget_defaults, extension_defaults
from window_rules import apply_rules

mod = 'mod4'

# defaults
home = os.environ['HOME']
terminal = os.environ['TERMINAL'] or guess_terminal()
browser = os.environ['BROWSER']
alt_browser = os.environ['ALT_BROWSER']
editor = os.environ['EDITOR']
alt_editor = os.environ['ALT_EDITOR']
player = 'spotify'
alt_player = f'{browser} https://www.youtube.com/'
explorer = f'{terminal} -e ranger'
alt_explorer = f'pcmanfm {home}'
todo = f'{terminal} -e nvim {home}/todo.txt'

@hook.subscribe.startup_once
def autostart():
    subprocess.call(['d', 'autostart'])

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

@lazy.function
def tickle_window(qtile):
    pid = qtile.current_window.get_pid()
    run_cmd(['kill', '-SIGWINCH', str(pid)])
    children_pids = run_cmd(['bash', '-c', f'cat /proc/{pid}/task/*/children'])
    for child_pid in children_pids.splitlines():
        run_cmd(['kill', '-SIGWINCH', child_pid])

def k(key_spec: str, cmd, desc: str) -> Key:
    if isinstance(cmd, str):
        cmd = lazy.spawn(cmd)
    return Key(key_spec, cmd, desc=desc)

@lazy.function
def emulate_hotkey(qtile, hotkey: str):
    keys = hotkey.split('+')
    if len(keys) > 1:
        commands = deque()
        for key in reversed(keys):
            commands.appendleft('keydown ' + key)
            commands.append('keyup ' + key)
        commands.appendleft('xte')
        run_cmd(commands)
    else:
        run_cmd(['xte', 'key ' + keys[0]])

keys = [
    # Switch between windows
    k('M-j', lazy.layout.down(), 'Move focus down'),
    k('M-k', lazy.layout.up(), 'Move focus up'),
    k('M-h', lazy.layout.left(), 'Move focus left'),
    k('M-l', lazy.layout.right(), 'Move focus right'),
    k('M-c', lazy.layout.next(), 'Move focus to the next window'),
    k('M-<Tab>', lazy.next_screen(), 'Move focus to the next screen'),

    # Move windows
    k('M-S-j', lazy.layout.shuffle_down(), 'Swap window down'),
    k('M-S-k', lazy.layout.shuffle_up(), 'Swap window up'),
    k('M-S-h', lazy.layout.shuffle_left(), 'Swap window left'),
    k('M-S-l', lazy.layout.shuffle_right(), 'Swap window right'),

    # Transplant windows
    k('M-C-j', lazy.layout.transplant_down(), 'Transplant window down'),
    k('M-C-k', lazy.layout.transplant_up(), 'Transplant window up'),
    k('M-C-h', lazy.layout.transplant_left(), 'Transplant window left'),
    k('M-C-l', lazy.layout.transplant_right(), 'Transplant window right'),

    # Groups
    k('M-<Left>', lazy.screen.prev_group(), 'Switch to the previous group'),
    k('M-<Right>', lazy.screen.next_group(), 'Switch to the next group'),

    # Layout stuff
    k('M-m', lazy.next_layout(), 'Switch between BSP an Max'),
    k('M-<semicolon>', lazy.layout.toggle_split(), 'Rotate split'),
    k('M-S-b', lazy.layout.flip(), 'Swap window with sibling'),
    k('M-f', lazy.window.toggle_floating(), 'Toggle window float'),

    k('M-w', lazy.window.kill(), 'Kill focused window'),
    k('M-A-r', lazy.restart(), 'Restart qtile'),
    k('M-A-q', lazy.shutdown(), 'Shutdown qtile'),
    k('M-r', lazy.spawncmd(), 'Spawn a command using a prompt widget'),

    # Programs
    k('M-<Return>', terminal, 'Launch terminal'),
    k('M-C-<Return>', f'{terminal} -e {editor}', 'Run terminal editor'),
    k('M-A-<Return>', 'd project open', 'Edit a git project'),
    k('M-S-<Return>', alt_editor, 'Run GUI editor'),
    k('M-<F1>', browser, 'Launch browser'),
    k('M-S-<F1>', alt_browser, 'Launch alternative browser'),
    k('M-<F2>', player, 'Launch music player'),
    k('M-S-<F2>', alt_player, 'Launch alternative music player'),
    k('M-<F3>', explorer, 'Launch file explorer'),
    k('M-S-<F3>', alt_explorer, 'Launch alternative file explorer'),

    # Launchers
    k('M-<space>', 'd menu command', 'Run a command'),
    k('M-S-<space>', 'd menu app', 'Run an app'),
    k('M-A-<space>', 'd dotfiles select', 'Select and edit a dotfile'),
    k('M-C-<space>', 'd menu window', 'Select a window'),

    # Menus
    k('M-<slash>', 'd system show', 'Show system menu'),
    k('M-<BackSpace>', 'd power show', 'Show power management menu'),

    # Audio controls
    k('<XF86AudioPrev>', 'sp prev', 'Previous song'),
    k('<XF86AudioNext>', 'sp next', 'Next song'),
    k('<XF86AudioPlay>', 'sp play', 'Play/pause'),
    k('<XF86AudioStop>', 'sp pause', 'Stop music'),
    k('<XF86AudioLowerVolume>', 'd audio decrease-volume', 'Increase volume'),
    k('<XF86AudioRaiseVolume>', 'd audio increase-volume', 'Decrease volume'),

    # Utilities
    k('<Print>', 'd tools screenshot', 'Take a screenshot'),
    k(
        'M-<grave>',
        lazy.group['scratchpad'].dropdown_toggle('term'),
        'Show terminal dropdown'),
    k('M-S-<BackSpace>', 'd power lock', 'Lock the session'),
    k('M-b', 'bwmenu', 'Run Bitwarden menu'),
    k('M-d', 'd tools man-pdf', 'Select a manpage and show it as PDF.'),
    k('M-A-t', tickle_window, 'Tickles a window to help resize things.'),

    # Mouse
    k('M-z', 'xdotool click 1', 'Emulates left mouse click'),
    k('M-x', 'xdotool click 2', 'Emulates right mouse click'),
]

group_definitions = {
    'main': ('1', '爵'),
    'code': ('2', ''),
    'communication': ('3', ''),
    'IV': ('4', ''),
    'music': ('5', ''),
}
scratchpad = ScratchPad('scratchpad', [
    DropDown('term', todo, width=0.9, height=0.6, x=0.05, warp_pointer=False),
])
groups = [Group(k, label=v[1]) for k, v in group_definitions.items()]

for i in groups:
    group_key = group_definitions[i.name][0]
    keys.extend([
        k(f'M-{group_key}', lazy.group[i.name].toscreen(), f'Switch to group {i.name}'),
        k(
            f'M-S-{group_key}',
            lazy.window.togroup(i.name),
            f'Move focused window to group {i.name}'),
    ])

groups = [scratchpad] + groups

layouts = [
    CustomBsp(
        border_focus='#bd93f9',
        border_width=2,
        border_on_single=True,
        margin=6,
        fair=False,
        wrap_clients=True),
    layout.Max(),
]

mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
    Click([], 'Button9', emulate_hotkey('XF86AudioPlay')),
    Click([], 'Button8', emulate_hotkey('XF86AudioNext')),
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
])
auto_fullscreen = True
focus_on_window_activation = 'smart'
wmname = 'LG3D'

__all__ = [
    'screens',
    'widget_defaults',
    'extension_defaults',
    'keys',
    'groups',
    'layouts',
    'mouse',
    'dgroups_key_binder',
    'dgroups_app_rules',
    'main',
    'follow_mouse_focus',
    'bring_front_click',
    'cursor_warp',
    'floating_layout',
    'auto_fullscreen',
    'focus_on_window_activation',
    'wmname',
]
