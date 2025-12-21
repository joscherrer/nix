{ lib, pkgs, ... }:
let
  delta-themes = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/dandavison/delta/refs/heads/main/themes.gitconfig";
    sha256 = "sha256:1pkqd36ls3cc6xgycd6sawpnwvgbchs54dkgg007algkhqxv7wch";
  };
in
{
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./tmux.nix
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      syntax-theme = "TwoDark";
      diff-args = "-U999";
    };
  };

  programs.git = {
    enable = true;
    includes = [
      { path = delta-themes; }
    ];
    settings = {
      user.name = "Jonathan Scherrer";
      user.email = lib.mkDefault "jonathan.s.scherrer@gmail.com";
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
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
    bat
    yq-go
    dasel
    fd
    ripgrep
    tmux
    pgcli
    mongosh
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
    dust
    findutils
    xdg-utils
    dig
    tcpdump
    pinentry-curses
    lua51Packages.lua # required for nvim-dap-python
    lua51Packages.luarocks # required for nvim-dap-python
    htop
    hclfmt
    scalr-cli
    openssl
    urlencode
    rclone
    zip
  ];
}
