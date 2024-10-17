return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            sync_root_with_cwd = true,
            sort = { sorter = "case_sensitive", },
            renderer = { group_empty = true, },
            filters = { dotfiles = false, },
            update_focused_file = { enable = true, },
            view = {
                float = {
                    enable = true,
                    quit_on_focus_loss = true,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w = screen_w * 0.3
                        local window_h = screen_h - 4
                        local window_w_int = math.floor(window_w)
                        local window_h_int = math.floor(window_h)
                        local center_x = 4
                        local center_y = ((vim.opt.lines:get() - window_h) / 2)
                            - vim.opt.cmdheight:get() - 1
                        return {
                            border = 'solid',
                            relative = 'editor',
                            row = center_y,
                            col = center_x,
                            width = window_w_int,
                            height = window_h_int,
                        }
                    end,
                    -- open_win_config = {
                    --     relative = "editor",
                    --     border = "none",
                    --     height = function() vim.opt.lines:get() end,
                    -- }
                },
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                    window_picker = {
                        enable = false,
                    }
                }
            }
        })
        require('nvim-tree.view').View.winopts.winblend = 20
    end,
}
