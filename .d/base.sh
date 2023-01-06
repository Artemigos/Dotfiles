#!/bin/bash

set -euo pipefail

DOTFILES_HOME=${DOTFILES_HOME:?DOTFILES_HOME variable is not set.}
D_HOME=$DOTFILES_HOME/.d

# print an error to stderr and return an error code
err() {
    echo "$@" 1>&2
    return 1
}

# forwards a command call to an external exectuable or function with a name that matches the convention
# e.g. calling `d git <other params>` should call `d-git <other params>`
forward-cmd() {
    BASE_CMD=${2:?No command given}
    CMD=${1:?No prefix given}$BASE_CMD
    CMD_T=$(type -t "$CMD" || true)
    shift 2

    if [[ "$CMD_T" == 'alias' || "$CMD_T" == 'function' || "$CMD_T" == 'file' ]]; then
        "$CMD" "$@"
        return 0
    fi

    D_CMD=$D_HOME/$CMD
    D_CMD_T=$(type -t "$D_CMD" || true)
    if [[ "$D_CMD_T" == 'alias' || "$D_CMD_T" == 'function' || "$D_CMD_T" == 'file' ]]; then
        "$D_CMD" "$@"
        return 0
    fi

    echo "Command \"$BASE_CMD\" not found." >&2
    return 1
}
