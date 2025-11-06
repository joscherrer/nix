local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp_capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

return {
    capabilities = lsp_capabilities,
    -- init_options = {
    --     plugins = {
    --         {
    --             name = "@vue/typescript-plugin",
    --             location = vue_language_server_path,
    --             languages = { "vue" },
    --         }
    --     }
    -- }
}
