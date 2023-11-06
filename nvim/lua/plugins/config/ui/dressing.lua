local icons = require('user.icons')

return {
    'stevearc/dressing.nvim',
    opts = function()
        return {
            input = {
                border = icons.border,
                win_options = {
                    listchars = vim.o.listchars,
                },
            },
            select = {
                telescope = require('telescope.themes').get_dropdown {
                    borderchars = require('plugins.config.tools.telescope').opts().defaults.borderchars
                },
            },
        }
    end,
}
