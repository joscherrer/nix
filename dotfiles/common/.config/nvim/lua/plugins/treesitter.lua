return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = {
                "python",
                "go",
                "gosum",
                "gomod",
                "markdown",
                "nix",
                "json",
                "terraform",
                "hcl",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "vue",
                "javascript",
                "dockerfile"
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            highlight = {
                enable = true,
                disable = { "dockerfile" },
                additional_vim_regex_highlighting = false,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "Select outer function" },
                        ["if"] = { query = "@function.inner", desc = "Select inner function" },
                        ["ac"] = { query = "@class.outer", desc = "Select outer class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inner class" },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    include_surrounding_whitespace = true,
                }
            }
            -- indent = {
            --     enable = true,
            -- },
        }
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" }
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        enable = false,
        opts = {}
    }
}
