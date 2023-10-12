local keymaps = require('user.keymaps')

return {
    'stevearc/conform.nvim',
    dependencies = {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function(_, opts)
        require('mason-tool-installer').setup {
            ensure_installed = require('languages.format')().install,
        }
        require('conform').setup(opts)

        keymaps.conform()
    end,
    opts = function()
        return {
            formatters_by_ft = require('languages.format')().filetypes,
        }
    end,
}
