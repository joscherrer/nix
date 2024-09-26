{ pkgs, ... }:
{
  home.packages = with pkgs; [
    niv
    nil
    nixfmt-rfc-style
  ];
}
