local M = {}

local http = require('bbrain.http')
local fs = require('luvit.fs')
local helpers = require('bbrain.helpers')

local localSchemaRoot = vim.fn.expand("$HOME/.datree/crdSchemas")
M.lsp_autocmd = 0

local function getSymbol(symbols, key)
    local objs = {}
    for _, v in pairs(symbols) do
        if v.name == key then
            table.insert(objs, v.detail)
        end
    end
    return objs
end

local function parseApiVersion(apiVersion)
    local group, version = unpack(vim.split(apiVersion, "/"))
    if version == nil then
        version = group
        group = ""
    end
    return group, version
end

local function findLocalSchema(kind, group, version)
    local schema = vim.fs.joinpath(localSchemaRoot, group, kind .. "_" .. version .. ".json")
    local schema_s = vim.fs.joinpath(localSchemaRoot, group, kind .. "s_" .. version .. ".json")
    if vim.fn.filereadable(schema) ~= 0 then
        return schema
    elseif vim.fn.filereadable(schema_s) ~= 0 then
        return schema_s
    end
    return nil
end

local lsp_symbol_callback = function(client, bufnr, _, result)
    local rootStrings = vim.tbl_filter(function(o) return o.kind == 15 end, result)
    local kinds = getSymbol(rootStrings, "kind")
    local apiVersions = getSymbol(rootStrings, "apiVersion")
    local ready = 0

    if #kinds == 0 or #apiVersions == 0 then
        return
    end

    if #kinds ~= #apiVersions then
        return
    end

    vim.notify("Found " .. #kinds .. " resources", vim.log.levels.DEBUG)

    local schemas = vim.fn.expand("$HOME/.datree/crdSchemas")
    local schemaSequencePath = vim.fs.joinpath("/tmp", "schemaSequence_" ..
        helpers.random_string(10) .. ".json")

    local schemaSequence = {}
    ---@type table<number, fun()>
    local asyncReqs = {}

    for i, _ in pairs(kinds) do
        vim.notify("index: " .. i, vim.log.levels.DEBUG)
        vim.notify("Processing: " .. kinds[i] .. " " .. apiVersions[i], vim.log.levels.DEBUG)
        local kind = string.lower(kinds[i])
        local group, version = parseApiVersion(apiVersions[i])

        local localSchema = findLocalSchema(kind, group, version)

        if localSchema ~= nil then
            vim.notify(i .. ": Found: " .. localSchema, vim.log.levels.DEBUG)
            ready = ready + 1
            fs.readFile(localSchema, function(_, data)
                schemaSequence[i] = vim.json.decode(data)
                ready = ready - 1
            end)
        else
            local kube_version = "v1.30.5-standalone"
            local urlfmt = "https://github.com/yannh/kubernetes-json-schema/raw/refs/heads/master/%s/%s-%s.json"
            local url = string.format(urlfmt, kube_version, kind, version)
            vim.notify("Trying to find native k8s schema", vim.log.levels.DEBUG)
            schemaSequence[i] = {}
            local res = http.async_get(url, {}, function(out)
                if out.stdout == "" then
                    return
                end
                vim.notify(i .. ": Found: " .. url, vim.log.levels.DEBUG)
                schemaSequence[i] = vim.json.decode(out.stdout)
            end)
            table.insert(asyncReqs, res)
        end
    end

    while ready > 0 do
        vim.wait(10)
    end
    for _, v in pairs(asyncReqs) do
        v()
    end
    vim.notify("Schema sequence length: " .. #schemaSequence, vim.log.levels.DEBUG)
    fs.writeFileSync(vim.fn.expand(schemaSequencePath),
        vim.json.encode({ schemaSequence = schemaSequence }))

    client.settings.yaml.schemas = {
        [schemaSequencePath] = vim.api.nvim_buf_get_name(bufnr)
    }
    client.notify('workspace/didChangeConfiguration', {
        settings = client.settings
    })
end

function M.on_attach(client, bufnr)
    local findClientByName = function(bufnr, name)
        for _, v in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if v.name == name then
                return v
            end
        end
        return nil
    end

    -- trigger on_attach everytime we leave insert mode for yaml files
    if M.lsp_autocmd == 0 then
        M.lsp_autocmd = vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            pattern = { "*.yaml", "*.yml" },
            callback = function(ev)
                vim.notify("on_attach", vim.log.levels.DEBUG)
                local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "yamlls" })
                if #clients ~= 1 then
                    return
                end
                local client = clients[1]
                client.on_attach(ev.buf)
            end
        })
    end
    local opts = {
        textDocument = vim.lsp.util.make_text_document_params()
    }
    client.request('textDocument/documentSymbol', opts,
        function(_, result)
            return lsp_symbol_callback(client, bufnr, _, result)
        end
    )
end

return M
