from libqtile import bar, widget, qtile
from libqtile.config import Screen

from battery import BatteryOverride, machine_has_battery
from rounded_container import RoundedContainer
from simple_mpris2 import SimpleMpris2, PlaybackStatus
from utils import run_cmd, run_cmd_test
from custom_poll_command import CustomPollCommand, preprocess_sep_to_sep

def format_song(status, artist, song):
    if status == PlaybackStatus.Paused:
        return f'󰏤 {artist} - {song}'
    elif status == PlaybackStatus.Stopped:
        return '󰓛'
    elif status == PlaybackStatus.Playing:
        return f'󰐊 {artist} - {song}'

    return '󰝚'

def open_menu():
    run_cmd(['d', 'system', 'show'])

widget_defaults = dict(
    font='Iosevka NFM',
    fontsize=16,
    padding=0,
    foreground='#f8f8f2',
    background='#282a36',
)
extension_defaults = widget_defaults.copy()

class VolumeOverride(widget.Volume):
    def get_volume(self):
        try:
            out = self.call_process(self.get_volume_command)
            return int(out)
        except:
            return -1

def mpris_left():
    assert mpris is not None
    status = mpris.info()['status']
    if status is not None:
        run_cmd(['sp', 'play'])
    else:
        qtile.spawn('spotify') # TODO: get it from a common place

def mpris_right():
    assert mpris is not None
    status = mpris.info()['status']
    if status == PlaybackStatus.Playing or status == PlaybackStatus.Paused:
        run_cmd(['sp', 'next'])

def mpris_middle():
    assert mpris is not None
    status = mpris.info()['status']
    if status is not None:
        for w in qtile.windows_map.values():
            if 'Spotify' in w.name:
                w.kill()
                break

space = widget.Spacer(length=10, background='#00000000')

mpris = SimpleMpris2(
        display_formatter=format_song,
        mouse_callbacks={
            'Button1': mpris_left,
            'Button2': mpris_middle,
            'Button3': mpris_right,
        })

bat = []
if machine_has_battery():
    bat.append(RoundedContainer(widget=BatteryOverride(
        charge_char='󰂄',
        discharge_char='󰁾',
        empty_char='󰂃',
        format='{char} {percent:2.0%} {hour:d}:{min:02d}',
        full_char='󰁹',
        low_foreground='ff5555',
        notify_below=10,
        unknown_char='󰂃',
        update_interval=10,
    )))
    bat.append(space)

vpn = []
if True:
    vpn.append(RoundedContainer(widget=CustomPollCommand(
        cmd=['d', 'vpn', 'list-vpn-connections'],
        format='󰖂 {}',
        empty_format='󰖂',
        preprocess=preprocess_sep_to_sep(),
        mouse_callbacks={
            'Button1': lambda: run_cmd(['d', 'vpn', 'show']),
        },
    )))
    vpn.append(space)

bt = []
if run_cmd_test(['d', 'bluetooth', 'is-available']):
    def preproc_devices(text: str) -> str:
        if text is None or text == '':
            return text
        devices = [x.split(' ')[2] for x in text.split('\n')]
        return ', '.join(devices)
    bt.append(RoundedContainer(widget=CustomPollCommand(
        cmd=['d', 'bluetooth', 'list-connected-devices'],
        format=' {}',
        empty_format='',
        preprocess=preproc_devices,
        mouse_callbacks={
            'Button1': lambda: run_cmd(['d', 'bluetooth', 'show']),
        },
    )))
    bt.append(space)

screens = [
    Screen(
        top=bar.Bar(
            [
                RoundedContainer(background='#bd93f9', widget=widget.TextBox(
                    text='󰍜',
                    background='#bd93f9',
                    mouse_callbacks={'Button1': open_menu},
                )),
                space,
                RoundedContainer(widget=widget.GroupBox(
                    active='bd93f9', # has windows, not in view
                    this_current_screen_border='f8f8f2', # currently in view
                    highlight_method='text',
                    inactive='6272a4', # no windows, not in view
                    urgent_alert_method='text',
                    urgent_text='ff5555',
                )),
                widget.Spacer(background='#00000000'),
                RoundedContainer(widget=mpris),
                widget.Spacer(background='#00000000'),
                *bt,
                *vpn,
                RoundedContainer(widget=widget.CheckUpdates(
                    distro='Arch_checkupdates',
                    fmt=' {}',
                    display_format='{updates}',
                    no_update_string='0',
                    update_interval=300,
                )),
                space,
                RoundedContainer(widget=VolumeOverride(
                    step=5,
                    fmt='󰕾 {}',
                    get_volume_command=['d', 'audio', 'get-volume'],
                    volume_down_command='d audio decrease-volume',
                    volume_up_command='d audio increase-volume',
                )),
                space,
                RoundedContainer(widget=widget.Clock(format=' %H:%M')),
                space,
                RoundedContainer(widget=widget.Clock(format=' %d/%m')),
                space,
                *bat,
                widget.Systray(background='#00000000', icon_size=16, padding=8),
            ],
            20,
            margin=[2, 5, 0, 5],
            background='#00000000',
        ),
    ),
]

# mark the Qtile bar as a "dock" window type to match it in compositor rules
if qtile.core.name == 'x11':
    def set_bar_window_type():
        w = screens[0].top.window.window
        a = qtile.core.conn.atoms['_NET_WM_WINDOW_TYPE_DOCK']
        w.set_property('_NET_WM_WINDOW_TYPE', a)
    qtile.call_soon(set_bar_window_type)
