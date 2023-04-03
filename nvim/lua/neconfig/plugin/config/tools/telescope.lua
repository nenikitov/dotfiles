return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local telescope = require('telescope')

        telescope.setup {
            defaults = {
                mappings = require('neconfig.user.keymaps').telescope_navigation(),
                prompt_prefix = require('neconfig.user.icons').telescope .. ' '
            },
            pickers = {
                colorscheme = {
                    enable_preview = true
                }
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown()
                },
            }
        }
        telescope.load_extension('ui-select')
        telescope.load_extension('notify')

        require('neconfig.user.keymaps').telescope_pickers()
    end
}
