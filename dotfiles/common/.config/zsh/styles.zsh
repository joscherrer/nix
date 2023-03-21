export HIGHLIGHT_STYLE=base16/snazzy

RPROMPT='%F{white}%*'

zstyle :prompt:pure:user color white
zstyle :prompt:pure:host color green

# ls colors
autoload -U colors && colors

# Enable ls colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
function colorize_ls() {
    if [ -z "$LS_COLORS" -a -n "$(command -v dircolors)" -a "$TERM" = "alacritty" ]; then
        eval $(env TERM=alacritty-color dircolors)
    fi
}

colorize_ls
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

setopt auto_cd
setopt multios
setopt prompt_subst

[[ -n "$WINDOW" ]] && SCREEN_NO="%B$WINDOW%b " || SCREEN_NO=""
