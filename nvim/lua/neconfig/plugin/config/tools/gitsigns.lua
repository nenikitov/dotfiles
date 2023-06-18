local utils_table = require('neconfig.utils.table')

return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {
            signs = utils_table.pairs_map(
                require('neconfig.user.icons').gitsigns,
                function(key, value)
                    return key, { text = value }
                end
            ),
            preview_config = {
                border = 'single'
            },
            on_attach = function(bufnr)
                require('neconfig.user.keymaps').gitsigns()
            end
        }
    end
}
