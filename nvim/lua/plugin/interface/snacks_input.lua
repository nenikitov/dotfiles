---@module 'lazy'
---@module 'snacks'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.snacks,
    ---@type snacks.Config
    opts = {
        input = {
            enabled = true,
            icon = shared.icons.cmdline.input,
        },
    },
}
