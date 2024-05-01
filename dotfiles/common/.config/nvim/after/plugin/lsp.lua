local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({
        buffer = bufnr,
    })
    lsp_zero.buffer_autoformat()
    local opts = { buffer = bufnr }
    vim.keymap.set({ 'n', 'x' }, 'gq', function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
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
        lsp_zero.default_setup,
    },
})
local lspconfig = require('lspconfig')

-- (Optional) Configure lua language server for neovim
lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())
lspconfig.nil_ls.setup({})
lspconfig.pyright.setup({})
lspconfig.volar.setup({
    filetypes = {'vue'}
})
-- require('lspconfig').pylsp.setup({})


local cmp = require('cmp')
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'copilot', group_index = 2 },
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

-- lsp_zero.set_sign_icons({
--     error = 'E',
--     warn = 'W',
--     hint = 'H',
--     info = 'I'
-- })


vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })
