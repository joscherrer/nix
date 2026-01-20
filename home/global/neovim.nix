{
  self,
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
let
  sqlite-lib = if pkgs.stdenv.isDarwin then "libsqlite3.dylib" else "libsqlite3.so";
in
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
  xdg.configFile."nvim/lua/nix/sqlite.lua" = {
    text = "vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/${sqlite-lib}'";
  };

  home.packages = [
    pkgs.neovide
    pkgs.gcc
    pkgs.unzip
    pkgs.lua-language-server
    pkgs.copilot-language-server
    # Needed for smart-open plugin
    pkgs.sqlite
  ];
}
