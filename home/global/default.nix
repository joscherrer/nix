{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./tmux.nix
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
  programs.gpg = {
    enable = true;
    package = pkgs.gnupg;
  };

  home.file = {
    ".local/opt/jdk8".source = pkgs.jdk8;
    ".local/opt/jdk11".source = pkgs.jdk11;
    ".local/opt/jdk17".source = pkgs.jdk17;
    ".local/opt/jdk21".source = pkgs.jdk21;
  };

  home.packages = with pkgs; [
    # Shell utilities
    coreutils
    socat
    curl
    git
    delta
    jq
    bat
    yq-go
    dasel
    fd
    ripgrep
    tmux
    pgcli
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
    dig
    tcpdump
    pinentry-curses
    # bitwarden-cli
    cargo
    lua

    # IaC/Cloud
    terraform
    packer
    ansible
    ansible-lint
    hcloud
    google-cloud-sdk
    gh
    scaleway-cli
    s3cmd
    awscli2
    fluxcd
    vault-bin
    stable.open-policy-agent
    ibmcloud-cli

    # Containers
    podman-compose
    dive
    kustomize
    kubectl
    kubectx
    kubelogin-oidc
    kind
    stable.hadolint
    kubernetes-helm
    helm-docs
    kubernetes-helmPlugins.helm-diff
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
    gradle
    maven
    kotlin
    kotlin-native
    kotlin-language-server

    # Python
    (python3.withPackages (ps: with ps; [
      flake8
      ruamel-yaml
      requests
      toml
      types-toml
      sh
    ]))
    black
    mypy
    # python311Packages.virtualenv


    # Nix
    niv
    inputs.nil.packages.${pkgs.system}.nil

    # Dev misc
    openapi-generator-cli
    caddy
    termscp

  ];
}
