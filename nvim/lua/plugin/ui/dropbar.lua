---@module 'lazy'
---@module 'dropbar'

local util = require('util')
local defs = require('defs')

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
        defs.keys.find
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
                    -- TODO: Should I add more icons to defs or use existing ones here?
                    symbols = {
                    },
                },
                ui = {
                    bar = {
                        separator = ' ' .. defs.icons.ui.next .. ' ',
                        extends = defs.icons.ui.ellipsis,
                    },
                    menu = {
                        separator = ' ',
                        indicator = defs.icons.ui.closed,
                    },
                },
            }
        }
    end,
}
