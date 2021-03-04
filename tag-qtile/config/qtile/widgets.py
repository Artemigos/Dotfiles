from libqtile import bar, widget
from libqtile.config import Screen

import custom_widgets
from utils import run_cmd

def get_song():
    playing = run_cmd(['sp', 'status']) == 'Playing'
    if not playing:
        return ''

    artist = run_cmd(['sp', 'metadata-field', 'artist'])
    song = run_cmd(['sp', 'metadata-field', 'title'])
    return f'{artist} - {song}'

widget_defaults = dict(
    font='Iosevka',
    fontsize=24,
    padding=10,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                #widget.CurrentLayout(),
                #widget.Sep(),
                widget.GroupBox(font='Noto Color Emoji'),
                widget.Sep(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.GenPollText(func=get_song, update_interval=2),
                widget.Sep(),
                widget.CheckUpdates(distro='Arch_checkupdates', display_format=' {updates}'),
                widget.Sep(),
                widget.Volume(step=5, fmt='墳 {}'),
                widget.Sep(),
                widget.Clock(format=' %H:%M'),
                widget.Sep(),
                widget.Systray(icon_size=24, padding=8),
            ],
            32,
            margin=6
        ),
        #left=bar.Bar(
        #    [
        #        custom_widgets.Box(20, background='#FF0000'),
        #        widget.Sep(),
        #    ],
        #    48,
        #    margin=[0, 6, 0, 0],
        #    background='#DDDDDD'
        #),
    ),
]
