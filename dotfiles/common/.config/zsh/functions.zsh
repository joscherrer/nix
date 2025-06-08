#
# bat (less) with yaml highlighting
#
function yaml() {
    bat -l yaml "$@"
}

#
# paged jq
#
function json() {
    jq -C "$@" | less -FR
}


#
# Get the value of an alias.
#
# Arguments:
#    1. alias - The alias to get its value from
# STDOUT:
#    The value of alias $1 (if it has one).
# Return value:
#    0 if the alias was found,
#    1 if it does not exist
#
function alias_value() {
    (( $+aliases[$1] )) && echo $aliases[$1]
}

#
# Try to get the value of an alias,
# otherwise return the input.
#
# Arguments:
#    1. alias - The alias to get its value from
# STDOUT:
#    The value of alias $1, or $1 if there is no alias $1.
# Return value:
#    Always 0
#
function try_alias_value() {
    alias_value "$1" || echo "$1"
}

#
# Set variable "$1" to default value "$2" if "$1" is not yet defined.
#
# Arguments:
#    1. name - The variable to set
#    2. val  - The default value
# Return value:
#    0 if the variable exists, 3 if it was set
#
function default() {
    (( $+parameters[$1] )) && return 0
    typeset -g "$1"="$2"   && return 3
}

#
# Set environment variable "$1" to default value "$2" if "$1" is not yet defined.
#
# Arguments:
#    1. name - The env variable to set
#    2. val  - The default value
# Return value:
#    0 if the env variable exists, 3 if it was set
#
function env_default() {
    (( ${${(@f):-$(typeset +xg)}[(I)$1]} )) && return 0
    export "$1=$2" && return 3
}

function yadm_add() {
    yadm add $(yadm status -s --no-renames | grep "^.[A-Z].*" | cut -c4- | tr '\n' ' ')
}

function yadm_status() {
    yadm status -u .config | grep -vP '.config/(google-chrome|Code|zaap|teamviewer|xfce4|qBittorrent|obs-studio|mpv|icedtea-web|qalculate|VirtualBox|systemd|coc|fcitx5|session|htop|zsh/site-functions|menus|alacritty/.*.bak|borg/security|Ankama|dolphinrc)'
}

function table() {
    column -ts $'\t' -o '|' "$@"
}

function jjq {
    jq -R 'fromjson?' "$@"
}

function envmunge() {
    varname=$1
    value=$2
    varvalue=$(eval "echo \$$varname")

    if [[ :$varvalue: != *:"$value":* ]]; then
        if [ -z "$varvalue" ]; then
            eval "$varname=\"$value\""
        elif [ "$3" = "after" ]; then
            eval "$varname=\"\$$varname:$value\""
        else
            eval "$varname=\"$value:\$$varname\""
        fi
    fi
}

# Required for $langinfo
zmodload zsh/langinfo

# Magic functions
autoload -Uz is-at-least bracketed-paste-magic url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
