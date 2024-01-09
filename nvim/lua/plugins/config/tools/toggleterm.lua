local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    {
        'akinsho/toggleterm.nvim',
        opts = {
            open_mapping = keymaps.toggleterm_open(),
            shade_terminals = false,
            persist_size = false,
            persist_mode = false,
            direction = 'float',
            float_opts = {
                border = icons.border,
            },
            highlights = {
                FloatBorder = { link = 'WinSeparator' }
            }
        },
    },
}
