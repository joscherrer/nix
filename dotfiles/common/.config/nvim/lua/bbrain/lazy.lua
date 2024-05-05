local plugins = {
    'wbthomason/packer.nvim',
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
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            local cmp = require('cmp')

            cmp.setup({
                preselect = 'item',
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'luasnip' },
                }, {
                    { name = 'copilot' },
                    { name = 'buffer' },
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
                matching = { disallow_symbol_nonprefix_matching = false }
            })
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
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()


            local luasnip = require('luasnip')

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({
                    buffer = bufnr,
                })
                lsp_zero.buffer_autoformat()
                local opts = { buffer = bufnr }
                vim.keymap.set({ 'n', 'x' }, 'gq',
                    function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'pyright',
                    -- 'pylsp',
                    -- 'lua_ls',
                    'bashls',
                    'gopls',
                    'helm_ls',
                    'marksman',
                    'tflint',
                    'ansiblels',
                    'yamlls',
                    'volar'
                },
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,

                    -- this is the "custom handler" for `lua_ls`
                    lua_ls = function()
                        -- (Optional) Configure lua language server for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                    gopls = function()
                        require('lspconfig').gopls.setup({
                            cmd = { 'gopls' },
                            -- on_attach = on_attach,
                            capabilities = require('cmp_nvim_lsp').default_capabilities(),
                            settings = {
                                gopls = {
                                    experimentalPostfixCompletions = true,
                                    analyses = {
                                        unusedparams = true,
                                        shadow = true,
                                    },
                                    staticcheck = true,
                                },
                            },
                            init_options = {
                                usePlaceholders = true,
                            }
                        })
                    end,
                }
            })
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
