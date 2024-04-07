require("onedarkpro").setup({})

vim.api.nvim_set_hl(0, "StatusLine", { bg = "#abb2bf", fg = "#313640", cterm = { bold = true }, bold = true })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#abb2bf", bg = "#313640" })
