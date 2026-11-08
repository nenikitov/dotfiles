---@module 'lazy'
---@module 'snacks'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.snacks,
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
        spinner = {
            frames = shared.icons.ui.progress.spinner,
        },
    },
}
