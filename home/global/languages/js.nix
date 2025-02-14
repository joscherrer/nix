{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # JS/TS
    nodejs
    # nodePackages.typescript
    yarn
    nodePackages.prettier
    typescript
    typescript-language-server
  ];
}
