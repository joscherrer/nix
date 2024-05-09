local plugins = {
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
    },
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
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot" },
        event = { "InsertEnter" },
        lazy = true,
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
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
        'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup()
        end,
    },
    {
        'rcarriga/nvim-notify',
        priority = 999,
        config = function()
            require('notify').setup({
                render = "wrapped-compact",
            })
            vim.notify = require('notify')
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
    { import = "plugins" },
}

local opts = {}

require("lazy").setup(plugins, opts)
