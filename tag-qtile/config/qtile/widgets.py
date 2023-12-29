from libqtile import bar, widget, qtile
from libqtile.config import Screen

from rounded_container import RoundedContainer
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

mpris = SimpleMpris2(
        display_formatter=format_song,
        mouse_callbacks={
            'Button1': mpris_left,
            'Button2': mpris_middle,
            'Button3': mpris_right,
        })

space = widget.Spacer(length=10, background='#00000000')
screens = [
    Screen(
        top=bar.Bar(
            [
                # widget.TextBox(
                #     text='󰍜',
                #     background='#bd93f9',
                #     mouse_callbacks={'Button1': open_menu},
                # ),
                RoundedContainer(widget=widget.GroupBox(
                    active='f8f8f2', # has windows, not in view
                    this_current_screen_border='bd93f9', # currently in view
                    highlight_method='text',
                    inactive='6272a4', # no windows, not in view
                    urgent_alert_method='text',
                    urgent_text='ff5555',
                )),
                widget.Spacer(background='#00000000'),
                RoundedContainer(widget=mpris),
                widget.Spacer(background='#00000000'),
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
                widget.Systray(background='#00000000', icon_size=16, padding=8),
            ],
            20,
            margin=[2, 5, 0, 5],
            background='#00000000',
        ),
    ),
]
