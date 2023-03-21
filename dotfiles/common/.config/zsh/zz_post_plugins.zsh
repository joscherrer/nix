#!/bin/zsh

prompt_pure_set_title() {
    setopt localoptions noshwordsplit

    # Emacs terminal does not support settings the title.
    (( ${+EMACS} || ${+INSIDE_EMACS} )) && return

    case $TTY in
        # Don't set title over serial console.
        /dev/ttyS[0-9]*) return;;
    esac

    # Show hostname if connected via SSH.
    local hostname=
    if [[ -n $prompt_pure_state[username] ]]; then
        # Expand in-place in case ignore-escape is used.
        hostname="${(%):-(%m) }"
    fi

    local -a opts
    case $1 in
        expand-prompt) opts=(-P);;
        ignore-escape) opts=(-r);;
    esac

    # Remove pwd
    PRESTRIP="$PWD:t: "

    # Set title atomically in one print statement so that it works when XTRACE is enabled.
    print -n $opts $'\e]0;'${hostname}${2#$PRESTRIP}$'\a'
}
