return {
    'natecraddock/workspaces.nvim',
    config = function()
        require("workspaces").setup({
            auto_open = true,
            hooks = {
                open_pre = {
                    "NvimTreeClose",
                    "SessionsStop",
                    "silent %bdelete!",
                },
                open = function()
                    require('sessions').load(nil, { silent = true })
                end,
            },
        })
        require("telescope").load_extension("workspaces")
    end
}
