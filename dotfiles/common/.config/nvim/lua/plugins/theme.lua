local minified_messages = { "Maximize", "lazy.nvim" }

vim.cmd([[
    :hi link NvimTreeSignColumn NvimTreeNormalFloat
]])

---@param message NoiceMessage
local function minify_msg(message)
    return message.opts and vim.list_contains(minified_messages, message.title)
end

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
                    },
                }
            })

            vim.cmd("colorscheme onedark")

            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#abb2bf", fg = "#313640", cterm = { bold = true }, bold = true })
            vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#abb2bf", bg = "#313640" })
            vim.api.nvim_set_hl(0, "Folded", { bg = "#414858" })
        end
    },
    -- {
    --     'stevearc/dressing.nvim',
    --     opts = {
    --         select = {
    --             telescope = require('bbrain.helpers').telescope.config
    --         }
    --     }
    -- },
    {
        'rcarriga/nvim-notify',
        lazy = false,
        priority = 999,
        config = function()
            -- notify handled by noice.nvim
            -- vim.notify = require('notify')
            require('notify').setup({
                fps = 120,
                max_width = function() return math.ceil(vim.opt.columns:get() * 0.3) end,
                render = "wrapped-compact",
                -- level = vim.log.levels.DEBUG,
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
                            -- border = "none",
                            style = "minimal",
                        }
                    end,
                    function()
                        return {
                            col = vim.opt.columns:get() - 1,
                            time = true,
                        }
                    end,
                },
            })
        end,
    },
    { "norcalli/nvim-colorizer.lua", opts = {} },
    {
        "folke/noice.nvim",
        -- version = "4.4.7",
        -- pin = true,
        enabled = true,
        lazy = false,
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
            routes = {
                { filter = { event = "msg_show", kind = "search_count" },         opts = { skip = true } },
                { filter = { event = "msg_show", kind = "", find = "wiped out" }, opts = { skip = true } },
                { filter = { event = "msg_show", kind = "", find = "written" },   view = "mini" },
                { filter = { event = "msg_show", kind = "", find = "yanked" },    view = "mini" },
                -- {
                --     filter = { event = "notify", cond = minify_msg },
                --     view = "mini"
                -- },
            },
            views = {
                cmdline_popup = {
                    border = {
                        style = "none",
                        padding = { 1, 1 },
                    },
                    filter_options = {},
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                }
            },
            redirect = {
                view = "split",
                filter = { event = "msg_show" }
            }
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function(_, opts)
            require("noice").setup(opts)
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = {
                enabled = true,
                notify = true,
            },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
                ui_select = true,
                win = {

                }
            },
            notifier = { enabled = false },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
        }
    },
}
