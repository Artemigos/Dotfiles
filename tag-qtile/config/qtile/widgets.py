from libqtile import bar, widget
from libqtile.config import Screen

from simple_mpris2 import SimpleMpris2, PlaybackStatus
from utils import run_cmd

def format_song(status, artist, song):
    if status == PlaybackStatus.Paused:
        return f' {artist} - {song}'
    elif status == PlaybackStatus.Stopped:
        return '栗'
    elif status == PlaybackStatus.Playing:
        return f'契 {artist} - {song}'

    return 'ﱘ'

def open_menu():
    run_cmd(['d', 'system', 'show'])

widget_defaults = dict(
    font='Iosevka',
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

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text='',
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
                SimpleMpris2(display_formatter=format_song),
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
                    fmt='墳 {}',
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
