---@module 'lazy'
---@module 'barbar'

local defs = require('defs')

---@type LazySpec
return {
	'romgrk/barbar.nvim',
    event = { 'UIEnter' },
    enabled = false,
    init = function() vim.g.barbar_auto_setup = false end,
    ---@type barbar.config.options
    ---@diagnostic disable: missing-fields
    opts = {
        icons = {
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = defs.icons.severity.error },
                [vim.diagnostic.severity.WARN] = { enabled = true, icon = defs.icons.severity.warning },
                [vim.diagnostic.severity.INFO] = { enabled = false, icon = defs.icons.severity.info },
                [vim.diagnostic.severity.HINT] = { enabled = false, icon = defs.icons.severity.hint },
            },

            separator = defs.icons.buffer_line.inactive,
            separator_at_end = false,

            button = defs.icons.ui.close,

            current = {
                separator = defs.icons.buffer_line.current,
            },
            visible = {
                separator = defs.icons.buffer_line.visible,
            },
            inactive = {
                separator = defs.icons.buffer_line.inactive,
            },

            modified = {
                button = defs.icons.file.modified,
            },
        },
        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        minimum_length = 0,
    },
}
