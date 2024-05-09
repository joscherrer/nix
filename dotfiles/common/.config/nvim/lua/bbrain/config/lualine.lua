return function()
    local overseer = require('overseer')
    require('lualine').setup({
        sections = {
            lualine_x = { {
                "overseer",
                label = '',
                colored = true,
                symbols = {
                    [overseer.STATUS.FAILURE] = "🔴",
                    [overseer.STATUS.CANCELED] = "🔵",
                    [overseer.STATUS.SUCCESS] = "🟢",
                    [overseer.STATUS.RUNNING] = "🟡",
                },
                unique = false,
                name = nil,
                name_not = false,
                status = nil,
                status_not = false,
            } },
        },
    })
end
