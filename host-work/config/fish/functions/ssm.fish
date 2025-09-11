function ssm
    argparse --min-args 1 --max-args 1 -- $argv
    aws ssm start-session --target $argv[1]
end
