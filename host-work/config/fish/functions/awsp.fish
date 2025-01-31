function awsp
    argparse --min-args 0 --max-args 1 'h/help' -- $argv
    if set -q _flag_help
        echo "awsp [-h] [PROFILE]"
        return 0
    end

    if test (count $argv) -eq 0
        set -e AWS_PROFILE
    else
        set -g -x AWS_PROFILE $argv[1]
    end

    return 0
end
