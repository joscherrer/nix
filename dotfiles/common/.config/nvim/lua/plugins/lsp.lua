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
                keys = {
                    { mode = "n",          lhs = "<S-k>", opts = { buffer = event.buf } },
                    { mode = { "n", "i" }, lhs = "<C-k>", opts = { buffer = event.buf } },
                },
                desc = "LSP: Display hover information about symbol"
            })


            -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
            --     { buffer = event.buf, desc = "LSP: Display hover information about symbol" })
            -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
            --     { buffer = event.buf, desc = "LSP: Show definition" })
            vim.keymap.set('n', 'gd', function() require('trouble').toggle({ mode = 'lsp_definitions' }) end,
                { buffer = event.buf, desc = "LSP: Show definition" })
            vim.keymap.set('n', 'gD', function() require('trouble').toggle({ mode = 'lsp_declarations' }) end,
                { buffer = event.buf, desc = "LSP: Show declaration" })
            vim.keymap.set('n', 'gi', function() require('trouble').toggle({ mode = 'lsp_implementations' }) end,
                { buffer = event.buf, desc = "LSP: Show implementation" })
            vim.keymap.set('n', 'go', function() require('trouble').toggle({ mode = 'lsp_type_definitions' }) end,
                { buffer = event.buf, desc = "LSP: Show type definition" })
            vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end,
                { buffer = event.buf, desc = "LSP: Show signature help" })
            vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end,
                { buffer = event.buf, desc = "LSP: Show signature help" })
            vim.keymap.set('n', 'gr', function() require('trouble').toggle({ mode = 'lsp_references' }) end,
                { buffer = event.buf, desc = "LSP: Show references" })
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',
                { buffer = event.buf, desc = "LSP: Rename" })
            vim.keymap.set({ 'n', 'x' }, '<F3>', function() helpers.format(event.buf) end,
                { buffer = event.buf, desc = "Format document" })
            vim.keymap.set({ 'n', 'x' }, 'gq', function() helpers.format(event.buf) end,
                { buffer = event.buf, desc = "Format document" })
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',
                { buffer = event.buf, desc = "LSP: Code action" })
        end
    })

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    lsp_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
    }

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
        table.insert(lsp_server_list, 'ts_ls')
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
    vim.lsp.client.offset_encoding = 'utf-8'

    if not vim.env.JFROG_IDE_URL then
        local go_lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        go_lsp_capabilities = vim.tbl_deep_extend('force', go_lsp_capabilities, {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true
                }
            }
        })

        lspconfig.gopls.setup({
            cmd = { 'gopls' },
            capabilities = go_lsp_capabilities,
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
                formatting = {
                    command = { "nixfmt" }
                },
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
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT'
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        "${3rd}/luv/library",
                        vim.fn.stdpath('config') .. '/lua/lib',
                        -- vim.fn.stdpath('data') .. '/lazy',
                        -- vim.fn.stdpath('data') .. '/lazy/noice.nvim',
                    }
                }
            })
        end,
        settings = {
            Lua = {}
        }
    })


    lspconfig.terraformls.setup({})
    lspconfig.marksman.setup({})
    lspconfig.jsonnet_ls.setup({})
    lspconfig.basedpyright.setup({
        on_init = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
        end,
    })
    lspconfig.csharp_ls.setup({})

    lspconfig.yamlls.setup({
        capabilities = vim.tbl_deep_extend('force', lsp_capabilities, {
            workspace = {
                didChangeConfiguration = {
                    dynamicRegistration = true
                }
            }
        }),
        on_attach = require('bbrain.lsp.yamlls').on_attach,
        settings = {
            yaml = {
                format = {
                    enable = true
                },
                completion = {
                    enable = true
                },
            }
        }
    })

    -- local mason_registry = require('mason-registry')
    -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
    --     '/node_modules/@vue/language-server'

    lspconfig.ts_ls.setup({
        capabilities = lsp_capabilities,
        -- init_options = {
        --     plugins = {
        --         {
        --             name = "@vue/typescript-plugin",
        --             location = vue_language_server_path,
        --             languages = { "vue" },
        --         }
        --     }
        -- }
    })

    lspconfig.eslint.setup({
        capabilities = lsp_capabilities
    })

    local js = require('bbrain.lsp.js')
    js.setup()

    local dart = require('bbrain.lsp.dart')
    dart.setup()

    vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
    vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
    vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })

    vim.diagnostic.config({ virtual_text = false })
    local signs = {
        DapBreakpoint = {
            texthl = "DebugBreakpoint",
            text = ""
        }
    }

    for hl, sign in pairs(signs) do
        vim.fn.sign_define(hl, sign)
    end

    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            }
        }
    })
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
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets/vscode' } })
            require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath('config') .. '/snippets/lua' } })
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
            local luasnip = require('luasnip')

            cmp.setup({
                completion = {
                    autocomplete = {
                        "TextChanged"
                    },
                    completeopt = 'menu,menuone,noselect',
                    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
                    keyword_length = 1,
                    -- keyword_length = 1,
                    -- keyword_pattern = ".*",
                },
                -- formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm({
                                    select = true,
                                })
                            end
                        else
                            fallback()
                        end
                    end),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    {
                        name = 'nvim_lsp',
                        trigger_characters = vim.split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
                    },
                    { name = 'path' },
                    { name = 'luasnip' },
                    { name = 'nvim_lsp_signature_help' },
                }, {
                    { name = 'buffer' },
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
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
