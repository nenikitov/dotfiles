return {
    'folke/which-key.nvim',
    priority = 900,
    config = function()
        local which_key = require('which-key')

        which_key.setup {
            window = {
                border = 'single'
            }
        }

        require('neconfig.user.keymaps').which_key_prefixes_register(function(mode, keys, description)
            if mode == '' then
                mode = nil
            end

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
