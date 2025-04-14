{ pkgs, ... }:
let
  nvim-remote = pkgs.writeShellScriptBin "nvim-remote" ''
    #!/bin/sh
    p=
    for i in $(seq 1 5); do
      p=$((6665 + i))
      pgrep -f "neovide.*$p" || break
    done

    neovide --server "192.168.1.175:$p"
  '';
in
rec {
  home.packages = [
    nvim-remote
  ];

  home.file.".local/share/applications/neovide-remote.desktop".text = ''
    [Desktop Entry]
    Name=Neovide (Home)
    Type=Application
    Exec=nvim-remote
    Icon=neovide
    Keywords=Text;Editor;
    Categories=Utility;TextEditor;
    Comment=No Nonsense Neovim Client in Rust
    MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
  '';
}
