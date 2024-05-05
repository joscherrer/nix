local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    'saadparwaiz1/cmp_luasnip',
    {
        'L3MON4D3/LuaSnip',
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
        },
        config = function()
            require('bbrain.cmp')
        end,
    },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp',             lazy = false },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            require('bbrain.lsp')
        end
    },
    'mbbill/undotree',
    'rcarriga/nvim-notify',
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot" },
        event = { "InsertEnter" },
        lazy = true,
        config = function()
            vim.notify("Starting copilot.lua")
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                },
            })
            vim.notify("copilot.lua started", vim.log.levels.INFO)
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
        'natecraddock/workspaces.nvim',
        config = function()
            require('workspaces').setup({
                hooks = {
                    open_pre = {
                        "SessionsStop",
                        "silent %bdelete!",
                    },
                    open = function()
                        require('sessions').load(nil, { silent = true })
                    end,
                },
            })
        end
    },
}

local opts = {}

require("lazy").setup(plugins, opts)
