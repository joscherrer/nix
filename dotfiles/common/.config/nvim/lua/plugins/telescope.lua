local picker_opts = { preview_title = false }

local fzf_build = ""

if vim.uv.os_uname().sysname == "Windows_NT" then
    fzf_build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cp build/Release/libfzf.dll build/libfzf.dll"
else
    fzf_build = "make"
end

return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim'
        },
        lazy = false,
        priority = 55,
        opts = {
            defaults = {
                winblend = vim.g.default_winblend,
                borderchars = require('bbrain.helpers').telescope.config.borderchars,
                layout_strategy = "center",
                layout_config = {
                    width = 0.7,
                },
                results_title = false,
                preview_title = false,
                file_ignore_patterns = {
                    ".git/"
                },
            },
            pickers = {
                find_files = {
                    hidden = true
                },
                live_grep = {
                    hidden = true,
                    additional_args = { "--hidden", "--iglob", "!.git" },
                }
            },
            extensions = {
                smart_open = {
                    match_algorithm = "fzf",
                },
                live_grep_args = {
                    auto_quoting = true,
                    additional_args = { "--hidden", "--iglob", "!.git" },
                }
            }
        },
        keys = {
            { "<leader>pf", function() require("telescope.builtin").find_files(picker_opts) end,                       mode = "n", desc = "Telescope: find_files" },
            { "<leader>pc", function() require("telescope.builtin").commands(picker_opts) end,                         mode = "n", desc = "Telescope: commands" },
            { "<leader>pb", function() require("telescope.builtin").buffers(picker_opts) end,                          mode = "n", desc = "Telescope: buffers" },
            { "<leader>pk", function() require("telescope.builtin").keymaps(picker_opts) end,                          mode = "n", desc = "Telescope: keymaps" },
            { "<leader>ps", function() require("telescope.builtin").lsp_workspace_symbols(picker_opts) end,            mode = "n", desc = "Telescope: LSP workspace symbols" },
            { "<leader>pg", function() require("telescope").extensions.live_grep_args.live_grep_args(picker_opts) end, mode = "n", desc = "Telescope: live_grep" },
            {
                "<leader><leader>",
                require("bbrain.helpers").toggle_smart_open,
                mode = "n",
                noremap = true,
                silent = true,
                desc =
                "Telescope: smart_open"
            },
        },
        config = function(_, opts)
            local telescope = require('telescope')
            local open_with_trouble = require("trouble.sources.telescope").open

            opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
                mappings = {
                    i = {
                        ["<c-t>"] = open_with_trouble,
                    },
                    n = {
                        ["<c-t>"] = open_with_trouble,
                    }
                }
            })
            local lga_actions = require("telescope-live-grep-args.actions")
            opts.extensions.live_grep_args.mappings = {
                i = {
                    ["<C-k>"] = lga_actions.quote_prompt(),
                    ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    -- freeze the current list and start a fuzzy search in the frozen list
                    ["<C-space>"] = lga_actions.to_fuzzy_refine,
                }
            }
            telescope.setup(opts)
            telescope.load_extension('fzf')
            telescope.load_extension('live_grep_args')
        end
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = fzf_build },
}
