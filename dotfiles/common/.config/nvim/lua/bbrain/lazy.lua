local plugins = {
    { import = "plugins" },
    {
        'mbbill/undotree',
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
    {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup({})
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        'natecraddock/sessions.nvim',
        config = function()
            require('sessions').setup({
                events = { "BufEnter", "VimLeavePre", "DirChangedPre" },
                session_filepath = vim.fn.stdpath('data') .. '/sessions/',
                absolute = true,
            })
        end,
    },
    {
        'stevearc/overseer.nvim',
        opts = {},
        config = function()
            require('overseer').setup({
                task_list = {
                    direction = "bottom",
                },
            })
        end,
    },
    {
        'danielfalk/smart-open.nvim',
        branch = "0.2.x",
        config = function()
            if vim.fn.filereadable(vim.fn.stdpath('config') .. '/lua/nix/sqlite.lua') then
                require('nix.sqlite')
            end
            require('telescope').load_extension('smart_open')
        end,
        dependencies = { "kkharji/sqlite.lua" },
    },
}

local opts = {}

require("lazy").setup(plugins, opts)
