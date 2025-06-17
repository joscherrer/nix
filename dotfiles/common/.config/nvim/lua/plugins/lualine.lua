return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local overseer = require('overseer')
        require('lualine').setup({
            sections = {
                lualine_c = {
                    {
                        'filename',
                        file_status = true,     -- Displays file status (readonly status, modified status)
                        newfile_status = false, -- Display new file status (new file means no write after created)
                        path = 1,               -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory
                        -- 4: Filename and parent dir, with tilde as the home directory

                        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                        -- for other components. (terrible name, any suggestions?)
                        symbols = {
                            modified = '⬤', -- Text to show when the file is modified.
                            readonly = '🔒', -- Text to show when the file is non-modifiable or readonly.
                            unnamed = '[No Name]', -- Text to show for unnamed buffers.
                            newfile = '📄', -- Text to show for newly created file before first write
                        }
                    }
                },
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
                    {
                        function()
                            if vim.g.smart_resize_mode == true then
                                return "📏"
                            else
                                return ""
                            end
                        end,

                    },
                    {
                        function()
                            local ok, max = pcall(vim.api.nvim_tabpage_get_var, 0, 'maximized')
                            if ok and max then
                                return "➖"
                            else
                                return "⛶ "
                            end
                        end,
                        on_click = function()
                            require('bbrain.helpers').toggle_maximize()
                        end,
                        color = function()
                            local ok, max = pcall(vim.api.nvim_tabpage_get_var, 0, 'maximized')
                            if ok and max then
                                return { fg = "#c678dd", gui = "bold" }
                            else
                                return { fg = "#ffffff", gui = "bold" }
                            end
                        end,
                    },
                    { 'filetype' }
                    -- {
                    --     require("noice").api.status.search.get,
                    --     cond = require("noice").api.status.search.has,
                    --     color = { fg = "#ff9e64" },
                    -- }

                },
                lualine_z = {
                    -- {
                    --     function()
                    --         return ">_"
                    --     end,
                    -- },
                    -- { 'b:toggle_number' },
                    { 'location' },
                },
            },
        })
    end
}
