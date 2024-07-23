local helpers = require('bbrain.helpers')

local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })
local af_group = vim.api.nvim_create_augroup("AutoFormat", {})


vim.api.nvim_create_autocmd('VimResized', {
    group = wr_group,
    pattern = '*',
    command = 'wincmd =',
    desc = 'Automatically resize windows when the host window size changes.',
})

-- FocusLost, InsertLeave,
vim.api.nvim_create_autocmd({ 'FocusLost', 'InsertLeave' }, {
    callback = function(ev)
        if not vim.api.nvim_buf_get_option(ev.buf, "modified") then
            return
        end
        if not vim.api.nvim_buf_is_valid(ev.buf) then
            return
        end
        vim.api.nvim_buf_call(ev.buf, function()
          helpers.format(ev.buf, {async = false})
          vim.cmd('silent! write')
        end)
    end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*',
  group = af_group,
  desc = 'Auto format on save',
  callback = function()
    helpers.format(0, {async = false})
    vim.cmd('silent! write')
  end
})

-- vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
--     callback = function(ev)
--         if not vim.api.nvim_buf_get_option(ev.buf, "modified") then
--             return
--         end
--         local now = vim.fn.reltime()
--         local nowf = vim.fn.reltimefloat(now)
--         local mtime = helpers.buf_get_var_float(ev.buf, "mtime") or nowf
--
--         if ev.event == "TextChanged" then
--             vim.api.nvim_buf_set_var(ev.buf, "mtime", nowf)
--             vim.notify("Will be saved in 5s")
--             vim.defer_fn(function()
--                 if not vim.api.nvim_buf_is_valid(ev.buf) then return end
--                 local new_mtime = helpers.buf_get_var_float(ev.buf, "mtime")
--                 if new_mtime == mtime then
--                     vim.api.nvim_buf_call(ev.buf, function() vim.cmd("silent! write") end)
--                     vim.notify("Saved file " .. ev.file)
--                 end
--             end, 5000)
--             return
--         end
--         -- local next_save = helpers.buf_get_var_float(ev.buf, "next_save") or 0.0
--         -- if next_save - nowf > 0 then
--         --     return
--         -- end
--         -- if ev.event == "InsertLeave" then
--
--         -- end
--
--         -- next_save = nowf + 0.300
--
--         -- vim.api.nvim_buf_set_var(ev.buf, "next_save", tostring(next_save))
--
--         -- vim.defer_fn(function()
--         --     if vim.api.nvim_buf_is_valid(ev.buf) then
--         --         vim.api.nvim_buf_call(ev.buf, function() vim.cmd("silent! write") end)
--         --         vim.notify("Saved file " .. ev.file)
--         --     end
--         -- end, 300)
--     end,
--     pattern = "*",
-- })
