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

            vim.o.winblend = 100
            -- vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "" })
            -- vim.api.nvim_set_hl(0, "NotifyBorder", { bg = "" })
            -- vim.api.nvim_set_hl(0, "NotifyINFOBorder", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "" })
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#abb2bf", fg = "#313640", cterm = { bold = true }, bold = true })
            vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#abb2bf", bg = "#313640" })
        end
    },
    { 'stevearc/dressing.nvim',      opts = {} },
    {
        'rcarriga/nvim-notify',
        priority = 999,
        config = function()
            vim.notify = require('notify')
            require('notify').setup({
                fps = 120,
                stages = "static",
                -- on_open = function(win)
                --     local ns = vim.api.nvim_create_namespace("nvim-notify")
                --     vim.api.nvim_set_hl(ns, "Normal", { bg = "#ff0000" })
                --     vim.api.nvim_win_set_hl_ns(win, ns)
                -- end,
                -- render = function(bufnr, notif, highlights, config)
                --     local left_icon = notif.icon .. " "
                --     local max_message_width = math.max(math.max(unpack(vim.tbl_map(function(line)
                --         return vim.fn.strchars(line)
                --     end, notif.message))))
                --     local right_title = notif.title[2]
                --     local left_title = notif.title[1]
                --     local title_accum = vim.str_utfindex(left_icon)
                --         + vim.str_utfindex(right_title)
                --         + vim.str_utfindex(left_title)
                --
                --     local left_buffer = string.rep(" ", math.max(0, max_message_width - title_accum))
                --
                --     local namespace = require("notify.render.base").namespace()
                --     vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
                --     vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
                --         virt_text = {
                --             { " " },
                --             { left_icon,                 highlights.icon },
                --             { left_title .. left_buffer, highlights.title },
                --         },
                --         virt_text_win_col = 0,
                --         priority = 10,
                --     })
                --     vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
                --         virt_text = { { " " }, { right_title, highlights.title }, { " " } },
                --         virt_text_pos = "right_align",
                --         priority = 10,
                --     })
                --     vim.api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
                --         virt_text = {
                --             {
                --                 string.rep(
                --                     "━",
                --                     math.max(vim.str_utfindex(left_buffer) + title_accum + 2, config.minimum_width())
                --                 ),
                --                 highlights.border,
                --             },
                --         },
                --         virt_text_win_col = 0,
                --         priority = 10,
                --     })
                --     vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, notif.message)
                --
                --     vim.api.nvim_buf_set_extmark(bufnr, namespace, 2, 0, {
                --         hl_group = highlights.body,
                --         end_line = 1 + #notif.message,
                --         end_col = #notif.message[#notif.message],
                --         priority = 50, -- Allow treesitter to override
                --     })
                -- end,
            })
        end,
    },
    { "norcalli/nvim-colorizer.lua", opts = {} }
}
