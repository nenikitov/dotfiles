return {
    'rcarriga/nvim-notify',
    dependencies = {
        'nenikitov/nvim-lsp-notify'
    },
    config = function()
        local notify = require('notify')
        local lsp_notify = require('lsp-notify');

        notify.setup {
            timeout = 2000,
            top_down = false,
            stages = 'slide',
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { border = 'none' })
            end,
            icons = (function()
                local icons = {}
                for k, v in pairs(require('neconfig.user.icons').notify) do
                    local case = require('neconfig.utils.case')
                    icons[case.convert_case(k, case.cases.SNAKE, case.cases.SCREAMING)] = v
                end
                return icons
            end)(),
        }

        lsp_notify.setup {
            notify = notify
        }
    end
}
