vim.keymap.set("n", "<leader>te", require("bbrain.helpers").toggle_nvimtree)
-- vim.keymap.set("n", "<leader>te", vim.cmd.NvimTreeToggle)

-- split navigation
vim.keymap.set("n", "<leader>hh", '<C-w>h', { desc = "Move to left split" })
vim.keymap.set("n", "<leader>jj", '<C-w>j', { desc = "Move to bottom split" })
vim.keymap.set("n", "<leader>kk", '<C-w>k', { desc = "Move to top split" })
vim.keymap.set("n", "<leader>ll", '<C-w>l', { desc = "Move to right split" })

vim.keymap.set("n", "<leader>vv", '<C-w>v', { desc = "Create new vertical split" })
vim.keymap.set("n", "<leader>ss", '<C-w>s', { desc = "Create new horizontal split" })

vim.keymap.set("n", "<leader>qq", '<C-w>q', { desc = "Close split" })

-- page up/down keep centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up (centered)" })

vim.keymap.set("n", "<PageDown>", "<C-d>zz", { desc = "Page down (centered)" })
vim.keymap.set("n", "<PageUp>", "<C-u>zz", { desc = "Page up (centered)" })

-- next/prev match keep centered
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Mouse forward/backward
vim.keymap.set({ "n", "i", "v", "t" }, "<X1Mouse>", "<C-O>", { desc = "Go forward", noremap = true })
vim.keymap.set({ "n", "i", "v", "t" }, "<X2Mouse>", "<C-I>", { desc = "Go backward", noremap = true })
for i = 2, 4 do
    vim.keymap.set({ "n", "i", "v", "t" }, "<" .. i .. "-X1Mouse>", "<C-O>", { desc = "Go forward", noremap = true })
    vim.keymap.set({ "n", "i", "v", "t" }, "<" .. i .. "-X2Mouse>", "<C-I>", { desc = "Go backward", noremap = true })
end

-- ??
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard (normal)" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to system clipboard (visual)" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank to system clipboard (normal)" })

-- Quit all
vim.keymap.set("n", "QQ", function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal" then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
    vim.cmd(":wqall<CR>")
end, { desc = "Save and quit all" })


-- Save
vim.keymap.set({ "n", "i" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save" })

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


-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", noremap = true, silent = true })

-- Search, and replace
vim.keymap.set("n", "<C-f>", "/\\V", { desc = "Search" })
vim.keymap.set("n", "<C-h>", ":s/\\v", { desc = "Search and replace" })

-- Use <Esc> in normal mode
vim.keymap.set("n", "<Esc>",
    function()
        vim.api.nvim_set_option_value("hlsearch", false, {})
        if vim.g.smart_resize_mode == true then
            require('smart-splits.resize-mode').end_resize_mode()
        end
        require("notify").dismiss()
        require("nvim-tree.api").tree.close()
        vim.cmd.echo()
    end,
    { desc = "Clear search highlights, dismiss notifications" }
)

vim.keymap.set("n", "<leader>db", function()
    local cmp = require("cmp.utils.debug")
    if cmp.flag then
        cmp.flag = false
    else
        cmp.flag = true
    end
end)
