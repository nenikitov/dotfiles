---@module 'lazy'
---@module 'heirline'

local defs = require('defs')

---@class ne.plugin.heirline.Component : StatusLine
---@field id? integer[]
---@field winnr? integer
---@field fallthrough? boolean
---@field flexible? integer
---@field _tree? table
---@field _updatable_components? table
---@field _flexible_components? table

---@type LazySpec
return {
    'rebelot/heirline.nvim', -- for statusline and tabline
    dependencies = { defs.plugins.mini_icons },
    event = 'UIEnter',
    config = function()
        local mode = require('plugin.ui.heirline.mode')
        local file = require('plugin.ui.heirline.file')

        ---@type ne.plugin.heirline.Component
        local statusline = { mode.Block, file.Block }

        require('heirline').setup({
            statusline = statusline,
        })
    end
}
