local icons = require('user.icons')
local keymaps = require('user.keymaps')

return {
    'folke/which-key.nvim',
    priority = 900,
    config = function(_, opts)
        local which_key = require('which-key')

        which_key.setup(opts)

        keymaps.whichkey_register(function(mode, keys, o)
            if mode == '' then
                mode = nil
            end

            which_key.register({ name = o.description }, {
                prefix = keys,
                mode = mode,
                buffer = o.buffer,
            })
        end)
    end,
    opts = {
        window = {
            border = icons.border,
        },
        icons = icons.whichkey,
    },
}
