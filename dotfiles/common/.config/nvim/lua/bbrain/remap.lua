vim.keymap.set("n", "<leader>te", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>hh", '<C-w>h')
vim.keymap.set("n", "<leader>jj", '<C-w>j')
vim.keymap.set("n", "<leader>kk", '<C-w>k')
vim.keymap.set("n", "<leader>ll", '<C-w>l')
vim.keymap.set("n", "<leader>vv", '<C-w>v')
vim.keymap.set("n", "<leader>ss", '<C-w>s')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
