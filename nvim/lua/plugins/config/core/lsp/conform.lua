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
        default_format_opts = {
            lsp_format = "fallback";
        },
        formatters_by_ft = vim.tbl_deep_extend('force', {
            ['*'] = { 'trim_newlines', 'trim_whitespace' },
        }, language.formatters()),
        log_level = vim.log.levels.DEBUG,
    },
}
