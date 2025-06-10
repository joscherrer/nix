local plugins = {
    { import = "plugins" },
    {
        'mbbill/undotree',
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_WindowLayout = 4
            vim.g.undotree_TreeVertShape = '│'
            vim.g.undotree_TreeSplitShape = '╱'
            vim.g.undotree_TreeReturnShape = '╲'
            vim.g.undotree_TreeNodeShape = ''
            vim.g.undotree_ShortIndicators = 1
        end,
    },
    {
        'kylechui/nvim-surround',
        opts = {
            surrounds = {
                ["("] = false,
                ["{"] = false,
                ["["] = false,
            },
            aliases = {
                ["("] = ")",
                ["{"] = "}",
                ["["] = "]",
            },
        }
    },
    { 'numToStr/Comment.nvim', opts = {} },
    -- { 'windwp/nvim-autopairs',  event = "InsertEnter", opts = {} },
    {
        'danielfalk/smart-open.nvim',
        branch = "0.2.x",
        config = function()
            if vim.fn.filereadable(vim.fn.stdpath('config') .. '/lua/nix/sqlite.lua') ~= 0 then
                require('nix.sqlite')
            elseif vim.fn.filereadable('/usr/lib/x86_64-linux-gnu/libsqlite3.so') ~= 0 then
                vim.g.sqlite_clib_path = '/usr/lib/x86_64-linux-gnu/libsqlite3.so'
            elseif vim.fn.filereadable(vim.fn.stdpath('data') .. '/sqlite/sqlite3.dll') ~= 0 then
                vim.g.sqlite_clib_path = vim.fn.stdpath('data') .. '/sqlite/sqlite3.dll'
            end
            require('telescope').load_extension('smart_open')
        end,
        dependencies = { "kkharji/sqlite.lua" },
    },
    {
        'folke/trouble.nvim',
        opts = {
            focus = true,
            warn_no_results = false,
            open_no_results = true,
        },
        cmd = "Trouble",
    },
    {
        'nvim-pack/nvim-spectre',
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = false },
        },
        keys = {
            { "<leader>S",  "<cmd>lua require('spectre').toggle()<CR>",                             mode = "n", desc = "Toggle Spectre" },
            { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",      mode = "n", desc = "Search current word" },
            { "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<CR>",                   mode = "v", desc = "Search current word" },
            { "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", mode = "n", desc = "Search on current file" },
        },
        opts = {
            use_trouble_qf = true,
            live_update = true,
            find_engine = {
                ['rg'] = {
                    cmd = "rg",
                    args = {
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--no-ignore-dot'
                    }
                }
            },
        },
    },
    {
        "grapp-dev/nui-components.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim"
        }
    },
    {
        "akinsho/toggleterm.nvim",
        opts = {
            direction = "horizontal",
            shading_factor = 10,
            winbar = {
                enabled = true,
                name_formatter = function(term) --  term: Terminal
                    local Path = require("plenary.path")
                    local dir = Path:new(term.dir)
                    return vim.fn.join({ term.id, dir:normalize("~") }, ":")
                end,
            },
            float_opts = {
                border = "solid",
                row = 1,
                col = function()
                    return math.ceil(vim.o.columns * 0.05)
                end,
                height = function()
                    return math.ceil(vim.o.lines * 0.5)
                end,
                width = function()
                    return math.ceil(vim.o.columns * 0.9)
                end,
                winblend = vim.g.default_winblend,
            },
            on_open = function(term)
                vim.keymap.set({ "n", "t" }, "<A-h>", function()
                    require("bbrain.helpers").next_term(true)
                end, { desc = "Next Terminal" })
                vim.keymap.set({ "n", "t" }, "<A-l>", function()
                    require("bbrain.helpers").next_term(false)
                end, { desc = "Previous Terminal" })
                vim.keymap.set({ "n", "t" }, "<A-n>", function()
                    require("bbrain.helpers").new_term()
                end, { desc = "New Terminal" })
                vim.keymap.set({ "n", "t" }, "<A-q>", function()
                    require("bbrain.helpers").close_term()
                end, { desc = "Close Terminal" })
            end,
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)
            vim.api.nvim_set_hl(0, "WinBarActive", { fg = "#98c379", underline = true })
            vim.api.nvim_set_hl(0, "WinBarInactive", { link = "Comment" })

            local ui = require("toggleterm.ui")
            local helpers = require('bbrain.helpers')

            _G.___toggleterm_winbar_new_click = helpers.winbar_new_click
            _G.___toggleterm_winbar_click = helpers.winbar_click

            ui.winbar_orig = ui.winbar
            ui.winbar = function(term)
                local winbar = ui.winbar_orig(term)
                winbar = winbar .. "%@v:lua.___toggleterm_winbar_new_click@%#Normal#➕%* "
                return winbar
            end

            -- Switch to the next terminal when the shell in the current terminal is closed
            vim.api.nvim_create_autocmd("TermClose", {
                callback = function(event)
                    local terms = require("toggleterm.terminal")
                    local next_term

                    local all_terms = terms.get_all()
                    if #all_terms < 2 then
                        return
                    end

                    if vim.g.bbrain_just_closed_terminal then
                        vim.g.bbrain_just_closed_terminal = false
                        return
                    end

                    for i, term in ipairs(terms.get_all()) do
                        if term.bufnr == event.buf then
                            next_term = all_terms[i + 1] or all_terms[i - 1] or all_terms[1]
                            break
                        end
                    end

                    if next_term then
                        vim.notify("TermClose: " .. event.buf .. " -> " .. next_term.id, vim.log.levels.DEBUG,
                            { title = "ToggleTerm" })
                        next_term:open()
                        next_term:focus()
                    end
                end,
            })
        end,
        keys = {
            { "<C-`>", function() require("toggleterm").toggle() end,             mode = { "n", "v", "i", "t" }, desc = "Toggle Terminal" },
            { "<A-h>", function() require("bbrain.helpers").next_term(true) end,  mode = { "t" },                desc = "Next Terminal" },
            { "<A-l>", function() require("bbrain.helpers").next_term(false) end, mode = { "t" },                desc = "Previous Terminal" },
        }
    },
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        },
        opts = {
        },
    },
    {
        "echasnovski/mini.move", version = false, opts = {}
    },
    {
        "echasnovski/mini.pairs", version = false, opts = {}
    },
    {
        'mrjones2014/smart-splits.nvim',
        event = 'VeryLazy',
        dependencies = {
            'pogyomo/submode.nvim',
        },
        opts = {
            default_amount = 5,
            resize_mode = {
                quit_key = '<C-S-Esc>',
                resize_keys = { "<Left>", "<Down>", "<Up>", "<Right>" },
            }
        },
        config = function(_, opts)
            local submode = require('submode')
            submode.create('WinResize', {
                mode = 'n',
                enter = '<leader>sr',
                leave = { '<Esc>', 'q', '<C-c>' },
                hook = {
                    on_enter = function()
                        vim.notify('Use { h, j, k, l } or { <Left>, <Down>, <Up>, <Right> } to resize the window')
                    end,
                    on_leave = function()
                        vim.notify('')
                    end,
                },
                default = function(register)
                    register('h', require('smart-splits').resize_left, { desc = 'Resize left' })
                    register('j', require('smart-splits').resize_down, { desc = 'Resize down' })
                    register('k', require('smart-splits').resize_up, { desc = 'Resize up' })
                    register('l', require('smart-splits').resize_right, { desc = 'Resize right' })
                    register('<Left>', require('smart-splits').resize_left, { desc = 'Resize left' })
                    register('<Down>', require('smart-splits').resize_down, { desc = 'Resize down' })
                    register('<Up>', require('smart-splits').resize_up, { desc = 'Resize up' })
                    register('<Right>', require('smart-splits').resize_right, { desc = 'Resize right' })
                end,
            })
            require("smart-splits").setup(opts)
        end,
    },
    { 'pogyomo/submode.nvim' },
    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     main = "ibl",
    --     opts = {}
    -- },
    {
        "ramilito/kubectl.nvim",
        opts = {
            kubectl_cmd = { cmd = "kubectl", env = { KUBECONFIG = vim.fn.expand("~/.config/kube/config") } },
        },
    },
    {
        "grafana/vim-alloy",
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        build = "make tiktoken",
        opts = {}
    }
    -- {
    --     'kevinhwang91/nvim-ufo',
    --     dependencies = {
    --         'kevinhwang91/promise-async',
    --     },
    --     config = function()
    --         -- vim.o.foldcolumn = '1' -- '0' is not bad
    --         -- vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    --         -- vim.o.foldlevelstart = 99
    --         -- vim.o.foldenable = true
    --
    --         vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end)
    --         vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end)
    --
    --         require('ufo').setup()
    --     end,
    -- }
}

local opts = {}

require("lazy").setup(plugins, opts)
