local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    'williamboman/mason.nvim',
    dependencies = {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'williamboman/mason-lspconfig.nvim',
    },
    config = function(_, opts)
        require('mason-tool-installer').setup {
            ensure_installed = opts.ensure_installed
        }

        require('mason').setup(opts)
        keymaps.mason_open()
    end,
    opts = function()
        return {
            ensure_installed = {},
            ui = {
                border = icons.border,
                icons = icons.mason,
                keymaps = keymaps.mason_navigation(),
            },
        }
    end,
}
