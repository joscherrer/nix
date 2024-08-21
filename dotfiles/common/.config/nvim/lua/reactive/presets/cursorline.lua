return {
    name = 'cursorline',
    init = function()
        vim.opt.cursorline = true
    end,
    static = {
        hl = {
            TreesitterContext = { bg = '#353847' },
        },
        winhl = {
            inactive = {
                CursorLine = { bg = '#282a36' },
                CursorLineNr = { fg = '#b0b0b0', bg = '#202020' },
            },
        },
    },
    modes = {
        no = {
            operators = {
                -- switch case
                [{ 'gu', 'gU', 'g~', '~' }] = {
                    winhl = {
                        CursorLine = { bg = '#334155' },
                        CursorLineNr = { fg = '#cbd5e1', bg = '#334155' },
                    },
                },
                -- change
                c = {
                    winhl = {
                        CursorLine = { bg = '#162044' },
                        CursorLineNr = { fg = '#93c5fd', bg = '#162044' },
                    },
                },
                -- delete
                d = {
                    winhl = {
                        CursorLine = { bg = '#56303B' },
                        CursorLineNr = { fg = '#fca5a5', bg = '#56303B' },
                    },
                },
                -- yank
                y = {
                    winhl = {
                        CursorLine = { bg = '#422006' },
                        CursorLineNr = { fg = '#fdba74', bg = '#422006' },
                    },
                },
            },
        },
        i = {
            -- green #273B39
            winhl = {
                CursorLine = { bg = '#2F3F59' },
                CursorLineNr = { fg = '#5eead4', bg = '#2F3F59' },
            },
        },
        c = {
            winhl = {
                CursorLine = { bg = '#202020' },
                CursorLineNr = { fg = '#ffffff', bg = '#303030' },
            },
        },
        n = {
            winhl = {
                CursorLine = { bg = '#2d303d' },
                CursorLineNr = { fg = '#ffffff', bg = '#2d303d' },
            },
        },
        -- visual
        [{ 'v', 'V', '\x16' }] = {
            winhl = {
                CursorLineNr = { fg = '#d8b4fe' },
                Visual = { bg = '#412F26' },
                -- Visual = { bg = '#3b0764' },
            },
        },
        -- select
        [{ 's', 'S', '\x13' }] = {
            winhl = {
                CursorLineNr = { fg = '#c4b5fd' },
                Visual = { bg = '#2e1065' },
            },
        },
        -- replace
        R = {
            winhl = {
                CursorLine = { bg = '#083344' },
                CursorLineNr = { fg = '#67e8f9', bg = '#083344' },
            },
        },
    },
}
