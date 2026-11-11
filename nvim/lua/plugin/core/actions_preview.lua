---@module 'lazy'

local shared = require('shared')

---@type LazySpec
return {
    'aznhe21/actions-preview.nvim',
    event = 'LazyFile',
    opts = function()
        local handlers = shared.plugins.handlers
        handlers.code_action:set('actions_preview', function() require('actions-preview').code_actions() end)

        return {
            highlight_command = {
                require("actions-preview.highlight").delta(),
                require("actions-preview.highlight").diff_so_fancy(),
                require("actions-preview.highlight").diff_highlight(),
            },
        }
    end,
}
