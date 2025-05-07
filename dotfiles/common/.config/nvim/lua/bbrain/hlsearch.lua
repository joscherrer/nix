local group = vim.api.nvim_create_augroup("bbrain.hlsearch", {})

vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdwinEnter" }, {
    group = group,
    pattern = '*',
    callback = function(ev)
        vim.v.hlsearch = 1
    end
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    pattern = '*',
    callback = function(ev)
        if vim.fn.getcmdtype() == ":" then
            vim.v.hlsearch = 0
        end
    end
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    pattern = '*',
    callback = function(ev)
        vim.schedule(function()
            vim.v.hlsearch = 0
        end)
    end
})
