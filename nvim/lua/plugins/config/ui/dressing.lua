local icons = require('user.icons')

return {
    'stevearc/dressing.nvim',
    opts = function()
        return {
            input = {
                -- Is handled by Noice
                enabled = false,
            },
            select = {
                telescope = require('telescope.themes').get_dropdown {
                    borderchars = require('plugins.config.tools.telescope').opts().defaults.borderchars
                },
            },
        }
    end,
}
