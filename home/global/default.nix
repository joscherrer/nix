{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    ./zsh.nix
    ./vscode.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    # overlays = builtins.attrValues outputs.overlays;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  home = {
    username = lib.mkDefault "jscherrer";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    niv
  ];
}
