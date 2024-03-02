{ self, inputs, lib, pkgs, config, outputs, ... }:
{
  programs.neovim = {
    enable = true;
  };

  # xdg.configFile.nvim = {
  #   enable = false;
  #   source = pkgs.nvchad;
  #   recursive = true;
  # };

  # xdg.configFile.nvim = {
  #   source = "${inputs.self}/dotfiles/common/.config/nvim";
  #   recursive = true;
  # };

  home.packages = [
    # Needed for NvChad
    pkgs.gcc
    pkgs.unzip
  ];
}
