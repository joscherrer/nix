{ self, inputs, outputs, config, pkgs, lib, ... }:
{
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
    virt-manager
  ];

  time.timeZone = "Europe/Paris";

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      auto-optimise-store = true;
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
          hash = "sha256-DzQgOXzIYGUtUzAl73YVRs4F2Kh8hoORl9eIP52lxac=";
        };
      in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };

}
