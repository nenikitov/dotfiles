local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
    },
    config = true,
    opts = function()
        return {
            ui = {
                border = icons.border,
                icons = icons.mason,
                keymaps = keymaps.mason_navigation(),
            },
        }
    end
}
