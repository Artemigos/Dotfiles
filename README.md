# Dotfiles

My personal set of dotfiles. Used on Ubuntu 18.04, but will gradually move to something Arch-based.

## Installing

To install at least `stow` is needed. Stow cancels the restoration process if the files already exists.
To make sure everything works look through and remove your conflicting files with configuration, **but be careful an make sure you know what you're doing**.

1. `git clone git@github.com:Artemigos/Dotfiles.git ~/.dotfiles`
2. `cd ~/.dotfiles && ./restore`

## System dependencies

### Applications

- polybar - top bar with tray
- feh - wallpaper setter
- compton - compositor
- rofi - for all the selection menus
- xsel - for emoji selector
- xclip - for screenshot copying
- scrot - for making screenshots
- gnome-screensaver - for screen locking
- numlockx - to enable numlock after login
- ibus - input bus
- xte - to simulate media key presses on mouse buttons
- xrdb - for Xresources for st

### Fonts

- Fantasque Sans Mono - <https://github.com/belluzj/fantasque-sans/releases>
- Iosevka Nerd Font - <https://github.com/ryanoasis/nerd-fonts/releases>

## Default applications

### Set in `~/.profile`

- terminal - st
- editor - vim
- browser - chromium-browser

### Shortcuts

- `Super + Return` - main terminal
- `Super + ctrl + Return` - main editor

- `Super + F1` - main browser
- `Super + Shift + F1` - firefox

- `Super + F2` - Spotify
- `Super + Shift + F2` - youtube

- `Super + F3` - ranger
- `Super + Shift + F3` - nautilus

## Todo

- ranger
- vim (it's barely there right now)
- tmux?
- update `sp help` to include info about my new commands
