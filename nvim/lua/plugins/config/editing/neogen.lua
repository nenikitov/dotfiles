local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    'danymat/neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function(_, opts)
        local neogen = require('neogen')

        neogen.setup(opts)

        keymaps.neogen()
    end,
    opts = {
        snippet_engine = 'luasnip',
    },
}
