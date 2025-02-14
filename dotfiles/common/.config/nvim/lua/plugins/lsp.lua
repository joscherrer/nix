local fs = require('luvit.fs')

local yaml_on_attach = function(client, bufnr)
    local predicate = function(v)
        return function(o)
            return o.name == v
        end
    end
    local getSymbol = function(symbols, key)
        for k, v in pairs(symbols) do
            if v.name == key then
                return v.detail
            end
        end
        return nil
    end
    local callback = function(_, result)
        local rootStrings = vim.tbl_filter(function(o) return o.kind == 15 end, result)
        local kind = getSymbol(rootStrings, "kind")
        local apiVersion = getSymbol(rootStrings, "apiVersion")

        if kind == nil or apiVersion == nil then
            return
        end

        local s = vim.split(apiVersion, "/")
        local group = s[1]
        local version = s[2]
        if #s < 2 then
            group = ""
            version = s[1]
        end
        local schemas = vim.fn.expand("$HOME/.datree/crdSchemas")
        kind = string.lower(kind)

        local schema = vim.fs.joinpath(schemas, group, kind .. "_" .. version .. ".json")
        local schema_s = vim.fs.joinpath(schemas, group, kind .. "s_" .. version .. ".json")
        if vim.fn.filereadable(schema) ~= 0 then
            vim.notify("Found: " .. schema, vim.log.levels.DEBUG)
            client.settings.yaml.schemas = {
                [schema] = vim.api.nvim_buf_get_name(bufnr)
            }
        elseif vim.fn.filereadable(schema_s) ~= 0 then
            vim.notify("Found: " .. schema_s, vim.log.levels.DEBUG)
            client.settings.yaml.schemas = {
                [schema_s] = vim.api.nvim_buf_get_name(bufnr)
            }
        else
            vim.notify("Kubernetes schema enabled", vim.log.levels.DEBUG)
            client.settings.yaml.schemas = {
                kubernetes = vim.api.nvim_buf_get_name(bufnr)
            }
        end

        client.notify('workspace/didChangeConfiguration', {
            settings = client.settings
        })
    end
    client.request('textDocument/documentSymbol', {
            textDocument = vim.lsp.util.make_text_document_params()
        },
        callback
    )
end

local yaml_multi_on_attach = function(client, bufnr)
    local helpers = require('bbrain.helpers')
    local http = require('bbrain.http')

    local getSymbol = function(symbols, key)
        local objs = {}
        for _, v in pairs(symbols) do
            if v.name == key then
                table.insert(objs, v.detail)
            end
        end
        return objs
    end
    local callback = function(_, result)
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
            local group, version = unpack(vim.split(apiVersions[i], "/"))
            local kind = string.lower(kinds[i])
            if version == nil then
                version = group
                group = ""
            end
            local schema = vim.fs.joinpath(schemas, group, kind .. "_" .. version .. ".json")
            local schema_s = vim.fs.joinpath(schemas, group, kind .. "s_" .. version .. ".json")
            if vim.fn.filereadable(schema) ~= 0 then
                vim.notify(i .. ": Found: " .. schema, vim.log.levels.DEBUG)
                ready = ready + 1
                fs.readFile(schema, function(_, data)
                    schemaSequence[i] = vim.json.decode(data)
                    ready = ready - 1
                end)
            elseif vim.fn.filereadable(schema_s) ~= 0 then
                vim.notify(i .. ": Found: " .. schema_s, vim.log.levels.DEBUG)
                ready = ready + 1
                fs.readFile(schema, function(_, data)
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
    client.request('textDocument/documentSymbol', {
            textDocument = vim.lsp.util.make_text_document_params()
        },
        callback
    )
end

local function lspconfig_config()
    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = "LSP: Open floating diagnostics" })
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { desc = "LSP: Go to previous diagnostic" })
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { desc = "LSP: Go to next diagnostic" })

    local helpers = require('bbrain.helpers')

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local palette = require('bbrain.palette')
            palette.add("LSP", "LSPHover", {
                cmd = { name = "vim.lsp.buf.hover()", cmd = function() vim.lsp.buf.hover() end },
                keys = { { mode = "n", lhs = "<S-k>", opts = { buffer = event.buf } } },
                desc = "LSP: Display hover information about symbol"
            })
            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
                { buffer = event.buf, desc = "LSP: Display hover information about symbol" })
            -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
            --     { buffer = event.buf, desc = "LSP: Show definition" })
            vim.keymap.set('n', 'gd', function() require('trouble').open({ mode = 'lsp_definitions' }) end,
                { buffer = event.buf, desc = "LSP: Show definition" })
            vim.keymap.set('n', 'gD', function() require('trouble').open({ mode = 'lsp_declarations' }) end,
                { buffer = event.buf, desc = "LSP: Show declaration" })
            vim.keymap.set('n', 'gi', function() require('trouble').open({ mode = 'lsp_implementations' }) end,
                { buffer = event.buf, desc = "LSP: Show implementation" })
            vim.keymap.set('n', 'go', function() require('trouble').open({ mode = 'lsp_type_definitions' }) end,
                { buffer = event.buf, desc = "LSP: Show type definition" })
            vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end,
                { buffer = event.buf, desc = "LSP: Show signature help" })
            vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end,
                { buffer = event.buf, desc = "LSP: Show signature help" })
            vim.keymap.set('n', 'gr', function() require('trouble').open({ mode = 'lsp_references' }) end,
                { buffer = event.buf, desc = "LSP: Show references" })
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>',
                { buffer = event.buf, desc = "LSP: Rename" })
            vim.keymap.set({ 'n', 'x' }, '<F3>', function() helpers.format(event.buf) end,
                { buffer = event.buf, desc = "Format document" })
            vim.keymap.set({ 'n', 'x' }, 'gq', function() helpers.format(event.buf) end,
                { buffer = event.buf, desc = "Format document" })
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',
                { buffer = event.buf, desc = "LSP: Code action" })
        end
    })

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    local default_setup = function(server)
        require('lspconfig')[server].setup({
            capabilities = lsp_capabilities,
        })
    end

    local lsp_server_list = {
        'bashls',
        'helm_ls',
        'tflint',
        'ansiblels',
        'yamlls',
    }

    if not vim.env.JFROG_IDE_URL then
        table.insert(lsp_server_list, 'gopls')
        table.insert(lsp_server_list, 'volar')
        table.insert(lsp_server_list, 'ts_ls')
    else
        table.insert(lsp_server_list, 'basedpyright')
        table.insert(lsp_server_list, 'marksman')
        table.insert(lsp_server_list, 'terraformls')
    end

    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = lsp_server_list,
        handlers = {
            default_setup,
        }
    })

    local lspconfig = require('lspconfig')
    vim.lsp.client.offset_encoding = 'utf-8'

    if not vim.env.JFROG_IDE_URL then
        lspconfig.gopls.setup({
            cmd = { 'gopls' },
            capabilities = lsp_capabilities,
            settings = {
                gopls = {
                    experimentalPostfixCompletions = true,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
            init_options = {
                usePlaceholders = true,
            },
            on_attach = function(client, _)
                client.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
            end
        })
    end

    lspconfig.nil_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
            ['nil'] = {
                formatting = {
                    command = { "nixfmt" }
                },
                nix = {
                    flake = {
                        autoArchive = true,
                    }
                },
            },
        },
    })

    lspconfig.lua_ls.setup({
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT'
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        "${3rd}/luv/library",
                        -- vim.fn.stdpath('data') .. '/lazy/noice.nvim',
                    }
                }
            })
        end,
        settings = {
            Lua = {}
        }
    })


    lspconfig.terraformls.setup({})
    lspconfig.marksman.setup({})
    lspconfig.jsonnet_ls.setup({})
    lspconfig.basedpyright.setup({
        on_init = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
        end,
    })
    lspconfig.csharp_ls.setup({})

    lspconfig.yamlls.setup({
        capabilities = vim.tbl_deep_extend('force', lsp_capabilities, {
            workspace = {
                didChangeConfiguration = {
                    dynamicRegistration = true
                }
            }
        }),
        -- on_attach = yaml_multi_on_attach,
        on_attach = require('bbrain.lsp.yamlls').on_attach,
        settings = {
            yaml = {
                format = {
                    enable = true
                },
                completion = {
                    enable = true
                },
                -- schemas = {
                --     ["https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json/kustomization.json"] =
                --     "kustomization.yaml",
                --     -- kubernetes = "*.yaml",
                --     ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                --     ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                --     ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                --     ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                --     ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                --     ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                --     ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                --     ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                --     ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                --     ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                --     "*api*.{yml,yaml}",
                --     ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                --     "*docker-compose*.{yml,yaml}",
                --     ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
                --     "*flow*.{yml,yaml}",
                -- }
            }
        }
    })

    local mason_registry = require('mason-registry')
    local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
        '/node_modules/@vue/language-server'


    lspconfig.volar.setup({
        -- init_options = {
        --     typescript = {
        --         tsdk = "node_modules/typescript/lib"
        --     }
        -- }
    })

    lspconfig.ts_ls.setup({
        capabilities = lsp_capabilities,
        init_options = {
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = vue_language_server_path,
                    languages = { "vue" },
                }
            }
        }
    })

    lspconfig.eslint.setup({
        capabilities = lsp_capabilities
    })

    vim.api.nvim_set_hl(0, "@odp.function.builtin.python", { link = "pythonBuiltin" })
    vim.api.nvim_set_hl(0, "@odp.import_module.python", { link = "Type" })
    vim.api.nvim_set_hl(0, "@keyword.operator.lua", { link = "Keyword" })

    vim.diagnostic.config({ virtual_text = false })
    local signs = {
        DiagnosticSignError = {
            texthl = "DiagnosticSignError",
            text = ''
        },
        DiagnosticSignWarn = {
            texthl = "DiagnosticSignWarn",
            text = " ",
        },
        DiagnosticSignHint = {
            texthl = "DiagnosticSignHint",
            text = " "
        },
        DiagnosticSignInformation = {
            texthl = "DiagnosticSignInformation",
            text = " "
        },
        DapBreakpoint = {
            texthl = "DebugBreakpoint",
            text = ""
        }
    }
    for hl, sign in pairs(signs) do
        vim.fn.sign_define(hl, sign)
    end
end

return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = function()
            local download_url_template
            if vim.env.JFROG_IDE_URL then
                download_url_template = vim.env.JFROG_IDE_URL .. "/artifactory/github/%s/releases/download/%s/%s"
            else
                download_url_template = "https://github.com/%s/releases/download/%s/%s"
            end
            require('mason').setup({
                providers = {
                    "mason.providers.client",
                    "mason.providers.registry-api",
                },
                github = {
                    download_url_template = download_url_template,
                },
            })
        end,
    },
    {
        'L3MON4D3/LuaSnip',
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
        end,
    },
    { 'saadparwaiz1/cmp_luasnip' },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp',             lazy = false },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = lspconfig_config
    },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        },
        config = function()
            -- local lsp_zero = require('lsp-zero')
            -- lsp_zero.extend_cmp()

            local cmp = require('cmp')

            cmp.setup({
                completion = {
                    autocomplete = {
                        "TextChanged"
                    },
                    completeopt = 'menu,menuone,noselect',
                    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
                    keyword_length = 1,
                    -- keyword_length = 1,
                    -- keyword_pattern = ".*",
                },
                -- formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    {
                        name = 'nvim_lsp',
                        trigger_characters = vim.split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
                    },
                    { name = 'path' },
                    { name = 'luasnip' },
                    { name = 'nvim_lsp_signature_help' },
                }, {
                    { name = 'buffer' },
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
                matching = { disallow_symbol_nonprefix_matching = false }
            })
            vim.keymap.set('c', '<C-y>', cmp.mapping.confirm({ select = true }))
        end
    },
}
