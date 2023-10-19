local keymaps = require('user.keymaps')

return {
    'stevearc/conform.nvim',
    dependencies = {
        'williamboman/mason.nvim',
    },
    config = function(_, opts)
        require('conform').setup(opts)
        keymaps.conform()
    end,
    opts = function()
        return {
            formatters_by_ft = {
                ['*'] = { 'trim_newlines', 'trim_whitespace' },
            },
        }
    end,
}
