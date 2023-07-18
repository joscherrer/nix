{ inputs, lib, pkgs, config, outputs, ... }:
let
  initExtra = ''
  prompt pure

  for config_file (~/.config/zsh/*.zsh(N)); do
    custom_config_file="''$HOME/.config/zsh/''${config_file:t}"
    [ -f "''${custom_config_file}" ] && config_file=''${custom_config_file}
    source ''$config_file
  done

  if [ -f "''$HOME/.zshrc" ]; then
    source "''$HOME/.zshrc"
  fi
  '';

  envExtra = ''
  export _ZL_FZF=${pkgs.fzf}/bin/fzf

  typeset -aUT INFOPATH infopath=()

  infopath+=(/usr/share/info /opt/homebrew/share/info)
  manpath+=(/usr/share/man /opt/homebrew/share/man /run/current-system/sw/share/man/ /etc/profiles/per-user/jscherrer/share/man)
  fpath+=(~/.config/zsh/site-functions)
  path+=(~/.local/bin /opt/homebrew/bin /opt/homebrew/sbin)
  '';
  common-root = "${inputs.self}/dotfiles/common";
in
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 50000;
      size = 100000;
    };
    shellAliases = {
      ls = "lsd";
      l = "lsd -lah";
      ll = "lsd -lh";
      tldr = "cht.sh";
      vim = "nvim";
      vi = "nvim";
      grep = "rg";
      kz = "kuztomize";
      k = "kubectl";
      p = "podman";
      pc = "podman-compose";
      md = "mkdir -p";
      rd = "rmdir";
      tf = "terraform";
      _ = "sudo ";

    };
    initExtra = initExtra;
    envExtra = envExtra;
  };

  programs.zsh.historySubstringSearch.enable = true;

  home.packages = [
    pkgs.z-lua
  ];

  home.file.".config/zsh/keybindings.zsh".source = "${common-root}/.config/zsh/keybindings.zsh";
  home.file.".config/zsh/completion.zsh".source = "${common-root}/.config/zsh/completion.zsh";
  home.file.".config/zsh/functions.zsh".source = "${common-root}/.config/zsh/functions.zsh";
  home.file.".config/zsh/styling.zsh".source = "${common-root}/.config/zsh/styling.zsh";
  home.file.".config/zsh/history.zsh".source = "${common-root}/.config/zsh/history.zsh";
  home.file.".config/zsh/misc.zsh".source = "${common-root}/.config/zsh/misc.zsh";
  home.file.".config/zsh/plugins.zsh".text = ''
  USER_COMP="$HOME/.config/zsh/site-functions"
  PODMAN_COMP="$USER_COMP/_podman"
  [ -d "$USER_COMP" ] || mkdir -p "$USER_COMP"

  command -v podman > /dev/null && [ ! -f "$PODMAN_COMP" ] && podman completion zsh -f "$PODMAN_COMP"
  # source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
  '';
}
