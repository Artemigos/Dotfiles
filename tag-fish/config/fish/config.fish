function fish_greeting
end

if status is-interactive
    starship init fish | source

    bind \cZ 'fg'
end

alias e "$EDITOR"
alias diskstat 'df -x tmpfs -x devtmpfs -x squashfs -h'
alias ls 'exa'
alias ll 'exa -alh'

function cheat
    curl cheat.sh/$argv[1]
end

function pman
    man -t $argv[1] | ps2pdf - - | zathura --fork --mode=fullscreen -
end
