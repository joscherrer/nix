{ lib, pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./tmux.nix
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

  news.display = "silent";
  news.json = lib.mkForce { };
  news.entries = lib.mkForce [ ];

  programs.home-manager.enable = true;
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
    cargo
    lua
    htop
  ];
}
