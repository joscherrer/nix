local function get_nvim_tree_float_dimensions()
end

require("nvim-tree").setup({
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
