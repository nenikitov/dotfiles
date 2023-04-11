return {
    'rcarriga/nvim-notify',
    config = function()
        require('notify').setup {
            timeout = 2000,
            top_down = false,
            stages = 'slide',
            icons = (function()
                local icons = {}
                for k, v in pairs(require('neconfig.user.icons').notify) do
                    local case = require('neconfig.utils.case')
                    icons[case.convert_case(k, case.cases.SNAKE, case.cases.SCREAMING)] = v
                end
                return icons
            end)(),
        }
    end
}
