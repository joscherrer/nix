local M = {}

if vim.g.bbrain_maximize == nil then
    vim.g.bbrain_maximize = {}
end


function M.cleanup()
    local cleaned = {}
    for _, e in ipairs(vim.g.bbrain_maximize) do
        if vim.api.nvim_tabpage_is_valid(e) then
            table.insert(cleaned, e)
        end
    end
end

function M.set_maximize()
    M.cleanup()
    local tabpage = vim.api.nvim_get_current_tabpage()
    if not vim.tbl_contains(vim.g.bbrain_maximize, tabpage) then
        table.insert(vim.g.bbrain_maximize, tabpage)
    end
end

function M.unset_maximize()
    M.cleanup()
end
