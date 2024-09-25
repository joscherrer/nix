{ inputs, lib, pkgs, config, outputs, ... }:
{
  programs.go.enable = true;
  programs.go.package = pkgs.go;

  home.packages = with pkgs; [
    gopls
    go-outline
    delve
  ];
}
