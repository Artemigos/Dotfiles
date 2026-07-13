function helmtmpl
    argparse --min-args 3 --max-args 3 'h/help' -- $argv
    if test "$status" -ne 0
        echo "helmtmpl [-h] <NAMESPACE> <RELEASE_NAME> <ENV>"
        return $status
    end
    if set -q _flag_help
        echo "helmtmpl [-h] <NAMESPACE> <RELEASE_NAME> <ENV>"
        return 0
    end

    helm template \
        --namespace $argv[1] \
        -f charts/values.yml \
        -f charts/$argv[3].yml \
        --set image.tag=example-image-tag \
        --set nameOverride=$argv[2] \
        --set fullnameOverride=$argv[2] \
        --set envName=$argv[3] \
        $argv[2] \
        ~/git/charts/base
end
