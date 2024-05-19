local function lspconfig_config()
    -- This is where all the LSP shenanigans will live
    -- local lsp_zero = require('lsp-zero')
    -- lsp_zero.extend_lspconfig()

    --- if you want to know more about lsp-zero and mason.nvim
    --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
    -- lsp_zero.on_attach(function(client, bufnr)
    --     bufpath = vim.api.nvim_buf_get_name(bufnr)
    --     vim.notify('LSP started: ' .. bufpath .. ' ' .. bufnr, vim.log.levels.INFO)
    --     lsp_zero.default_keymaps({
    --         buffer = bufnr,
    --     })
    --     lsp_zero.buffer_autoformat()
    --     local opts = { buffer = bufnr }
    --     vim.keymap.set({ 'n', 'x' }, 'gq',
    --         function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
    --     vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
    --
    --     vim.api.nvim_create_autocmd("CursorHold", {
    --         buffer = bufnr,
    --         callback = function()
    --             opts = {
    --                 focusable = false,
    --                 close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    --                 border = 'rounded',
    --                 source = 'always',
    --                 prefix = ' ',
    --                 scope = 'cursor',
    --             }
    --             vim.diagnostic.open_float(nil, opts)
    --         end
    --     })
    -- end)
    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}

        -- these will be buffer-local keybindings
        -- because they only work if you have an active language server

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, 'gq', function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = event.buf })
      end
    })

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    local default_setup = function(server)
      require('lspconfig')[server].setup({
        capabilities = lsp_capabilities,
      })
    end
    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = {
            'pyright',
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
            default_setup,
            -- this first function is the "default handler"
            -- it applies to every language server without a "custom handler"
            -- function(server_name)
            --     require('lspconfig')[server_name].setup({})
            -- end,
            --
            -- -- this is the "custom handler" for `lua_ls`
            -- lua_ls = function()
            --     -- (Optional) Configure lua language server for neovim
            --     local lua_opts = lsp_zero.nvim_lua_ls()
            --     require('lspconfig').lua_ls.setup(lua_opts)
            -- end,
        }
    })

    local lspconfig = require('lspconfig')

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

    vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
    vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
    vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })

    vim.diagnostic.config({ virtual_text = false })
end

return {
    -- {
    --     'VonHeikemen/lsp-zero.nvim',
    --     branch = 'v3.x',
    --     lazy = true,
    --     config = false,
    --     init = function()
    --         vim.g.lsp_zero_extend_cmp = 0
    --         vim.g.lsp_zero_extend_lspconfig = 0
    --     end,
    -- },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = function()
            require('mason').setup({
                providers = {
                    "mason.providers.client",
                    "mason.providers.registry-api",
                }
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
