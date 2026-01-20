local helpers = require('bbrain.helpers')
local palette = require('bbrain.palette')

vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
        }
    }
})

vim.lsp.enable('gopls')
vim.lsp.enable('nil_ls')
vim.lsp.enable('lua_ls')
-- vim.lsp.enable('terraformls')
vim.lsp.enable('tofu_ls')
vim.lsp.enable('basedpyright')
vim.lsp.enable('yamlls')
-- vim.lsp.enable('marksman')
-- vim.lsp.enable('jsonnet_ls')
-- vim.lsp.enable('csharp_ls')

-- -- ts/js
-- vim.lsp.enable('vtsls')
vim.lsp.enable({ 'vue_ls' })
-- vim.lsp.enable('eslint')
-- vim.lsp.enable('tailwindcss')

-- -- dart/flutter
-- vim.lsp.enable('dartls')
--
--

local function lsp_restart(info)
    vim.notify("Restarting LSP", vim.log.levels.INFO)
    local clients = {}
    if info then
        clients = info.fargs
    end

    -- Default to restarting all active servers
    if #clients == 0 then
        clients = vim
            .iter(vim.lsp.get_clients())
            :map(function(client)
                return client.name
            end)
            :totable()
    end

    for _, name in ipairs(clients) do
        if vim.lsp.config[name] == nil then
            vim.notify(("Invalid server name '%s'"):format(name))
        else
            vim.lsp.enable(name, false)
        end
    end

    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
        for _, name in ipairs(clients) do
            vim.schedule_wrap(function(x)
                vim.lsp.enable(x)
            end)(name)
        end
    end)
end

palette.add("LSP", "LSPRestart", {
    cmd = {
        name = "LSPRestart",
        cmd = lsp_restart
    },
    keys = {
        { mode = { "n", "i" }, lhs = "<F6>", opts = {} },
    },
    desc = "LSP: Reload clients"
})

palette.add("LSP", "LSPHover", {
    cmd = { name = "LSPHover", cmd = function() vim.lsp.buf.hover() end },
    keys = {
        { mode = "n",          lhs = "<S-k>", opts = {} },
        { mode = { "n", "i" }, lhs = "<C-k>", opts = {} },
    },
    desc = "LSP: Display hover information about symbol"
})

-- Show definition
palette.add("LSP", "LSPDefinition", {
    cmd = {
        name = "LSPDefinition",
        cmd = function() require('trouble').toggle({ mode = 'lsp_definitions' }) end,
    },
    keys = {
        { mode = "n", lhs = "gd", opts = {} },
    },
    desc = "LSP: Show definition",
})

-- Declarations (gD)
palette.add("LSP", "LSPDeclaration", {
    cmd = {
        name = "LSPDeclaration",
        cmd = function() require('trouble').toggle({ mode = 'lsp_declarations' }) end,
    },
    keys = {
        { mode = "n", lhs = "gD", opts = {} },
    },
    desc = "LSP: Show declaration",
})

-- Implementations (gi)
palette.add("LSP", "LSPImplementation", {
    cmd = {
        name = "LSPImplementation",
        cmd = function() require('trouble').toggle({ mode = 'lsp_implementations' }) end,
    },
    keys = {
        { mode = "n", lhs = "gi", opts = {} },
    },
    desc = "LSP: Show implementation",
})

-- Type definitions (go)
palette.add("LSP", "LSPTypeDefinition", {
    cmd = {
        name = "LSPTypeDefinition",
        cmd = function() require('trouble').toggle({ mode = 'lsp_type_definitions' }) end,
    },
    keys = {
        { mode = "n", lhs = "go", opts = {} },
    },
    desc = "LSP: Show type definition",
})

-- Signature help (gs, <C-k>)
palette.add("LSP", "LSPSignatureHelp", {
    cmd = {
        name = "LSPSignatureHelp",
        cmd = function() vim.lsp.buf.signature_help() end,
    },
    keys = {
        { mode = "n", lhs = "gs",    opts = {} },
        { mode = "n", lhs = "<C-k>", opts = {} },
    },
    desc = "LSP: Show signature help",
})

-- References (gr)
palette.add("LSP", "LSPReferences", {
    cmd = {
        name = "LSPReferences",
        cmd = function() require('trouble').toggle({ mode = 'lsp_references' }) end,
    },
    keys = {
        { mode = "n", lhs = "gr", opts = {} },
    },
    desc = "LSP: Show references",
})

-- Rename (<F2>)
palette.add("LSP", "LSPRename", {
    cmd = {
        name = "LSPRename",
        cmd = function() vim.lsp.buf.rename() end,
    },
    keys = {
        { mode = "n", lhs = "<F2>", opts = {} },
    },
    desc = "LSP: Rename",
})

-- Format document (<F3>, gq) for normal and visual (x) modes
palette.add("LSP", "LSPFormat", {
    cmd = {
        name = "LSPFormat",
        cmd = function() helpers.format(0) end,
    },
    keys = {
        { mode = { "n", "x" }, lhs = "<F3>", opts = {} },
        { mode = { "n", "x" }, lhs = "gq",   opts = {} },
    },
    desc = "Format document",
})

-- Code action (<F4>)
palette.add("LSP", "LSPCodeAction", {
    cmd = {
        name = "LSPCodeAction",
        cmd = function() vim.lsp.buf.code_action() end,
    },
    keys = {
        { mode = "n", lhs = "<F4>", opts = {} },
    },
    desc = "LSP: Code action",
})

-- Open floating diagnostics (gl)
palette.add("LSP", "LSPOpenDiagnostics", {
    cmd = {
        name = "LSPOpenDiagnostics",
        cmd = function() vim.diagnostic.open_float() end,
    },
    keys = {
        { mode = "n", lhs = "gl", opts = {} },
    },
    desc = "LSP: Open floating diagnostics",
})

-- Go to prev diagnostic ([d)
palette.add("LSP", "LSPPrevDiagnostic", {
    cmd = {
        name = "LSPPrevDiagnostic",
        cmd = function() vim.diagnostic.jump({ count = -1, float = true }) end,
    },
    keys = {
        { mode = "n", lhs = "[d", opts = {} },
    },
    desc = "LSP: Go to previous diagnostic",
})

-- Go to next diagnostic (]d)
palette.add("LSP", "LSPNextDiagnostic", {
    cmd = {
        name = "LSPNextDiagnostic",
        cmd = function() vim.diagnostic.jump({ count = 1, float = true }) end,
    },
    keys = {
        { mode = "n", lhs = "]d", opts = {} },
    },
    desc = "LSP: Go to next diagnostic",
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
    end
})

vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })

vim.diagnostic.config({ virtual_text = false })
local signs = {
    DapBreakpoint = {
        texthl = "DebugBreakpoint",
        text = ""
    }
}

for hl, sign in pairs(signs) do
    vim.fn.sign_define(hl, sign)
end

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        }
    }
})
