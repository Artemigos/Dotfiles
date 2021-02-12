# Dotfiles

My personal set of dotfiles. Used on Arch linux.

## Installing

To install `rcm` is needed.
To make sure everything gets applied use `rcup -vf` to force restoring files that already exist on the system, **but be careful and make sure you know what you're doing**.

1. `git clone git@github.com:Artemigos/Dotfiles.git ~/.dotfiles`
1. `rcup rcrc`
1. `rcup`

## System dependencies

### Applications

- polybar - top bar with tray
- feh - wallpaper setter
- picom - compositor
- rofi - for all the selection menus
- xsel - for emoji selector
- xclip - for screenshot copying
- maim - for making screenshots
- light-locker - for screen locking
- numlockx - to enable numlock after login
- ibus - input bus
- xte - to simulate media key presses on mouse buttons
- xrdb - for Xresources for st
- redshift-gtk - night colors (less blue light)

### Fonts

- Fantasque Sans Mono - <https://github.com/belluzj/fantasque-sans/releases>
- Iosevka Nerd Font - <https://github.com/ryanoasis/nerd-fonts/releases>
- Liberation Mono

## Default applications

### Set in `~/.profile`

- terminal - alacritty
- editor - nvim
- browser - firefox

### Shortcuts

- `Super + Return` - main terminal
- `Super + ctrl + Return` - main editor

- `Super + F1` - main browser
- `Super + Shift + F1` - secondary browser

- `Super + F2` - Spotify
- `Super + Shift + F2` - youtube

- `Super + F3` - ranger
- `Super + Shift + F3` - pcmanfm

## Todo

- ranger
- vim (it's barely there right now)
- tmux?
- update `sp help` to include info about my new commands
- prepare rofi menus
  - expand audioctl?
  - and more (networkctl? workspacectl? displayctl?)
