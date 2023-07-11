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
    stateVersion = lib.mkDefault "22.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    niv
  ];
}
