from libqtile import bar, widget, qtile
from libqtile.config import Screen

from simple_mpris2 import SimpleMpris2, PlaybackStatus
from utils import run_cmd

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
    font='Iosevka Nerd Font Mono',
    fontsize=24,
    padding=10,
    foreground='#f8f8f2',
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
            if w.name == 'Spotify':
                w.kill()
                break

mpris = SimpleMpris2(
        display_formatter=format_song,
        mouse_callbacks={
            'Button1': mpris_left,
            'Button2': mpris_middle,
            'Button3': mpris_right,
        })

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text='󰍜',
                    background='#bd93f9',
                    mouse_callbacks={'Button1': open_menu},
                ),
                widget.GroupBox(
                    active='f8f8f2',
                    this_current_screen_border='44475a',
                    highlight_method='block',
                    inactive='6272a4',
                    urgent_alert_method='text',
                    urgent_text='ff5555',
                ),
                widget.Spacer(),
                mpris,
                widget.Spacer(),
                widget.CheckUpdates(
                    distro='Arch_checkupdates',
                    fmt=' {}',
                    display_format='{updates}',
                    no_update_string='0',
                    update_interval=300,
                ),
                widget.Sep(),
                VolumeOverride(
                    step=5,
                    fmt='󰕾 {}',
                    get_volume_command=['d', 'audio', 'get-volume'],
                    volume_down_command='d audio decrease-volume',
                    volume_up_command='d audio increase-volume',
                ),
                widget.Sep(),
                widget.Clock(format=' %H:%M'),
                widget.Sep(),
                widget.Clock(format=' %d/%m'),
                widget.Sep(),
                widget.Systray(icon_size=24, padding=8),
            ],
            32,
            margin=0,
            background='#282a36',
        ),
    ),
]
