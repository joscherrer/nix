" Vim indent file
" Language:    nix
" Maintainer:  Jonathan Scherrer
" Upstream:
" Last Change: 2024-09-26

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent shiftwidth=2 tabstop=2 softtabstop=2 expandtab
setlocal indentexpr=nix#indentexpr(v:lnum)
setlocal indentkeys+=0=},0=)

let b:undo_indent = 'setlocal ai< sw< ts< sts< et< inde< indk<'
