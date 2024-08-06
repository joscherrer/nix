local plugins = {
    { import = "plugins" },
    {
        'mbbill/undotree',
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
    { 'kylechui/nvim-surround', opts = {} },
    { 'numToStr/Comment.nvim',  opts = {} },
    { 'windwp/nvim-autopairs',  event = "InsertEnter", opts = {} },
    {
        'danielfalk/smart-open.nvim',
        branch = "0.2.x",
        config = function()
            if vim.fn.filereadable(vim.fn.stdpath('config') .. '/lua/nix/sqlite.lua') ~= 0 then
                require('nix.sqlite')
            elseif vim.fn.filereadable('/usr/lib/x86_64-linux-gnu/libsqlite3.so') ~= 0 then
                vim.g.sqlite_clib_path = '/usr/lib/x86_64-linux-gnu/libsqlite3.so'
            end
            require('telescope').load_extension('smart_open')
        end,
        dependencies = { "kkharji/sqlite.lua" },
    },
    {
        'folke/trouble.nvim',
        opts = {
            focus = true,
            warn_no_results = false,
            open_no_results = true,
        }, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        'nvim-pack/nvim-spectre',
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = false },
        },
        keys = {
            { "<leader>S",  "<cmd>lua require('spectre').toggle()<CR>",                             mode = "n", desc = "Toggle Spectre" },
            { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",      mode = "n", desc = "Search current word" },
            { "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<CR>",                   mode = "v", desc = "Search current word" },
            { "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", mode = "n", desc = "Search on current file" },
        },
        opts = {
            use_trouble_qf = true,
            live_update = true,
        },
    },
    {
        "akinsho/toggleterm.nvim",
        opts = {},
        keys = {
            { "<C-`>", function() require("toggleterm").toggle() end, mode = { "n", "v", "i", "t" }, desc = "Toggle Terminal" }
        }
    },
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        },
        opts = {},
    }
}

local opts = {}

require("lazy").setup(plugins, opts)
