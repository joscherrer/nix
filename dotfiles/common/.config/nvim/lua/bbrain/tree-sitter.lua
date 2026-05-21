local ts = require("nvim-treesitter")

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'cs', 'lua', 'markdown', 'json', 'javascript', 'typescript', 'dockerfile', 'vue', 'go', 'python', 'nix', 'terraform', 'tf', 'yaml' },
    callback = function() vim.treesitter.start() end,
})

ts.install({
    "yaml",
    "python",
    "go",
    "gosum",
    "gomod",
    "markdown",
    "nix",
    "json",
    "terraform",
    "hcl",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "vue",
    "javascript",
    "dockerfile",
    "vue"
})
