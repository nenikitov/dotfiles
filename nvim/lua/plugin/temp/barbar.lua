---@module 'lazy'
---@module 'barbar'

local shared = require('shared')

---@type LazySpec
return {
	'romgrk/barbar.nvim',
    enabled = false,
    event = 'UIEnter',
    -- TODO: Figure out Partial<T>
    ---@diagnostic disable: missing-fields
    ---@type barbar.config.options
    opts = {
        icons = {
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = shared.icons.severity.error },
                [vim.diagnostic.severity.WARN] = { enabled = true, icon = shared.icons.severity.warning },
                [vim.diagnostic.severity.INFO] = { enabled = false, icon = shared.icons.severity.info },
                [vim.diagnostic.severity.HINT] = { enabled = false, icon = shared.icons.severity.hint },
            },

            separator = {
                left = shared.icons.separator.buffer.inactive.left,
                right = shared.icons.separator.buffer.inactive.right,
            },
            separator_at_end = false,

            button = shared.icons.ui.close,

            current = {
                separator = {
                    left = shared.icons.separator.buffer.current.left,
                    right = shared.icons.separator.buffer.current.right,
                },
            },
            visible = {
                separator = {
                    left = shared.icons.separator.buffer.visible.left,
                    right = shared.icons.separator.buffer.visible.right,
                },
            },
            inactive = {
                separator = {
                    left = shared.icons.separator.buffer.inactive.left,
                    right = shared.icons.separator.buffer.inactive.right,
                },
            },

            modified = {
                button = shared.icons.file.states.modified,
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
