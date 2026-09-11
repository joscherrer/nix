return {
    on_attach = function()
    end,
    cmd = {
        "Microsoft.CodeAnalysis.LanguageServer",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
        "--stdio",
    },
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
}
