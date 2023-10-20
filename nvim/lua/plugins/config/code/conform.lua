local keymaps = require('user.keymaps')
local language = require('utils.language')

return {
    'stevearc/conform.nvim',
    dependencies = {
        'williamboman/mason.nvim',
    },
    config = function(_, opts)
        require('conform').setup(opts)
        keymaps.conform()
    end,
    opts = {
        formatters_by_ft = {
            ['*'] = { 'trim_newlines', 'trim_whitespace' },
            unpack(language.get_formatters()),
        },
    },
}
