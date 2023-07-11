{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../../modules/alacritty
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/Users/jscherrer";
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    # Shell utilities
    coreutils
    socat
    curl
    git
    delta
    jq
    yq-go
    ripgrep
    tmux
    pgcli
    gnupg
    shellcheck
    cht-sh
    fzf
    pure-prompt

    cmake

    # Containers
    podman-compose
    dive
    buildah
    kustomize
    kubectl
    kubectx
    kubelogin-oidc
    kind
    hadolint

    # JS/TS
    unstable.nodejs
    nodePackages.typescript
    yarn

    # Golang
    unstable.gopls
    unstable.go-outline

    # Java
    openjdk11
    gradle
    maven
    kotlin
    kotlin-native
    kotlin-language-server

    # Nix
    niv
    rnix-lsp
  
    # Others
    terraform
    unstable.vault-bin
    unstable.mitmproxy
    wireshark
    youtube-dl
    unstable.open-policy-agent
    inputs.kmonad.packages."${pkgs.system}".kmonad
  ];

  programs.go.enable = true;
  programs.go.package = pkgs.unstable.go;

  programs.alacritty.settings = {
    font.normal.family = "CaskaydiaCove Nerd Font Mono";
    font.bold.family = "CaskaydiaCove Nerd Font Mono";
    font.italic.family = "CaskaydiaCove Nerd Font Mono";
    font.bold_italic.family = "CaskaydiaCove Nerd Font Mono";
  };

  programs.lsd.enable = true;
}
