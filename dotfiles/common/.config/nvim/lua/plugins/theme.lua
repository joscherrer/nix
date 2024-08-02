return {
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        config = function()
            require("onedarkpro").setup({
                colors = {
                    dark = {
                        bg = '#282a36',
                        black = '#282a36',
                        -- fg = '#eff0eb',
                        -- red = '#ff5c57',
                        -- yellow = '#f3f99d',
                        -- green = '#5af78e',
                        -- blue = '#57c7ff',
                        -- cyan = '#9aedfe',
                        -- purple = '#ff6ac1',
                        -- orange = '#ff9f43',
                        -- brown = '#b2643c',
                        -- pink = '#FF5370'
                    },
                }
            })

            vim.cmd("colorscheme onedark")

            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#abb2bf", fg = "#313640", cterm = { bold = true }, bold = true })
            vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#abb2bf", bg = "#313640" })
        end
    },
    { 'stevearc/dressing.nvim',      opts = {} },
    {
        'rcarriga/nvim-notify',
        priority = 999,
        opts = {
            render = "wrapped-compact",
        },
        config = function()
            vim.notify = require('notify')
            vim.notify(
                "Reminder to check if issue #335 has been resolved upstream.",
                vim.log.levels.WARN,
                { title = "rmagatti/auto-session" }
            )
        end,
    },
    { "norcalli/nvim-colorizer.lua", opts = {} }
}
