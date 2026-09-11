return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        opts = {
            enabled = true,
        }
    }
}
