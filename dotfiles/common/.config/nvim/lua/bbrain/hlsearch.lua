local group = vim.api.nvim_create_augroup("bbrain.hlsearch", {})

vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdwinEnter" }, {
    group = group,
    pattern = '*',
    callback = function(ev)
        vim.api.nvim_set_option_value("hlsearch", true, { scope = "global" })
    end
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    pattern = '*',
    callback = function(ev)
        if vim.fn.getcmdtype() == ":" then
            vim.api.nvim_set_option_value("hlsearch", false, { scope = "global" })
        end
    end
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    pattern = '*',
    callback = function(ev)
        vim.api.nvim_set_option_value("hlsearch", false, { scope = "global" })
    end
})
