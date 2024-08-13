{ pkgs ? import <nixpkgs> { }}:
{
  zsh-history-substring-search = pkgs.callPackage ./zsh-history-substring-search { };
  zsh-autosuggestions = pkgs.callPackage ./zsh-autosuggestions { };
  nvchad = pkgs.callPackage ./nvchad { };
  ankama-launcher = pkgs.callPackage ./ankama-launcher { };
}
