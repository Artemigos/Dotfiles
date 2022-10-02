function fish_greeting
end

if status is-interactive
    starship init fish | source

    bind \cZ 'fg'
end
