# Dotfiles

My personal set of dotfiles. Currently contains:

- bash
- bspwm
- git
- polybar
- sxhkd
- system
- terminator (used before, keeping just in case)
- vim
- vscode

Used on Ubuntu 18.04, but will gradually move to something Arch-based.

## Installing

To install at least `stow` is needed. Stow cancels the restoration process if the files already exists.
To make sure everything works look through and remove your conflicting files with configuration, **but be careful an make sure you know what you're doing**.

1. `git clone git@github.com:Artemigos/Dotfiles.git ~/.dotfiles`
2. `cd ~/.dotfiles && ./restore`

## System dependencies

- rofi - for all the selection menus
- xsel - for emoji selector
- gnome-screensaver - for screen locking

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
- rofi
- vim (it's barely there right now)
- tmux?
- update `sp help` to include info about my new commands
- some kind of menu for shutdown, reboot, sleep, lock, logout
