vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
}

if vim.uv.os_uname().sysname == "Windows_NT" then
    for option, value in pairs(powershell_options) do
        vim.opt[option] = value
    end
end


vim.opt.termguicolors = true -- required before starting nvim-notify
if vim.g.neovide then        -- required before loading plugins
    vim.g.default_winblend = 20
end
require("bbrain.lazy")
-- require("bbrain.helpers")
require("bbrain.set")
require("bbrain.remap")
require("bbrain.autocmd")
require("bbrain.hlsearch")
require("bbrain.palette")
require("bbrain.lsp")
