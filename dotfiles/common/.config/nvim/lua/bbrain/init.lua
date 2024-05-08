vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })
vim.api.nvim_create_autocmd('VimResized', {
    group = wr_group,
    pattern = '*',
    command = 'wincmd =',
    desc = 'Automatically resize windows when the host window size changes.',
})

vim.opt.termguicolors = true -- required before starting nvim-notify
require("bbrain.lazy")
require("bbrain.helpers")
require("bbrain.set")
require("bbrain.remap")
