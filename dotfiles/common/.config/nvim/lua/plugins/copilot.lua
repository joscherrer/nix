if vim.env.JFROG_IDE_URL then
    return {}
end

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot" },
        event = { "InsertEnter" },
        config = function()
            require("copilot").setup({
                suggestion = {
                    enable = true,
                    auto_trigger = true,
                },
                filetypes = {
                    yaml = true,
                    markdown = true,
                },
                logger = {
                    file_log_level = vim.log.levels.WARN
                },
                server = {
                    type = "binary",
                    custom_server_filepath = "copilot-language-server"
                }
            })
        end,
    },
}
