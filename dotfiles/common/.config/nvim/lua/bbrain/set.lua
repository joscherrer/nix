vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undodir = vim.fn.stdpath('data') .. "/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true


vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.opt.clipboard = "unnamedplus"

vim.o.pumheight = 12

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.g.default_winblend = 100

-- vim.opt.shortmess = "ltToOCFW"

if vim.g.neovide then
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_refresh_rate = 120
    vim.g.neovide_floating_blur_amount_x = 10.0
    vim.g.neovide_floating_blur_amount_y = 10.0
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5
    vim.g.neovide_scroll_animation_length = 0.22
    vim.o.guifont = "CaskaydiaCove Nerd Font Mono"
    vim.g.default_winblend = 20
    -- vim.g.neovide_transparency = 0
end
