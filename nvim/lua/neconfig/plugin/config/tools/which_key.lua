return {
    'folke/which-key.nvim',
    config = function()
        local which_key = require('which-key')

        which_key.setup {
            window = {
                border = 'single'
            }
        }

        require('neconfig.user.keymaps').which_key_prefixes_register(function(mode, keys, description)
            which_key.register(
                { name = description },
                {
                    prefix = keys,
                    mode = mode
                }
            )
        end)
    end
}
