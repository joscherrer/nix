-- This is where all the LSP shenanigans will live
local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

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

require('mason').setup({
    providers = {
        "mason.providers.client",
        "mason.providers.registry-api",
    }
})

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

local lspconfig = require('lspconfig')

lspconfig.nil_ls.setup({
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
