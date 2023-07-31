{ self, inputs, lib, pkgs, config, outputs, ... }:
{
  programs.neovim = {
    enable = true;
  };

  xdg.configFile.nvim = {
    enable = true;
    source = pkgs.nvchad;
    recursive = true;
  };

  home.packages = [
    # Needed for NvChad
    pkgs.gcc
    pkgs.unzip
  ];
}
