local lsp = require('lsp-zero').preset({})


-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
require('lspconfig').nil_ls.setup({})
lsp.ensure_installed({
    'pyright',
    'bashls',
    'gopls',
    'helm_ls',
    'marksman',
    'tflint',
    'ansiblels',
    'yamlls',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
    local opts = { buffer = bufnr }
    vim.keymap.set({ 'n', 'x' }, 'gq', function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)
end)

lsp.setup()

vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })
