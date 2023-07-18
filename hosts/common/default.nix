{ self, inputs, outputs, config, pkgs, lib, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    vim
    neovim
    curl
    wget
    python3
    pypy3
    pciutils
    git
  ];

  time.timeZone = "Europe/Paris";

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  # On Darwin, replace /etc/zshrc with
  #   if test -e /etc/static/zshrc; then source /etc/static/zshrc; fi
  # And change the default shell with
  #   sudo dscl . -create /Users/jscherrer UserShell /run/current-system/sw/bin/zsh
  programs.zsh.enable = true;
  programs.zsh.promptInit = "autoload -U promptinit && promptinit";

  users.users.jscherrer = {
    openssh.authorizedKeys.keys =
      let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/joscherrer.keys";
          hash = "sha256-gWAWZKicQVi9H4xCGiMQHauiUN34CBMYhJgBem5qunI=";
        };
      in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
}
