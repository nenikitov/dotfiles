---@module 'lazy'
---@module 'smart-splits'

local shared = require('shared')

---@type LazySpec
return {
    'smart-splits-nvim/smart-splits.nvim',
    -- TODO: Figure out Partial<T>
    ---@diagnostic disable: missing-fields
    ---@type SmartSplitsSetupOpts
    opts = function()
        local handlers = shared.plugins.handlers
        handlers.focus_window:set('smart-splits', function(direction)
            require('smart-splits')['move_cursor_' .. direction]()
        end)
        handlers.swap_window:set('smart-splits', function(direction)
            require('smart-splits')['swap_buf_' .. direction]()
        end)
        handlers.resize_window:set('smart-splits', function(direction)
            require('smart-splits')['resize_' .. direction]()
        end)

        return {
            resize = {
                amount = 1,
            },
            move = { at_edge = 'stop' },
            swap = { move_cursor = true },
        }
    end,
}
