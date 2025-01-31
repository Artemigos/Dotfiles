function _awsp_complete
    sed -E "s/\[profile (.+)\]/\1/p;d" ~/.aws/config
end

complete -c awsp -f -a "(_awsp_complete)"
