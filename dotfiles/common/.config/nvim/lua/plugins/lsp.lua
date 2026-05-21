return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
    },
    {
        "seblyng/roslyn.nvim",
        -- commit = "f2ec6ee6384c3b611ddc817b9e78b20cd0334bbb",
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
            extensions = {
                razor = {
                    enabled = true,
                }
            }
            -- your configuration comes here; leave empty for default settings
        },
    }
    -- {
    --     "pmizio/typescript-tools.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    --     opts = {
    --         filetypes = {
    --             "javascript",
    --             "javascriptreact",
    --             "typescript",
    --             "typescriptreact",
    --             "vue",
    --         },
    --         settings = {
    --             single_file_support = false,
    --             tsserver_plugins = {
    --                 "@vue/typescript-plugin",
    --             }
    --         }
    --     }
    -- }
}
