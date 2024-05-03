vim.keymap.set("n", "<leader>te", vim.cmd.NvimTreeToggle)

-- move between splits
vim.keymap.set("n", "<leader>hh", '<C-w>h')
vim.keymap.set("n", "<leader>jj", '<C-w>j')
vim.keymap.set("n", "<leader>kk", '<C-w>k')
vim.keymap.set("n", "<leader>ll", '<C-w>l')

-- create new split (Vertical, Shorizontal)
vim.keymap.set("n", "<leader>vv", '<C-w>v')
vim.keymap.set("n", "<leader>ss", '<C-w>s')

-- close split
vim.keymap.set("n", "<leader>qq", '<C-w>q')

-- move lines up/down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")     -- move line up(n)
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")       -- move line down(n)
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv") -- move line up(v)
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")   -- move line down(v)

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")        -- move line up(n)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")        -- move line down(n)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")    -- move line up(v)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")    -- move line down(v)

-- page up/down keep centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<PageDown>", "<C-d>zz")
vim.keymap.set("n", "<PageUp>", "<C-u>zz")

-- next/prev match keep centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- ??
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
