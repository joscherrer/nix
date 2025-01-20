local M = {}

---@alias SystemPromise fun(): vim.SystemCompleted?

---@class RequestOpts
---@field headers? table<string, string>

---@param url string
---@param opts? RequestOpts
---@param callback? fun(out: vim.SystemCompleted)
---@return vim.SystemObj|nil
local function call_curl_async(url, opts, callback)
    local cmd = { "curl", "-fsSL", url }
    local ok, result = pcall(vim.system, cmd, { text = true }, callback)
    if not ok then
        print(result)
        return nil
    end

    return result
end

---@param obj vim.SystemObj?
---@return SystemPromise
local function new_promise(obj)
    return function()
        if obj == nil then
            return nil
        end
        ---@type vim.SystemCompleted
        local res = obj:wait(1000)
        if res.code ~= 0 then
            return nil
        end
        return res
    end
end

---@param url string
---@param opts? RequestOpts
---@param callback? fun(out: vim.SystemCompleted)
---@return SystemPromise
function M.async_get(url, opts, callback)
    local req = call_curl_async(url, opts, callback)
    return new_promise(req)
end

return M
