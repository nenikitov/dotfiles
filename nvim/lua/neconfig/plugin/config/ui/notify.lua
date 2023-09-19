local utils_table = require('neconfig.utils.table')
local utils_case = require('neconfig.utils.case')

return {
    'rcarriga/nvim-notify',
    config = function()
        require('notify').setup {
            timeout = 2000,
            top_down = false,
            stages = 'slide',
            icons = utils_table.pairs_map(
                require('neconfig.user.icons').notify,
                function(key, value)
                    return
                        utils_case.convert_case(key, utils_case.cases.SNAKE, utils_case.cases.SCREAMING),
                        value .. ' '
                end
            )
        }
    end
}
