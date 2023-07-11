function fzfz {
  _dir=$(z | awk '{print $2}' | fzf --tac)
  cd "$_dir"
  zle reset-prompt
}

zle -N fzfz
bindkey '^e' fzfz
