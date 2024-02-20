vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
    callback = function(ev)
        if not vim.api.nvim_buf_get_option(ev.buf, "modified") then
            return
        end
        local success, mod = pcall(vim.api.nvim_buf_get_var, ev.buf, "next_save")
        local next_save = 0.0

        if success and mod then
            next_save = vim.fn.eval(mod)
        end

        local now = vim.fn.reltime()
        local now_float = vim.fn.reltimefloat(now)

        if success and next_save - now_float > 0 then
            return
        end
        next_save = now_float + 0.300

        vim.api.nvim_buf_set_var(ev.buf, "next_save", tostring(next_save))

        vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
                vim.api.nvim_buf_call(ev.buf, function() vim.cmd("silent! write") end)
                vim.notify("Saved file " .. ev.file)
            end
        end, 300)
    end,
    pattern = "*",
})
