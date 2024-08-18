local function lspconfig_config()
    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = "LSP: Open floating diagnostics" })
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { desc = "LSP: Go to previous diagnostic" })
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { desc = "LSP: Go to next diagnostic" })

    local helpers = require('bbrain.helpers')

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local palette = require('bbrain.palette')
            palette.add("LSP", "LSPHover", {
                cmd = { name = "vim.lsp.buf.hover()", cmd = function() vim.lsp.buf.hover() end },
                keys = { { mode = "n", lhs = "<S-k>", opts = { buffer = event.buf } } },
                desc = "LSP: Display hover information about symbol"
            })
            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
                { buffer = event.buf, desc = "LSP: Display hover information about symbol" })
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
                { buffer = event.buf, desc = "LSP: Show definition" })
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
                { buffer = event.buf, desc = "LSP: Show declaration" })
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>',
                { buffer = event.buf, desc = "LSP: Show implementation" })
            vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>',
                { buffer = event.buf, desc = "LSP: Show type definition" })
            vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>',
                { buffer = event.buf, desc = "LSP: Show signature help" })
            vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end,
                { buffer = event.buf, desc = "LSP: Show signature help" })
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',
                { buffer = event.buf, desc = "LSP: Rename" })
            vim.keymap.set({ 'n', 'x' }, '<F3>', function() helpers.format(event.buf) end,
                { buffer = event.buf, desc = "Format document" })
            vim.keymap.set({ 'n', 'x' }, 'gq', function() helpers.format(event.buf) end,
                { buffer = event.buf, desc = "Format document" })
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',
                { buffer = event.buf, desc = "LSP: Code action" })
            vim.keymap.set('n', 'gr', '<cmd>Trouble lsp_references<cr>',
                { buffer = event.buf, desc = "LSP: Show references" })
        end
    })

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    local default_setup = function(server)
        require('lspconfig')[server].setup({
            capabilities = lsp_capabilities,
        })
    end

    local lsp_server_list = {
        'bashls',
        'helm_ls',
        'tflint',
        'ansiblels',
        'yamlls',
    }

    if not vim.env.JFROG_IDE_URL then
        table.insert(lsp_server_list, 'gopls')
        table.insert(lsp_server_list, 'volar')
    else
        table.insert(lsp_server_list, 'basedpyright')
        table.insert(lsp_server_list, 'marksman')
        table.insert(lsp_server_list, 'terraformls')
    end

    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = lsp_server_list,
        handlers = {
            default_setup,
        }
    })

    local lspconfig = require('lspconfig')

    if not vim.env.JFROG_IDE_URL then
        lspconfig.gopls.setup({
            cmd = { 'gopls' },
            capabilities = lsp_capabilities,
            settings = {
                gopls = {
                    experimentalPostfixCompletions = true,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
            init_options = {
                usePlaceholders = true,
            },
            on_attach = function(client, _)
                client.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
            end
        })
    end

    lspconfig.nil_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
            ['nil'] = {
                nix = {
                    flake = {
                        autoArchive = true,
                    }
                },
            },
        },
    })

    lspconfig.lua_ls.setup({
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT'
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                }
            })
        end,
        settings = {
            Lua = {}
        }
    })

    lspconfig.volar.setup({
        filetypes = { 'vue' }
    })

    lspconfig.terraformls.setup({})
    lspconfig.marksman.setup({})
    lspconfig.basedpyright.setup({
        on_init = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
        end,
    })

    vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
    vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
    vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })

    vim.diagnostic.config({ virtual_text = false })
    local signs = {
        DiagnosticSignError = {
            texthl = "DiagnosticSignError",
            text = ''
        },
        DiagnosticSignWarn = {
            texthl = "DiagnosticSignWarn",
            text = " ",
        },
        DiagnosticSignHint = {
            texthl = "DiagnosticSignHint",
            text = " "
        },
        DiagnosticSignInformation = {
            texthl = "DiagnosticSignInformation",
            text = " "
        },
        DapBreakpoint = {
            texthl = "DebugBreakpoint",
            text = ""
        }
    }
    for hl, sign in pairs(signs) do
        vim.fn.sign_define(hl, sign)
    end
end

return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = function()
            local download_url_template
            if vim.env.JFROG_IDE_URL then
                download_url_template = vim.env.JFROG_IDE_URL .. "/artifactory/github/%s/releases/download/%s/%s"
            else
                download_url_template = "https://github.com/%s/releases/download/%s/%s"
            end
            require('mason').setup({
                providers = {
                    "mason.providers.client",
                    "mason.providers.registry-api",
                },
                github = {
                    download_url_template = download_url_template,
                },
            })
        end,
    },
    {
        'L3MON4D3/LuaSnip',
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    { 'saadparwaiz1/cmp_luasnip' },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp',             lazy = false },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = lspconfig_config
    },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        },
        config = function()
            -- local lsp_zero = require('lsp-zero')
            -- lsp_zero.extend_cmp()

            local cmp = require('cmp')

            cmp.setup({
                -- formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'luasnip' },
                    { name = 'nvim_lsp_signature_help' },
                }, {
                    -- { name = 'copilot' },
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
            vim.keymap.set('c', '<C-y>', cmp.mapping.confirm({ select = true }))
        end
    },
}
