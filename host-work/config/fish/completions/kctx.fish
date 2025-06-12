function _kctx_complete
    kubectl config get-contexts -o name
end

complete -c kctx -f -a "(_kctx_complete)"
