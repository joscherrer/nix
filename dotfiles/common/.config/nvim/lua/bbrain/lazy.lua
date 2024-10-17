vim.defer_fn(function()
    vim.notify("Reminder to check if PR #76 has been merged", vim.log.levels.WARN, { title = "smart-open.nvim" })
end, 1000)

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
    { 'kylechui/nvim-surround', opts = {} },
    { 'numToStr/Comment.nvim',  opts = {} },
    -- { 'windwp/nvim-autopairs',  event = "InsertEnter", opts = {} },
    {
        -- 'danielfalk/smart-open.nvim',
        -- branch = "0.2.x",
        'scottmckendry/smart-open.nvim',
        commit = "698442805d3f4a577abfd7141cd5278306fe04ed",
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
            }
        },
        keys = {
            { "<C-`>", function() require("toggleterm").toggle() end, mode = { "n", "v", "i", "t" }, desc = "Toggle Terminal" }
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
        opts = {
            default_amount = 5,
            resize_mode = {
                quit_key = '<C-S-Esc>',
                resize_keys = { "<Left>", "<Down>", "<Up>", "<Right>" },
            }
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    {
        "ramilito/kubectl.nvim",
        opts = {
            kubectl_cmd = { cmd = "kubectl", env = { KUBECONFIG = vim.fn.expand("~/.config/kube/config") } },
        },
    },
}

local opts = {}

require("lazy").setup(plugins, opts)
