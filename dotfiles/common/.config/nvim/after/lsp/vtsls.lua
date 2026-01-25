return {
    init_options = {
        hostInfo = 'neovim',
    },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
    },
    settings = {
        vtsls = {
            tsserver = {
                globalPlugins = {
                    {
                        name = "@vue/typescript-plugin",
                        location = vim.fs.dirname(vim.fn.exepath("vue-language-server")) ..
                            "/../lib/language-tools/packages/language-server/node_modules/@vue/typescript-plugin",
                        languages = { "vue" },
                        configNamespace = 'typescript',
                    }
                },
            }
        }
    }
}
