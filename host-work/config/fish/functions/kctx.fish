function kctx
    argparse --min-args 0 --max-args 1 'h/help' -- $argv
    if set -q _flag_help
        echo "kctx [-h] [CONTEXT]"
        return 0
    end

    if test (count $argv) -eq 0
        set -e KUBECTL_CONTEXT
    else
        set -gx KUBECTL_CONTEXT $argv[1]
    end

    return 0
end
