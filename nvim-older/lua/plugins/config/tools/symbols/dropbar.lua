local icons = require('user.icons')
local keymaps = require('user.keymaps')

return {
    'Bekaboo/dropbar.nvim',
    dependencies = {
        'nvim-web-devicons',
        'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function(_, opts)
        require('dropbar').setup(opts)
        keymaps.dropbar_open()
    end,
    opts = function()
        return {
            icons = {
                kinds = {
                    symbols = vim.tbl_map(function(i)
                        return i .. ' '
                    end, icons.completion),
                },
                ui = icons.dropbar,
            },
            menu = {
                keymaps = keymaps.dropbar_navigation(),
                win_configs = {
                    border = icons.border,
                },
                entry = {
                    padding = {
                        left = 0,
                        right = 0,
                    },
                },
            },
        }
    end,
}
