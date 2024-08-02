return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = false,
        opts = {
            defaults = {
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
                extensions = {
                    workspaces = {
                        -- keep insert mode after selection in the picker, default is false
                        keep_insert = true,
                    }
                }
            }
        },
        keys = {
            { "<leader>pf", function() require("telescope.builtin").find_files() end, mode = "n", desc = "Telescope: find_files" },
            { "<leader>pg", function() require("telescope.builtin").live_grep() end,  mode = "n", desc = "Telescope: live_grep" },
            { "<leader>pc", function() require("telescope.builtin").commands() end,   mode = "n", desc = "Telescope: commands" },
            { "<leader>pb", function() require("telescope.builtin").buffers() end,    mode = "n", desc = "Telescope: buffers" },
            { "<leader>pk", function() require("telescope.builtin").keymaps() end,    mode = "n", desc = "Telescope: keymaps" },
            {
                "<leader><leader>",
                function() require("telescope").extensions.smart_open.smart_open() end,
                mode = "n",
                noremap = true,
                silent = true,
                desc = "Telescope: smart_open"
            },
            -- {
            --     "<leader>pw",
            --     function() require("telescope").extensions.workspaces.workspaces() end,
            --     mode = "n",
            --     desc = "Telescope: workspaces"
            -- },
        },
    },
}
