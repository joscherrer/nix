{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  home = {
    stateVersion = lib.mkDefault "23.05";
  };

  programs.home-manager.enable = true;
  programs.go.enable = true;
  programs.go.package = pkgs.unstable.go;
  programs.lsd.enable = true;

  programs.keychain.enable = true;
  services.gnome-keyring.enable = true;

  home.packages = with pkgs; [
    # Shell utilities
    coreutils
    socat
    curl
    git
    delta
    jq
    fd
    yq-go
    ripgrep
    tmux
    pgcli
    gnupg
    shellcheck
    cht-sh
    fzf
    pure-prompt
    unzip
    httpie
    curlie
    procs
    bottom
  
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
  ];
}
