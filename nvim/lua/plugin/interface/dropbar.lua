---@module 'lazy'
---@module 'dropbar'

local util = require('util')
local shared = require('shared')

---@type LazySpec
return {
    'Bekaboo/dropbar.nvim',
    event = 'UIEnter',
    keys = {
        util.map
            :k('[;', 'Go to start of current context')
            :bind({'n', 'x', 'o'}, function() require('dropbar.api').goto_context_start() end)
            :spec(),
        util.map
            :k('];', 'Go to context sibling')
            :bind({'n', 'x', 'o'}, function() require('dropbar.api').select_next_context() end)
            :spec(),
        shared.keys.find
            :k(';', 'context')
            :bind('n', function() require('dropbar.api').pick() end)
            :spec(),
    },
    ---@return dropbar_configs_t
    opts = function()
        return {
            icons = {
                kinds = {
                    dir_icon = function(path)
                        local icon, hl = require('mini.icons').get('directory', path)
                        return icon .. ' ', hl
                    end,
                    -- TODO: Should I add more icons to shared or use existing ones here?
                    symbols = {
                    },
                },
                ui = {
                    bar = {
                        separator = ' ' .. shared.icons.ui.next .. ' ',
                        extends = shared.icons.ui.ellipsis,
                    },
                    menu = {
                        separator = ' ',
                        indicator = shared.icons.ui.closed,
                    },
                },
            }
        }
    end,
}
