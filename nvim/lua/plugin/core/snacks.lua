---@module 'lazy'
---@module 'snacks'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.snacks,
    lazy = false,
    priority = 1000,
    ---@return snacks.Config
    opts = function(_, opts)
        local handlers = shared.plugins.handlers
        handlers.close_buffer:set('snacks_delete', function() require('snacks').bufdelete() end)

        vim.print = require('snacks').debug.inspect

        return vim.tbl_deep_extend('force', opts, {
            spinner = {
                frames = shared.icons.ui.progress.spinner,
            },
        })
    end
}
