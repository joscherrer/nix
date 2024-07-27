return {
    {
        'stevearc/overseer.nvim',
        opts = {},
        config = function()
            require('overseer').setup({
                task_list = {
                    direction = "bottom",
                },
            })
        end,
    }
}
