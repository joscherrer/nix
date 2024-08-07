if vim.env.JFROG_IDE_URL then
    return {}
end

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot" },
        event = { "InsertEnter" },
        lazy = true,
        config = function()
            require("copilot").setup({
                suggestion = {
                    enable = true,
                    auto_trigger = true,
                },
                filetypes = {
                    yaml = true,
                    markdown = true,
                }
            })
        end,
    },
}
