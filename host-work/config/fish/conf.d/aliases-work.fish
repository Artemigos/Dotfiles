alias k=kubectl
alias h=helm
alias xc="xclip -selection clipboard"

alias kss="kubectl --kubeconfig ~/.kube/shared-services.config"
alias kcp="kubectl --context core-prod"
alias kcd="kubectl --context core-dev"
alias ko="kubectl --kubeconfig ~/.kube/obs-beta.config"
alias kctx="kubectl config use-context"

alias ocd='osprey user login core-dev -u lklimek -p (pass CUP/VPN | head -n1)'
alias ocp='osprey user login --group=core-prod core-prod -u lklimek -p (pass CUP/VPN | head -n1)'

alias cat="batcat"
