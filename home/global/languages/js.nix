{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # JS/TS
    nodejs
    # nodePackages.typescript
    yarn
    prettier
    typescript
    typescript-language-server
    unstable.tailwindcss-language-server
    # unstable.vue-language-server
    vtsls
  ];
}
