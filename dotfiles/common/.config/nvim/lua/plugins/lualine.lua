return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local overseer = require('overseer')
        require('lualine').setup({
            sections = {
                lualine_x = {
                    {
                        "overseer",
                        label = '',
                        colored = true,
                        symbols = {
                            [overseer.STATUS.FAILURE] = "🔴",
                            [overseer.STATUS.CANCELED] = "🔵",
                            [overseer.STATUS.SUCCESS] = "🟢",
                            [overseer.STATUS.RUNNING] = "🟡",
                        },
                        unique = false,
                        name = nil,
                        name_not = false,
                        status = nil,
                        status_not = false,
                    },
                    -- {
                    --     require("noice").api.status.search.get,
                    --     cond = require("noice").api.status.search.has,
                    --     color = { fg = "#ff9e64" },
                    -- }

                },
            },
        })
    end
}
