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
            auto_session_allowed_dirs = { '~/dev/*', '~/dev/bbrain-io/*' },
            auto_session_enable_last_session = vim.g.neovide and #vim.fn.argv() == 0,
            auto_restore_lazy_delay_enabled = true,
            close_unsupported_windows = true,
            silent_restore = false,
            -- log_level = "debug",
            session_lens = {
                load_on_setup = true,
                previewer = false,
                theme_conf = {
                    borderchars = require("telescope.config").values.borderchars
                }
            },
            cwd_change_handling = {
                restore_upcoming_session = true,
                pre_cwd_changed_hook = function()
                    require("bbrain.helpers").close_terminals()
                end,
                post_cwd_changed_hook = function()
                    local as = require("auto-session")
                    if not as.session_exists_for_cwd() then
                        require("bbrain.helpers").close_all_buffers()
                        as.AutoSaveSession()
                    end
                end
            },
            no_restore_cmds = {
                function()
                    if #vim.fn.argv() == 0 then
                        vim.notify("Restoring last session")
                        require("auto-session").RestoreSession()
                    end
                end,
            },
            pre_save_cmds = {
                function()
                    require("bbrain.helpers").close_terminals()
                    require("nvim-tree.api").tree.close()
                    require("dapui").close()
                end,
            },
            post_restore_cmds = {
                function()
                    local root = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                    local relfile = require("plenary.path"):new(vim.fn.expand("%:.")):shorten(8, { -1, -2, -3 })

                    vim.o.title = true
                    vim.o.titlestring = root .. " - " .. relfile
                end,
            }
        }
    end,
    keys = {
        { '<leader>pw', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    },
}
