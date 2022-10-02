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

function source_if_file() {
    [ -f $1 ] && . $1
}

# if running bash
if [ -n "$BASH_VERSION" ]; then
    source_if_file "$HOME/.bashrc"
fi

source_if_file "$HOME/.bw_credentials"

add_dir_to_path "$HOME/bin"
add_dir_to_path "$HOME/.local/bin"
add_dir_to_path "$HOME/.cargo/bin"
add_dir_to_path "$HOME/.bin"
add_dir_to_path "$HOME/.emacs.d/bin"
add_dir_to_path "$HOME/.dotnet/tools"
export PATH

export XDG_CONFIG_HOME="$HOME/.config"

# Default sotftware
export TERMINAL="kitty"
export EDITOR="nvim"
export ALT_EDITOR="emacs"
export BROWSER="firefox"
export ALT_BROWSER="chromium-browser"

# teach GUI to use IBus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im-ibus
export QT_IM_MODULE=ibus
export XIM_PROGRAM=/usr/bin/ibus-daemon
