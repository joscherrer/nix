-- return {
--     {
--         'hrsh7th/nvim-cmp',
--         event = 'InsertEnter',
--         dependencies = {
--             { 'hrsh7th/cmp-buffer' },
--             { 'hrsh7th/cmp-path' },
--             { 'hrsh7th/cmp-cmdline' },
--             { 'hrsh7th/cmp-nvim-lsp' },
--             { 'hrsh7th/cmp-nvim-lsp-signature-help' },
--             { 'L3MON4D3/LuaSnip' },
--             { 'saadparwaiz1/cmp_luasnip' },
--         },
--         config = function()
--             require("luasnip.loaders.from_vscode").lazy_load()
--             require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets/vscode' } })
--             require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath('config') .. '/snippets/lua' } })
--
--             local cmp = require('cmp')
--             local luasnip = require('luasnip')
--
--             vim.lsp.config('*', require('cmp_nvim_lsp').default_capabilities())
--
--             cmp.setup({
--                 completion = {
--                     autocomplete = {
--                         "TextChanged"
--                     },
--                     completeopt = 'menu,menuone,noselect',
--                     keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
--                     keyword_length = 1,
--                     -- keyword_length = 1,
--                     -- keyword_pattern = ".*",
--                 },
--                 -- formatting = lsp_zero.cmp_format({ details = true }),
--                 mapping = cmp.mapping.preset.insert({
--                     ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--                     ['<C-d>'] = cmp.mapping.scroll_docs(4),
--                     ['<C-Space>'] = cmp.mapping.complete(),
--                     ['<C-e>'] = cmp.mapping.abort(),
--                     ['<C-y>'] = cmp.mapping(function(fallback)
--                         if cmp.visible() then
--                             if luasnip.expandable() then
--                                 luasnip.expand()
--                             else
--                                 cmp.confirm({
--                                     select = true,
--                                 })
--                             end
--                         else
--                             fallback()
--                         end
--                     end),
--                     ['<Tab>'] = cmp.mapping(function(fallback)
--                         if luasnip.locally_jumpable(1) then
--                             luasnip.jump(1)
--                         else
--                             fallback()
--                         end
--                     end, { 'i', 's' }),
--                     ['<S-Tab>'] = cmp.mapping(function(fallback)
--                         if luasnip.locally_jumpable(-1) then
--                             luasnip.jump(-1)
--                         else
--                             fallback()
--                         end
--                     end, { 'i', 's' }),
--                 }),
--                 sources = cmp.config.sources({
--                     {
--                         name = 'nvim_lsp',
--                         trigger_characters = vim.split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
--                     },
--                     { name = 'path' },
--                     { name = 'luasnip' },
--                     { name = 'nvim_lsp_signature_help' },
--                 }, {
--                     { name = 'buffer' },
--                 }),
--                 snippet = {
--                     expand = function(args)
--                         luasnip.lsp_expand(args.body)
--                     end,
--                 },
--             })
--             -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
--             cmp.setup.cmdline({ '/', '?' }, {
--                 mapping = cmp.mapping.preset.cmdline(),
--                 sources = {
--                     { name = 'buffer' }
--                 }
--             })
--
--             -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--             cmp.setup.cmdline(':', {
--                 mapping = cmp.mapping.preset.cmdline(),
--                 sources = cmp.config.sources({
--                     { name = 'path' }
--                 }, {
--                     { name = 'cmdline' }
--                 }),
--                 matching = { disallow_symbol_nonprefix_matching = false }
--             })
--             vim.keymap.set('c', '<C-y>', cmp.mapping.confirm({ select = true }))
--         end,
--     },
-- }
return {
    'saghen/blink.cmp',
    dependencies = {
        'saghen/blink.lib',
        -- optional: provides snippets for the snippet source
        'rafamadriz/friendly-snippets',
    },
    build = function()
        -- build the fuzzy matcher, wait up to 60 seconds
        -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
        require('blink.cmp').build():wait(60000)
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = true, auto_show_delay_ms = 500 } },

        -- (Default) list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"`
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "lua" },
        cmdline = {
            completion = {
                menu = {
                    auto_show = true
                }
            }
        }
    },
}
