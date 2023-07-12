local utils_table = require('neconfig.utils.table')

return {
    'Bekaboo/dropbar.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = function()
        require('dropbar').setup {
            icons = {
                kinds = {
                    symbols = utils_table.pairs_map(
                        require('neconfig.user.icons').completion,
                        function(key, value)
                            return key, value .. ' '
                        end
                    )
                },
                ui = {
                    bar = {
                        separator = ' > '
                    }
                }
            }
        }
    end
}
