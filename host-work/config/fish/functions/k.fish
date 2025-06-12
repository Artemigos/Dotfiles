function k -w kubectl
    if test -n "$KUBECTL_CONTEXT"
        kubectl --context "$KUBECTL_CONTEXT" $argv
    else
        kubectl $argv
    end
end
