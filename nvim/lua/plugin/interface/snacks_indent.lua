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
                tab_char = shared.icons.space.indent.tab,
            },
            animate = {
                enabled = false,
            },
            scope = {
                char = shared.icons.space.indent.space,
                tab_char = shared.icons.space.indent.tab,
            },
        },
    },
}
