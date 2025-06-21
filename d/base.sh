#!/bin/bash

set -euo pipefail

DOTFILES_HOME=${DOTFILES_HOME:?DOTFILES_HOME variable is not set.}
D_HOME=$DOTFILES_HOME/d

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

SUBCOMMANDS=()
SUB_NAMES=()
SUB_LEVELS=()
declare -A REV_MAP=()

# shellcheck disable=SC2317 # those functions are used in other files that source this one
@setup() {
    PREFIX=${1:?Prefix required}
    PROMPT=${2:-option}

    @reg() {
        local cmd=${1:?Subcommand required}
        local name=${2:?Name required}
        local level=${3:-0}
        REV_MAP["$cmd"]=${#SUBCOMMANDS[@]}
        SUBCOMMANDS+=("$cmd")
        SUB_NAMES+=("$name")
        SUB_LEVELS+=("$level")
    }

    @main() {
        if [[ $# -eq 0 ]]; then
            err 'Subcommand expected.'
        fi
        local subcmd=$1
        shift
        case $subcmd in
            list-commands) @list-commands "$@"; return 0 ;;
            show-menu) @show-menu "$@"; return 0 ;;
            list-x-options)
                d notify 'Deprecated entry point' 'Please stop using "list-x-options"'
                @list-commands "$@"
                return 0
                ;;
            show)
                d notify 'Deprecated entry point' 'Please stop using "show"'
                @show-menu "$@"
                return 0
                ;;
        esac
        if [[ -n "${REV_MAP["$subcmd"]-}" ]]; then
            local i=${REV_MAP["$subcmd"]}
            local cmd=${SUBCOMMANDS[$i]}
            $cmd "$@"
        else
            local cmd=${PREFIX// /-}$subcmd
            if d has-cmd "$cmd"; then
                "$cmd" "$@"
            elif [[ -x "$D_HOME/$cmd" ]]; then
                "$D_HOME/$cmd" "$@"
            else
                echo "Unknown command: $subcmd"
            fi
        fi
    }

    @list-commands() {
        local max_level=${1:-0}
        local had_items=0
        echo '{'
        echo '  "prompt": "'"$PROMPT"'",'
        echo -n '  "commands": ['
        for i in "${!SUBCOMMANDS[@]}"; do
            local level=${SUB_LEVELS[$i]}
            if [[ $level -gt $max_level ]]; then
                continue
            fi
            if [[ $had_items -gt 0 ]]; then
                echo ','
            else
                echo
            fi
            echo '    {'
            echo '      "description": "'"${SUB_NAMES[$i]}"'",'
            echo '      "command": "'"$PREFIX${SUBCOMMANDS[$i]}"'"'
            echo -n '    }'
            had_items=$((had_items + 1))
        done
        echo
        echo '  ]'
        echo '}'
    }

    @show-menu() {
        @list-commands "$@" | d menu from-json
    }
}
