# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

function add_dir_to_path() {
    if [ -d "$1" ]; then
        PATH="$1:$PATH"
    fi
}

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

add_dir_to_path "$HOME/bin"
add_dir_to_path "$HOME/.local/bin"
add_dir_to_path "$HOME/.cargo/bin"
add_dir_to_path "$HOME/.bin"
add_dir_to_path "$HOME/.emacs.d/bin"
add_dir_to_path "$HOME/.dotnet/tools"
export PATH

export XDG_CONFIG_HOME="$HOME/.config"

# Default sotftware
export TERMINAL="alacritty"
export EDITOR="nvim"
export ALT_EDITOR="emacs"
export BROWSER="firefox"
export ALT_BROWSER="chromium-browser"
