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

            -- vim.o.winblend = 100
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#abb2bf", fg = "#313640", cterm = { bold = true }, bold = true })
            vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#abb2bf", bg = "#313640" })
        end
    },
    {
        'stevearc/dressing.nvim',
        opts = {
            select = {
                telescope = require('bbrain.helpers').telescope.config
            }
        }
    },
    {
        'rcarriga/nvim-notify',
        priority = 999,
        config = function()
            vim.notify = require('notify')
            require('notify').setup({
                fps = 120,
                stages = {
                    function(state)
                        local next_height = state.message.height + 2
                        local util = require("notify.stages.util")
                        local direction = util.DIRECTION.TOP_DOWN
                        local next_row = util.available_slot(state.open_windows, next_height, direction)
                        if not next_row then
                            return nil
                        end
                        return {
                            relative = "editor",
                            anchor = "NE",
                            width = state.message.width,
                            height = state.message.height,
                            col = vim.opt.columns:get() - 1,
                            row = next_row + 1,
                            border = "solid",
                            style = "minimal",
                        }
                    end,
                    function()
                        return {
                            col = vim.opt.columns:get() - 1,
                            time = true,
                        }
                    end,
                }
            })
        end,
    },
    { "norcalli/nvim-colorizer.lua", opts = {} }
}
