return {
    'folke/which-key.nvim',
    priority = 1,
    config = function()
        local which_key = require('which-key')

        which_key.setup {
            window = {
                border = 'single'
            }
        }

        for mode, group in pairs(require('neconfig.user.keymaps').which_key_prefixes()) do
            if mode == '' then
                mode = nil
            end
            which_key.register(group, { mode = mode, prefix = '' })
        end
    end
}
