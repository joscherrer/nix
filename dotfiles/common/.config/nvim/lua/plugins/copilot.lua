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
                filestypes = {
                    yaml = true,
                    markdown = true,
                }
            })
        end,
    },
}
