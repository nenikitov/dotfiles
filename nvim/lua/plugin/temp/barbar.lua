---@module 'lazy'
---@module 'barbar'

local shared = require('shared')

---@type LazySpec
return {
	'romgrk/barbar.nvim',
    enabled = false,
    event = { 'UIEnter' },
    ---@type barbar.config.options
    --- TODO: Figure out Partial<T>
    ---@diagnostic disable: missing-fields
    opts = {
        icons = {
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = shared.icons.severity.error },
                [vim.diagnostic.severity.WARN] = { enabled = true, icon = shared.icons.severity.warning },
                [vim.diagnostic.severity.INFO] = { enabled = false, icon = shared.icons.severity.info },
                [vim.diagnostic.severity.HINT] = { enabled = false, icon = shared.icons.severity.hint },
            },

            separator = shared.icons.buffer_line.inactive,
            separator_at_end = false,

            button = shared.icons.ui.close,

            current = {
                separator = shared.icons.buffer_line.current,
            },
            visible = {
                separator = shared.icons.buffer_line.visible,
            },
            inactive = {
                separator = shared.icons.buffer_line.inactive,
            },

            modified = {
                button = shared.icons.file.modified,
            },
        },
        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        minimum_length = 0,
    },
    ---@diagnostic enable: missing-fields
    init = function() vim.g.barbar_auto_setup = false end,
}
