{ pkgs, ... }:
let
  nvim-remote = pkgs.writeShellScriptBin "nvim-remote" ''
    ssh -L 6666:localhost:6666 bbrain-linux nvim --headless --listen localhost:6666 --cmd "let g:neovide = v:true" &
    proc=$!

    neovide --server localhost:6666

    kill $proc
  '';
in
rec {
  home.packages = [
    nvim-remote
  ];

}
