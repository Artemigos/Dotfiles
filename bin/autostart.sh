#!/bin/sh

random_wallpaper
# picom -b # broken AF
numlockx on
ibus-daemon -dxr
setxkbmap -option caps:ctrl_modifier
xrdb -merge "$HOME/.Xresources"
redshift-gtk &

# personally used software
/opt/Mullvad\ VPN/mullvad-gui &

