# Dotfiles

My personal set of dotfiles. Used on Arch linux.

## Installing

To install `make` is needed.

1. `git clone git@github.com:Artemigos/Dotfiles.git ~/.dotfiles && cd ~/.dotfiles`
1. `make install`

By default, very few things get actually installed. You can pick which components to install by opting into tags. This can be done in `$XDG_CONFIG_HOME/.config/d/config.toml`:

```toml
[restore]
tags =[
    "bash",
    "dunst",
    "fish",
    "fuzzel",
    "kitty",
    "niri",
    "nvim",
    "waybar",
]
```

## Bootstrapping the `d` command

The `d` command is the centerpiece of my dotfiles - other tools are configure to use it for stuff (niri keybinding, waybar widgets, neovim toggles for plugins). That's also how you access a bunch of subcommands residing in the `d/` directory of this repo. That's why it's important that it works. Running `make install` above already made use of the `d-restore` subcommand, which should also bootstrap your system with a `~/.profile` file that adds necessary env vars (might need to re-login to apply), but in case you don't want to use that file, it's necessary to:

- add `$HOME/.local/bin` to `$PATH` - that's where the `d` command gets installed
- set (and export) `DOTFILES_HOME` to where the dotfiles are cloned (should be `$HOME/.dotfiles`)

This should be enough to enable access to all the `d` subcommands. It's also recommended to have a notification daemon and `notify-send` available - that's how `d` subcommands inform you about missing CLI tools when they're necessary.

## System dependencies management

There's a simple system package/app management tool built in. This is hidden behind the `paru-sync` and `system-packages(...)` tags. When enabled you can use `make sync` to synchronize your system with the expected list of packages. Just keep in mind that it's very primitive at the moment and the packages lists in this repo aren't sufficiently divided into subtags - the "restore" infrastructure is ready for that, I just didn't get around to that yet. You might want to maintain your own package lists instead.

The tool relies on `paru` instead of `pacman` for AUR support. Flatpaks are managed as well.

If you're confused about which packages are needed for certain tags to work, you can try to reference my package lists, but it not well organized atm.
