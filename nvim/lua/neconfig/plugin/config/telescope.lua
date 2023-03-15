return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local telescope = require('telescope')

        telescope.setup {
            defaults = {
                mappings = require('neconfig.user.keymaps').telescope_navigation(),
                prompt_prefix = require('neconfig.user.icons').telescope .. ' '
            }
        }

        require('neconfig.user.keymaps').telescope_pickers()
    end
}
