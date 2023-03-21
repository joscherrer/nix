GH_COMP=$HOME/.config/zsh/site-functions/_gh
HELM_COMP=$HOME/.config/zsh/site-functions/_helm
PODMAN_COMP=$HOME/.config/zsh/site-functions/_podman
KUBE_COMP=$HOME/.config/zsh/site-functions/_kubectl

mkdir -p "$HOME/.config/zsh/site-functions"

command -v gh > /dev/null && [ ! -f "$GH_COMP" ] && gh completion -s zsh > "$GH_COMP"
command -v kubectl > /dev/null && [ ! -f "$KUBE_COMP" ] && kubectl completion zsh > "$KUBE_COMP"
command -v podman > /dev/null && [ ! -f "$PODMAN_COMP" ] && podman completion zsh -f "$PODMAN_COMP"
command -v helm > /dev/null && [ ! -f "$HELM_COMP" ] && helm completion zsh > "$HELM_COMP"