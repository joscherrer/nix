" Vim filetype plugin
" Language: nix
" Maintainer: Janno Tjarks (jonathan@bbrain.io)
" Last Change: 2024 Sept 26

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=#\ %s
setlocal comments=:#

let b:undo_ftplugin = "setlocal commentstring< comments<"
