# ~/.zshrc

[ "$ZSH_PROFILE" = "true" ] && zmodload zsh/zprof

if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache"
fi

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

autoload -U compaudit compinit

for config_file (~/.config/zsh/*.zsh(N)); do
  custom_config_file="$HOME/.config/zsh/${config_file:t}"
  [ -f "${custom_config_file}" ] && config_file=${custom_config_file}
  source $config_file
done

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

[ -e ~/.config/dircolors ] && eval $(dircolors ~/.config/dircolors)

[ "$ZSH_PROFILE" = "true" ] && zprof
