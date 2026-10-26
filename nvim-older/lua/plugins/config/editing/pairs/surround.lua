local keymaps = require('user.keymaps')

return {
    'kylechui/nvim-surround',
    opts = {
        keymaps = keymaps.surround()
    },
}
