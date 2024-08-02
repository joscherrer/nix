vim.keymap.set("n", "<leader>te", vim.cmd.NvimTreeToggle)

-- split navigation
vim.keymap.set("n", "<leader>hh", '<C-w>h', { desc = "Move to left split" })
vim.keymap.set("n", "<leader>jj", '<C-w>j', { desc = "Move to bottom split" })
vim.keymap.set("n", "<leader>kk", '<C-w>k', { desc = "Move to top split" })
vim.keymap.set("n", "<leader>ll", '<C-w>l', { desc = "Move to right split" })

vim.keymap.set("n", "<leader>vv", '<C-w>v', { desc = "Create new vertical split" })
vim.keymap.set("n", "<leader>ss", '<C-w>s', { desc = "Create new horizontal split" })

vim.keymap.set("n", "<leader>qq", '<C-w>q', { desc = "Close split" })

vim.keymap.set("n", "<leader>mm", vim.cmd.Maximize, { desc = "Maximize split" })

-- move lines up/down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line up(n)" })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line down(n)" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line up(v)" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line down(v)" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "move line up(n)}" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "move line down(n)" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "move line up(v)" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "move line down(v)" })

-- page up/down keep centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up (centered)" })

vim.keymap.set("n", "<PageDown>", "<C-d>zz", { desc = "Page down (centered)" })
vim.keymap.set("n", "<PageUp>", "<C-u>zz", { desc = "Page up (centered)" })

-- next/prev match keep centered
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- ??
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard (normal)" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to system clipboard (visual)" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank to system clipboard (normal)" })

-- Quit all
vim.keymap.set("n", "QQ", ":wqall<CR>", { desc = "Save and quit all" })


-- Save
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save" })

vim.keymap.set("n", "<C-A-r>", ":so<CR>", { desc = "Reload config" })

-- Invert vaquote and vi2quote
vim.keymap.set("o", "a'", "2i'", { noremap = true })
vim.keymap.set("o", "2i'", "a'", { noremap = true })
vim.keymap.set("o", 'a"', '2i"', { noremap = true })
vim.keymap.set("o", '2i"', 'a"', { noremap = true })

vim.keymap.set("x", "a'", "2i'", { noremap = true })
vim.keymap.set("x", "2i'", "a'", { noremap = true })
vim.keymap.set("x", 'a"', '2i"', { noremap = true })
vim.keymap.set("x", '2i"', 'a"', { noremap = true })

-- Indent/Dedent but keep selection
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })


-- Overseer
vim.keymap.set("n", "<leader>or", ":OverseerRun<CR>", { desc = "Run overseer" })
vim.keymap.set("n", "<leader>ot", ":OverseerToggle<CR>", { desc = "Toggle overseer" })

-- UndoTree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })


-- Home/End
vim.keymap.set({ "n", "i", "v", "x", "o" }, "<Home>", function()
    local current_col = vim.api.nvim_win_get_cursor(0)[2]
    if current_col == 0 then
        return
    end
    vim.cmd("normal! ^")
    if current_col == vim.api.nvim_win_get_cursor(0)[2] then
        vim.cmd("normal! 0")
    end
end, { desc = "Go to first non-whitespace character or beginning of line" })
