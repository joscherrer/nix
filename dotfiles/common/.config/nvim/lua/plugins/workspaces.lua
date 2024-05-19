return {
    'natecraddock/workspaces.nvim',
    priority = 10,
    config = function()
        require("workspaces").setup({
            auto_open = true,
            hooks = {
                open_pre = {
                    "NvimTreeClose",
                    "OverseerClose",
                    "SessionsStop",
                    "silent %bdelete!",
                },
                open = function()
                    require('sessions').load(nil, { silent = true })
                    vim.cmd("silent LspStart")
                end,
            },
        })
        require("telescope").load_extension("workspaces")
    end
}
