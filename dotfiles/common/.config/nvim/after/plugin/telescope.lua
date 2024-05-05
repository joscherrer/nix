local telescope = require('telescope')
local builtin = require('telescope.builtin')
telescope.setup({
    defaults = {
        file_ignore_patterns = {
            ".git/"
        }
    },
    pickers = {
        find_files = {
            hidden = true
        },
        live_grep = {
            hidden = true,
            additional_args = { "--hidden", "--iglob", "!.git" },
        }
    },
    extensions = {
        extensions = {
            workspaces = {
                -- keep insert mode after selection in the picker, default is false
                keep_insert = true,
            }
        }
    }
})
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- vim.keymap.set('n', '<leader>ps', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }); end)
vim.keymap.set('n', '<leader>ps', builtin.grep_string, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pc', builtin.commands, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>pw', telescope.extensions.workspaces.workspaces, {})
