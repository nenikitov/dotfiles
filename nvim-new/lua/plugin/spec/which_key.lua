local icon = require('util.icon')

return {
    -- INFO: change origin to `'folke/which-key.nvim'` when this PR gets merged
    -- https://github.com/folke/which-key.nvim/pull/964
    'iguanacucumber/which-key.nvim',
    opts = {
        win = {
            padding = { 0, 0 },
        },
        -- TODO: configure those
        icons = {
            mappings = false,
            breadcrumb = icon.ui.next,
            separator = "-",
            group = icon.ui.filled .. ' ',
            ellipsis = icon.ui.more,
            rules = {},
            keys = {
                Up = icon.key.up,
                Down = icon.key.down,
                Left = icon.key.left,
                Right = icon.key.right,
                C = icon.key.ctrl,
                M = icon.key.alt,
                D = icon.key.super,
                S = icon.key.shift,
                CR = icon.key.enter,
                NL = icon.key.enter,
                Esc = icon.key.escape,
                ScrollWheelDown = icon.key.mouse_wheel_down,
                ScrollWheelUp = icon.key.mouse_wheel_up,
                BS = icon.key.backspace,
                Space = icon.key.space,
                Tab = icon.key.tab,
                F1 =  icon.key.f1,
                F2 =  icon.key.f2,
                F3 =  icon.key.f3,
                F4 =  icon.key.f4,
                F5 =  icon.key.f5,
                F6 =  icon.key.f6,
                F7 =  icon.key.f7,
                F8 =  icon.key.f8,
                F9 =  icon.key.f9,
                F10 = icon.key.f10,
                F11 = icon.key.f11,
                F12 = icon.key.f12,
            },
        },
    },
    event = 'VeryLazy',
    config = function(_, opts)
        require('which-key').setup(opts)

        vim.api.nvim_create_autocmd("VimResized", {
            group = vim.api.nvim_create_augroup("WhichKey", { clear = true }),
            callback = function()
                require('which-key.view').update()
            end
        })
    end
}
