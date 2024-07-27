local plugins = {
    { import = "plugins" },
    {
        'mbbill/undotree',
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
    {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup({})
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        'natecraddock/sessions.nvim',
        config = function()
            require('sessions').setup({
                events = { "BufEnter", "VimLeavePre", "DirChangedPre" },
                session_filepath = vim.fn.stdpath('data') .. '/sessions/',
                absolute = true,
            })
        end,
    },
    {
        'danielfalk/smart-open.nvim',
        branch = "0.2.x",
        config = function()
            if vim.fn.filereadable(vim.fn.stdpath('config') .. '/lua/nix/sqlite.lua') ~= 0 then
                require('nix.sqlite')
            elseif vim.fn.filereadable('/usr/lib/x86_64-linux-gnu/libsqlite3.so') ~= 0 then
                vim.g.sqlite_clib_path = '/usr/lib/x86_64-linux-gnu/libsqlite3.so'
            end
            require('telescope').load_extension('smart_open')
        end,
        dependencies = { "kkharji/sqlite.lua" },
    },
}

local opts = {}

require("lazy").setup(plugins, opts)
