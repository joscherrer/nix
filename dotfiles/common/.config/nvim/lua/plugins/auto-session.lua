return {
    -- 'cameronr/auto-session',
    'rmagatti/auto-session',
    lazy = false,
    priority = 45,
    dependencies = {
        'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
    },
    opts = function()
        -- >>> uncomment to debug
        -- vim.notify = function(msg, level, o)
        --     local logfile = vim.fn.stdpath("state") .. "/mylogs.log"
        --     local file = io.open(logfile, "a")
        --     if file then
        --         file:write(msg .. "\n")
        --         file:close()
        --     else
        --         print("Could not open log file: " .. logfile)
        --     end
        -- end

        return {
            suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            auto_create = function()
                local Path = require("plenary.path")
                local cwd = Path:new(vim.fn.getcwd())

                vim.notify("auto_create eval for: " .. cwd.filename, vim.log.levels.DEBUG)
                vim.notify("  parents: " .. vim.inspect(cwd:parents()), vim.log.levels.DEBUG)

                if vim.tbl_contains(cwd:parents(), cwd.path.home .. "/dev") then
                    return true
                end
                return false
            end,
            auto_save = true,
            auto_restore = true,
            auto_restore_last_session = #vim.fn.argv() == 0 or
                (vim.loop.cwd() == vim.loop.os_homedir() and vim.g.neovide),
            lazy_support = true,
            close_unsupported_windows = true,
            lsp_stop_on_restore = true,
            show_auto_restore_notif = true,
            -- log_level = "debug",
            session_lens = {
                load_on_setup = true,
                previewer = false,
                theme_conf = {
                    borderchars = require("telescope.config").values.borderchars
                }
            },
            cwd_change_handling = true,
            pre_cwd_changed_cmds = {
                function()
                    vim.notify("Changing directory")
                    require("bbrain.helpers").close_terminals()
                    require("nvim-tree.api").tree.close()
                    require("dapui").close()
                end
            },
            post_cwd_changed_cmds = {
                function()
                    local as = require("auto-session")
                    if not as.session_exists_for_cwd() then
                        require("bbrain.helpers").close_all_buffers()
                    end
                    as.AutoSaveSession()
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
                    vim.notify("Saving session")
                    require("bbrain.helpers").close_terminals()
                    require("nvim-tree.api").tree.close()
                    require("dapui").close()
                end,
            },
            post_restore_cmds = {
                function()
                    require("auto-session").AutoSaveSession()
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
