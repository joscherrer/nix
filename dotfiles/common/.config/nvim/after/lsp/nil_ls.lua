local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp_capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

return {
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
}
