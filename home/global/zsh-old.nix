{ inputs, lib, pkgs, config, outputs, ... }:
let
  relativeTo = path: other: builtins.unsafeDiscardStringContext (lib.strings.removePrefix other path);
  common-root = "${inputs.self}/dotfiles/common";
  common-zsh = lib.filesystem.listFilesRecursive "${common-root}/.config/zsh";
  common-zsh-map = builtins.map
    (
      f: {
        "${(relativeTo f "${common-root}/")}" = {
          source = f;
        };
      }
    )
    common-zsh;
in
{
  home.file = builtins.foldl' (a: b: a // b)
    {
      ".zshrc" = {
        source = "${common-root}/.zshrc";
      };
      ".config/zsh/nix_plugins.zsh" = {
        text = ''
          prompt pure
          source ${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh
          source ${pkgs.zsh-autosuggestions}/${pkgs.zsh-autosuggestions.entrypoint}
          source ${pkgs.zsh-history-substring-search}/${pkgs.zsh-history-substring-search.entrypoint}
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          source ${pkgs.fzf}/share/fzf/completion.zsh
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        '';
      };
    }
    common-zsh-map;

  programs.zsh.enable = true;
  programs.zsh.dotDir = ".config/zsh-nix";

  home.packages = with pkgs; [
    pure-prompt
    zsh-z
    zsh-syntax-highlighting
    fzf
  ];
}
