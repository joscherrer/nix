{ inputs, lib, pkgs, config, outputs, ... }:
{
  programs.go.enable = true;
  programs.go.package = pkgs.go;

  home.packages = with pkgs; [
    unstable.gopls
    unstable.go-outline
  ];
}
