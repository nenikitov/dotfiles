local keymaps = require('user.keymaps')

return {
    'danymat/neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function(_, opts)
        require('neogen').setup(opts)
        keymaps.neogen()
    end,
    opts = {
        snippet_engine = 'luasnip',
    },
}
