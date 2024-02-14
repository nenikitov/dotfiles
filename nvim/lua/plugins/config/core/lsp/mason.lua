local keymaps = require('user.keymaps')
local icons = require('user.icons')
local language = require('utils.language')

return {
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        opts = {
            ensure_installed = {
                unpack(language.get_mason()),
            },
        },
    },
    {
        'williamboman/mason.nvim',
        config = function(_, opts)
            require('mason').setup(opts)
            keymaps.mason_open()
        end,
        opts = {
            ui = {
                border = icons.border,
                icons = icons.mason,
                keymaps = keymaps.mason_navigation(),
            },
        },
    },
}
