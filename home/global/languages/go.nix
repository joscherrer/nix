{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  programs.go.enable = true;
  programs.go.package = pkgs.unstable.go;

  home.packages = with pkgs; [
    unstable.gopls
    go-outline
    delve
    go-task
  ];
}
