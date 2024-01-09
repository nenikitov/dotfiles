local icons = require('user.icons')

return {
    'lewis6991/satellite.nvim',
    opts = {
        winblend = 0,
        handlers = {
            cursor = {
                symbols = icons.satellite.moving,
            },
            search = {
                symbols = icons.satellite.search,
            },
            diagnostic = {
                signs = icons.satellite.increasing,
            },
            gitsigns = {
                signs = icons.satellite.git,
            },
            quickfix = {
                signs = icons.satellite.increasing,
            },
        },
    },
}
