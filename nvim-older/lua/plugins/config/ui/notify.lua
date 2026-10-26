local icons = require('user.icons')

return {
    'rcarriga/nvim-notify',
    config = function(_, opts)
        local notify = require('notify')
        notify.setup(opts)
        vim.notify = notify
    end,
    opts = {
        stages = 'slide',
        timeout = 2000,
        top_down = false,
        icons = (function()
            local i = {}
            for k, v in pairs(icons.notify) do
                i[k:upper()] = v
            end
            return i
        end)(),
        on_open = function(win)
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_config(win, { border = icons.border })
            end
        end,
    },
}
