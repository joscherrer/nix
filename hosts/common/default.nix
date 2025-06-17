{
  self,
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    vim
    neovim
    curl
    wget
    pciutils
    git
    virt-manager
  ];

  time.timeZone = "Europe/Paris";

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      substituters = [ "https://cache.nixos.org/" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  # home-manager = {
  #   pkgs = pkgs // outputs.packages.${config.system};
  # };

  # On Darwin, replace /etc/zshrc with
  #   if test -e /etc/static/zshrc; then source /etc/static/zshrc; fi
  # And change the default shell with
  #   sudo dscl . -create /Users/jscherrer UserShell /run/current-system/sw/bin/zsh
  programs.zsh.enable = true;
  programs.zsh.promptInit = "autoload -U promptinit && promptinit";

  # programs.starship = {
  #   enable = true;
  #   presets = ["pure-preset"];
  # };

  users.users.jscherrer = {
    openssh.authorizedKeys.keys =
      let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/joscherrer.keys";
          hash = "sha256-do86BT7VmTlQDRXoPgnUORTH56axo8UroQLDcP52lgE=";
        };
      in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };

}
