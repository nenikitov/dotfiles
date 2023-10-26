local icons = require('user.icons')

return {
    'Bekaboo/dropbar.nvim',
    dependencies = {
        'nvim-web-devicons',
    },
    config = true,
    opts = {
        icons = {
            kinds = {
                symbols = vim.tbl_map(function(i)
                    return i .. ' '
                end, icons.completion),
            },
        },
    },
}
