return {
    'cameronr/auto-session',
    -- 'rmagatti/auto-session',
    lazy = false,
    dependencies = {
        'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
    },
    opts = {
        auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        auto_session_allowed_dirs = { '~/dev/*' },
        auto_session_enable_last_session = false,
        session_lens = {
            load_on_setup = true,
        },
        no_restore_cmds = {
            function()
                if #vim.fn.argv() == 0 then
                    require("auto-session").RestoreSession()
                end
            end,
        }
    },
    keys = {
        { '<leader>pw', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    },
}
