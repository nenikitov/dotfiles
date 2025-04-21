return {
    'echasnovski/mini.nvim',
    config = function(_, opts)
        for k, v in pairs(opts) do
            require('mini.' .. k).setup(v)
        end
    end,
    opts = {
        ai = {
            n_lines = 500,
            silent = true
        },
        jump = {
            delay = {
                highlight = 0,
                idle_stop = 1000,
            },
            silent = true
        },
        icons = {
            lsp = {
                array         = { glyph = '' },
                boolean       = { glyph = '󱎖' },
                class         = { glyph = '' },
                color         = { glyph = '󰸌' },
                constant      = { glyph = '' },
                constructor   = { glyph = '' },
                enum          = { glyph = '' },
                enummember    = { glyph = '' },
                event         = { glyph = '⚡' },
                field         = { glyph = '' },
                file          = { glyph = '' },
                folder        = { glyph = '' },
                ['function']  = { glyph = '' },
                interface     = { glyph = '' },
                key           = { glyph = '' },
                keyword       = { glyph = '' },
                method        = { glyph = '' },
                module        = { glyph = '' },
                namespace     = { glyph = '' },
                null          = { glyph = '' },
                number        = { glyph = '' },
                object        = { glyph = '' },
                operator      = { glyph = '' },
                package       = { glyph = '' },
                property      = { glyph = '' },
                reference     = { glyph = '' },
                snippet       = { glyph = '󰩫' },
                string        = { glyph = '' },
                struct        = { glyph = '' },
                text          = { glyph = '' },
                typeparameter = { glyph = '' },
                unit          = { glyph = '' },
                value         = { glyph = '' },
                variable      = { glyph = '' },
            },
        }
    },
    event = 'VeryLazy'
}
