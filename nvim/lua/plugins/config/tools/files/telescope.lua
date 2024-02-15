local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    config = function(_, opts)
        require('telescope').setup(opts)
        keymaps.telescope_open()
    end,
    opts = function()
        return {
            defaults = {
                default_mappings = keymaps.telescope_navigation(),
                prompt_prefix = icons.telescope.prompt .. ' ',
                selection_caret = icons.telescope.selection,
                borderchars = {
                    icons.border[2],
                    icons.border[4],
                    icons.border[6],
                    icons.border[8],
                    icons.border[1],
                    icons.border[3],
                    icons.border[5],
                    icons.border[7],
                },
            },
            pickers = {
                colorscheme = {
                    enable_preview = true,
                },
            },
        }
    end,
}
