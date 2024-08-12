local picker_opts = { preview_title = false }


return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = false,
        priority = 55,
        opts = {
            defaults = {
                winblend = 20,
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
                }
            }
        },
        keys = {
            { "<leader>pf", function() require("telescope.builtin").find_files(picker_opts) end,            mode = "n", desc = "Telescope: find_files" },
            { "<leader>pg", function() require("telescope.builtin").live_grep(picker_opts) end,             mode = "n", desc = "Telescope: live_grep" },
            { "<leader>pc", function() require("telescope.builtin").commands(picker_opts) end,              mode = "n", desc = "Telescope: commands" },
            { "<leader>pb", function() require("telescope.builtin").buffers(picker_opts) end,               mode = "n", desc = "Telescope: buffers" },
            { "<leader>pk", function() require("telescope.builtin").keymaps(picker_opts) end,               mode = "n", desc = "Telescope: keymaps" },
            { "<leader>ps", function() require("telescope.builtin").lsp_workspace_symbols(picker_opts) end, mode = "n", desc = "Telescope: LSP workspace symbols" },
            {
                "<leader><leader>",
                function() require("telescope").extensions.smart_open.smart_open({ preview_title = false }) end,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Telescope: smart_open"
            },
        },
        config = function(_, opts)
            require('telescope').setup(opts)
            require('telescope').load_extension('fzf')
        end
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
