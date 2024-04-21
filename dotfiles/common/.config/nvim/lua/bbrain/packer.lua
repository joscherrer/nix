-- TODO: remove this when updating to neovim 0.10
-- function vim.list_contains(t, value)
--     if not vim.version.lt(vim.version(), { 0, 10, 0 }) then
--         vim.notify("Please remove the vim.list_contains() function in lua/bbrain/packer.lua")
--     end
--     vim.validate({ t = { t, 't' } })
--     --- @cast t table<any,any>
--
--     for _, v in ipairs(t) do
--         if v == value then
--             return true
--         end
--     end
--     return false
-- end

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use "olimorris/onedarkpro.nvim"
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }
    use "nvim-lua/plenary.nvim"
    use {
        'theprimeagen/harpoon',
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }
    use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons', }, }
    use { 'mbbill/undotree' }
    use { 'rcarriga/nvim-notify' }

    --    if list_contains({ "bbrain-mbp.local" }, vim.fn.hostname()) then
    use {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            vim.notify("Starting copilot.lua")
            require("copilot").setup({})
            vim.notify("copilot.lua started", vim.log.levels.INFO)
        end,
    }
    use {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use {
        'natecraddock/workspaces.nvim'
    }
    --    end
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
