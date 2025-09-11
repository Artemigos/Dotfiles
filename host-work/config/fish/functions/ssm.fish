function ssm
    argparse --min-args 1 --max-args 1 -- $argv || return 1
    aws ssm start-session --target $argv[1]
end
