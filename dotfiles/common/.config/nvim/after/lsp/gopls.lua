return {
    cmd = { 'gopls' },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true
            }
        },
        textDocument = {
            completion = {
                dynamicRegistration = true,
                completionItem = {
                    snippetSupport = true,
                    commitCharactersSupport = true,
                    deprecatedSupport = true,
                    preselectSupport = true,
                    tagSupport = {
                        valueSet = {
                            1, -- Deprecated
                        },
                    },
                    insertReplaceSupport = true,
                    resolveSupport = {
                        properties = {
                            "documentation",
                            "additionalTextEdits",
                            "insertTextFormat",
                            "insertTextMode",
                            "command",
                        },
                    },
                    insertTextModeSupport = {
                        valueSet = {
                            1, -- asIs
                            2, -- adjustIndentation
                        }
                    },
                    labelDetailsSupport = true,
                },
                contextSupport = true,
                insertTextMode = 1,
                completionList = {
                    itemDefaults = {
                        'commitCharacters',
                        'editRange',
                        'insertTextFormat',
                        'insertTextMode',
                        'data',
                    }
                }
            },
        },
    },
    settings = {
        gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            build = {
                directoryFilters = {
                    "**/node_modules"
                }
            }
        },
    },
    init_options = {
        usePlaceholders = true,
    },
    on_attach = function(client, _)
        client.capabilities.workspace.didChangeWatchedFiles = nil
    end
}
