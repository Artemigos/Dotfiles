function pman
    man -t $argv[1] | ps2pdf - - | zathura --fork --mode=fullscreen -
end
