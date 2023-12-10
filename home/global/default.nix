{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
    ../../lib
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

  xdg.enable = true;

  programs.home-manager.enable = true;
  programs.go.enable = true;
  programs.go.package = pkgs.go;
  programs.lsd.enable = true;
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.config = {
    global = {
      load_dotenv = true;
    };
    whitelist = {
      prefix = [
        "/home/jscherrer/dev"
        "/Users/jscherrer/dev"
      ];
    };
  };

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
    age
    sops
    cmake
    gnumake
    jwt-cli
    gettext
    argbash
    du-dust
    findutils
    xdg-utils

    # IaC/Cloud
    terraform
    packer
    vagrant
    ansible
    ansible-lint
    hcloud
    google-cloud-sdk
    gh
    scaleway-cli
    fluxcd
    vault-bin
    stable.open-policy-agent
    ibmcloud-cli

    # Containers
    podman-compose
    dive
    buildah
    kustomize
    kubectl
    kubectx
    kubelogin-oidc
    kind
    stable.hadolint
    kubernetes-helm
    kubetail
    k9s
    # kubie

    # JS/TS
    unstable.nodejs
    nodePackages.typescript
    yarn

    # Golang
    unstable.gopls
    unstable.go-outline

    # Java
    openjdk19
    gradle
    maven
    kotlin
    kotlin-native
    kotlin-language-server

    # Nix
    niv
    rnix-lsp

    # Dev misc
    openapi-generator-cli
    caddy
    termscp

  ];
}
