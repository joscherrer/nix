return {
    -- 'cameronr/auto-session',
    'rmagatti/auto-session',
    lazy = false,
    priority = 45,
    dependencies = {
        'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
    },
    opts = function()
        return {
            auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            auto_session_allowed_dirs = { '~/dev/*' },
            auto_session_enable_last_session = vim.g.neovide and #vim.fn.argv() == 0,
            session_lens = {
                load_on_setup = true,
                theme_conf = {
                    borderchars = require("telescope.config").values.borderchars
                }
            },
            no_restore_cmds = {
                function()
                    if #vim.fn.argv() == 0 then
                        vim.notify("Restoring last session")
                        require("auto-session").RestoreSession()
                    end
                end,
            }
        }
    end,
    keys = {
        { '<leader>pw', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    },
}
