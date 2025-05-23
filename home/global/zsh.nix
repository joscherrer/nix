{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
let
  kubectx-wrapper = pkgs.writeShellScriptBin "kubectl-ctx" ''
    kubeconfig_tmp=($(find ${config.xdg.configHome}/kube -name "*.yaml" -type f -print0 | xargs -0))
    KUBECONFIG="$(IFS=: ; echo "''${kubeconfig_tmp[*]}")"
    [ -f "${config.xdg.configHome}/kube/config" ] && KUBECONFIG="$KUBECONFIG:${config.xdg.configHome}/kube/config"
    [ -n "$KUBECONFIG" ] && KUBECONFIG="$KUBECONFIG" kubectl config view --merge --flatten > ${config.xdg.configHome}/kube/config.tmp
    mv -f ${config.xdg.configHome}/kube/config.tmp ${config.xdg.configHome}/kube/config
    export KUBECONFIG="${config.xdg.configHome}/kube/config"
    exec kubectx "$@"
  '';

  kubectl-fw = pkgs.writeScriptBin "kubectl-fw" (
    builtins.readFile "${inputs.self}/scripts/kubectl-fw"
  );

  awsp = pkgs.writeShellScriptBin "awsp" ''
    profile=$(aws configure list-profiles | fzf)
    [ -n "$profile" ] && export AWS_PROFILE="$profile"
  '';

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

    complete -o nospace -C ${pkgs.vault-bin}/bin/vault vault
    complete -o nospace -C ${pkgs.terraform}/bin/terraform terraform
    complete -o nospace -C ${pkgs.awscli2}/bin/aws_completer aws
    complete -o nospace -C ${pkgs.minio-client}/bin/mc mc
  '';

  envExtra = ''
    export _ZL_FZF=${pkgs.fzf}/bin/fzf

    typeset -aUT INFOPATH infopath=()

    infopath+=(/usr/share/info /opt/homebrew/share/info)
    manpath+=(/usr/share/man /opt/homebrew/share/man /run/current-system/sw/share/man/ /etc/profiles/per-user/jscherrer/share/man)
    fpath+=(~/.config/zsh/site-functions /opt/homebrew/share/zsh/site-functions)
    PATH="$(echo "$PATH" | perl -pe 's|.*${pkgs.tmuxp}/bin:||')"
    path=(~/.local/bin /opt/homebrew/bin /opt/homebrew/sbin ''$(go env GOPATH)/bin "''${path[@]}")
  '';
  common-root = "${inputs.self}/dotfiles/common";
in
{
  imports = [
    ./fzf.nix
  ];

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit && compinit
      autoload -U +X bashcompinit && bashcompinit
    '';
    syntaxHighlighting.enable = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = "$terminfo[kcuu1]";
      searchDownKey = "$terminfo[kcud1]";
    };
    history = {
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 9999999;
      size = 9999999;
    };
    shellAliases = {
      ls = "lsd";
      l = "lsd -lah";
      ll = "lsd -lh";
      tldr = "cht.sh";
      vim = "nvim";
      vi = "nvim";
      grep = "rg";
      kz = "kustomize";
      k = "kubectl";
      p = "podman";
      d = "docker";
      pc = "podman-compose";
      dc = "docker-compose";
      md = "mkdir -p";
      rd = "rmdir";
      # tf = "terraform";
      tf = "tofu";
      _ = "sudo ";
      cat = "bat";
      kexec = "kubectl exec -it ";
      kpods = "kubectl get pods ";
      kdesc = "kubectl describe ";
      kwaitp = "kubectl wait --for=condition=ready pod ";
      ltmux = "tmuxp load -d $(find ~/.config/tmuxp -name \"*.yaml\" -exec basename {} .yaml \\;)";
      open = "xdg-open";
    };
    initExtra = initExtra;
    envExtra = envExtra;
    sessionVariables = {
      KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
      KUBECONFIG = "${config.xdg.configHome}/kube/config";
      KUBECTL_EXTERNAL_DIFF = "delta --default-language yaml";
      EDITOR = "nvim";
      HELM_PLUGINS = "${config.xdg.dataHome}/helm/plugins:${pkgs.kubernetes-helmPlugins.helm-diff}";
      LESS = "-R --mouse --quit-if-one-screen";
    };
  };

  programs.z-lua = {
    enable = true;
    enableAliases = true;
    enableZshIntegration = true;
    options = [
      "enhanced"
      "once"
      "fzf"
    ];
  };
  # programs.autojump.enable = true;

  home.packages = [
    kubectx-wrapper
    awsp
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
    command -v talosctl > /dev/null && [ ! -f "$USER_COMP/_talosctl" ] && talosctl completion zsh > "$USER_COMP/_talosctl"
    command -v clusterctl > /dev/null && [ ! -f "$USER_COMP/_clusterctl" ] && clusterctl completion zsh > "$USER_COMP/_clusterctl"
    command -v task > /dev/null && [ ! -f "$USER_COMP/_task" ] && task --completion zsh > "$USER_COMP/_task"
    # source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
  '';
}
