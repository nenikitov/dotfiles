local keymaps = require('user.keymaps')

return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    config = function(_, opts)
        require('neo-tree').setup(opts)
        keymaps.neo_tree_open()
    end,
    opts = {
        popup_border_style = 'single',
        window = {
            position = 'float',
            popup = {
                border = 'single',
            },
        },
    },
}
