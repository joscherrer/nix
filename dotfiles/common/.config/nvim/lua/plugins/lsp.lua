local function lspconfig_config()
    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

    -- local function format(buffer)
    --   local filetype = vim.api.nvim_get_option_value('filetype', { buf = buffer })
    --   if filetype == 'python' then
    --     vim.cmd('silent! black %')
    --     return
    --   end
    --   vim.lsp.buf.format({ async = true })
    -- end

    local helpers = require('bbrain.helpers')


    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', function() helpers.format(event.buf) end, opts)
        vim.keymap.set({'n', 'x'}, 'gq', function() helpers.format(event.buf) end, opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = event.buf })

        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = event.buf,
            callback = function()
                opts = {
                    focusable = false,
                    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                    border = 'rounded',
                    source = 'always',
                    prefix = ' ',
                    scope = 'cursor',
                }
                vim.diagnostic.open_float(nil, opts)
            end
        })
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
            }
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
    lspconfig.basedpyright.setup({})

    vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
    vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
    vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })

    vim.diagnostic.config({ virtual_text = false })
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
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
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
        end
    },
}
