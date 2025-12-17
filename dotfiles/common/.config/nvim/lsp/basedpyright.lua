return {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
            pythonPath = vim.fn.exepath("python3.13")
        },
    },
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}
