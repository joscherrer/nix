command -v nvim >/dev/null 2>&1 && alias vim="nvim"
command -v cht.sh >/dev/null 2>&1 && alias tldr="cht.sh"
command -v lsd >/dev/null 2>&1 && alias ls='lsd'

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

alias md='mkdir -p'
alias rd=rmdir

alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias k="kubectl"
alias tf="terraform"
alias p="podman"
alias pc="podman-compose" 
