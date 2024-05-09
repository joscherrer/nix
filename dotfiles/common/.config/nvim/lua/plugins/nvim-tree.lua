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
            view = {
                float = {
                    enable = false,
                },
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                    window_picker = {
                        enable = false
                    }
                }
            }
        })
    end,
}
