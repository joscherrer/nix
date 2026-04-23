return {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
            },
        },
    },
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}
