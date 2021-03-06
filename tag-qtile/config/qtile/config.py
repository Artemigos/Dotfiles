import os
import subprocess
from typing import List  # noqa: F401

from libqtile import layout, hook
from libqtile.config import Click, Drag, Group, EzKey as Key, ScratchPad, DropDown, Match
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from custom_bsp import CustomBsp
import utils
from widgets import screens, widget_defaults, extension_defaults
import window_rules

mod = "mod4"

# defaults
home = os.environ['HOME']
terminal = guess_terminal()
browser = os.environ['BROWSER']
alt_browser = os.environ['ALT_BROWSER']
editor = os.environ['EDITOR']
alt_editor = os.environ['ALT_EDITOR']
player = 'spotify'
alt_player = f'{browser} https://www.youtube.com/'
explorer = f'{terminal} -e ranger'
alt_explorer = f'pcmanfm {home}'

@hook.subscribe.startup_once
def autostart():
    subprocess.call(['autostart.sh'])
    subprocess.Popen(['light-locker', '--lock-after-screensaver=0', '--lock-on-suspend'])

keys = [
    # Switch between windows
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-h", lazy.layout.left(), desc="Move focus left"),
    Key("M-l", lazy.layout.right(), desc="Move focus right"),
    Key("M-c", lazy.layout.next(), desc="Move focus to the next window"),

    # Move windows
    Key("M-S-j", lazy.layout.shuffle_down(), desc="Swap window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Swap window up"),
    Key("M-S-h", lazy.layout.shuffle_left(), desc="Swap window left"),
    Key("M-S-l", lazy.layout.shuffle_right(), desc="Swap window right"),

    # Transplant windows
    Key("M-C-j", lazy.layout.transplant_down(), desc="Transplant window down"),
    Key("M-C-k", lazy.layout.transplant_up(), desc="Transplant window up"),
    Key("M-C-h", lazy.layout.transplant_left(), desc="Transplant window left"),
    Key("M-C-l", lazy.layout.transplant_right(), desc="Transplant window right"),

    # Layout stuff
    Key("M-m", lazy.next_layout(), desc="Switch between BSP an Max"),
    Key("M-<semicolon>", lazy.layout.toggle_split(), desc="Rotate split"),
    Key("M-S-b", lazy.layout.flip(), desc="Swap window with sibling"),
    Key("M-f", lazy.window.toggle_floating(), desc="Toggle window float"),

    Key("M-w", lazy.window.kill(), desc="Kill focused window"),
    Key("M-A-r", lazy.restart(), desc="Restart qtile"),
    Key("M-A-q", lazy.shutdown(), desc="Shutdown qtile"),
    Key("M-r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Programs
    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),
    Key("M-C-<Return>", lazy.spawn(f'{terminal} -e {editor}'), desc='Run terminal editor'),
    Key("M-S-<Return>", lazy.spawn(alt_editor), desc='Run GUI editor'),
    Key("M-<F1>", lazy.spawn(browser), desc="Launch browser"),
    Key("M-S-<F1>", lazy.spawn(alt_browser), desc="Launch alternative browser"),
    Key("M-<F2>", lazy.spawn(player), desc="Launch music player"),
    Key("M-S-<F2>", lazy.spawn(alt_player), desc="Launch alternative music player"),
    Key("M-<F3>", lazy.spawn(explorer), desc="Launch file explorer"),
    Key("M-S-<F3>", lazy.spawn(alt_explorer), desc="Launch alternative file explorer"),

    # Launchers
    Key("M-<space>", lazy.spawn('rofi -modi run -show run'), desc='Run a command'),
    Key("M-S-<space>", lazy.spawn('rofi -modi drun -show drun -show-icons'), desc='Launch an application'),
    Key("M-A-<space>", lazy.spawn(f'CHOICE=$(dotfiles_list | rofi -dmenu -p file) && {terminal} -e {editor} "$CHOICE"'), desc='Select and edit a dotfile'), # TODO: does not work, extract to script?
    Key("M-C-<space>", lazy.spawn('rofi -modi window -show window'), desc='Select a window'),

    # Menus
    Key("M-<slash>", lazy.spawn('system-menu show'), desc='Show system menu'),
    Key("M-<BackSpace>", lazy.spawn('powerctl show'), desc='Show power management menu'),

    # Audio controls
    Key("<XF86AudioPrev>", lazy.spawn('sp prev')),
    Key("<XF86AudioNext>", lazy.spawn('sp next')),
    Key("<XF86AudioPlay>", lazy.spawn('sp play')),
    Key("<XF86AudioStop>", lazy.spawn('sp pause')),
    Key("<XF86AudioLowerVolume>", lazy.spawn('pactl set-sink-volume @DEFAULT_SINK@ -5%')),
    Key("<XF86AudioRaiseVolume>", lazy.spawn('pactl set-sink-volume @DEFAULT_SINK@ +5%')),

    # Utilities
    Key("<Print>", lazy.spawn('scrotclip'), desc="Take a screenshot"),
    Key("M-<grave>", lazy.group['scratchpad'].dropdown_toggle('term'), desc='Show terminal dropdown'),
    Key("M-S-<BackSpace>", lazy.spawn('powerctl lock'), desc='Lock the session'),
    Key("M-b", lazy.spawn('bwmenu'), desc='Run Bitwarden menu'),
]

group_definitions = {
    'main': ('1', '爵'),
    'code': ('2', ''),
    'communication': ('3', ''),
    'IV': ('4', '❹'),
    'music': ('5', 'ﱘ'),
}
scratchpad = ScratchPad('scratchpad', [
    DropDown('term', terminal, width=0.9, height=0.6, x=0.05, warp_pointer=False),
])
groups = [Group(k, label=v[1]) for k, v in group_definitions.items()]

for i in groups:
    group_key = group_definitions[i.name][0]
    keys.extend([
        Key(f'M-{group_key}', lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),
        Key(f'M-S-{group_key}', lazy.window.togroup(i.name), desc="Move focused window to group {}".format(i.name)),
    ])

groups = [scratchpad] + groups

layouts = [
    CustomBsp(border_focus='#bd93f9', border_width=2, margin=6, fair=False),
    layout.Max(),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
    Click([], "Button9", lazy.spawn('xte "key XF86AudioPlay"')),
    Click([], "Button8", lazy.spawn('xte "key XF86AudioNext"')),
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
focus_on_window_activation = "smart"
wmname = "LG3D"
