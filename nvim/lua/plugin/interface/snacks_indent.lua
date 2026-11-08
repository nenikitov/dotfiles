---@module 'lazy'
---@module 'snacks'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.snacks,
    ---@type snacks.Config
    opts = {
        indent = {
            indent = {
                char = shared.icons.space.indent.space,
            },
            animate = {
                enabled = false,
            },
            scope = {
                char = shared.icons.space.indent.space,
            },
        },
    },
}
