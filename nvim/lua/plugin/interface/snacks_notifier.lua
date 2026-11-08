---@module 'lazy'
---@module 'snacks'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.snacks,
    ---@type snacks.Config
    opts = {
        notifier = {
            enabled = true,
            icons = {
                error = shared.icons.severity.error,
                warn = shared.icons.severity.warning,
                info = shared.icons.severity.info,
                debug = shared.icons.severity.debug,
                trace = shared.icons.severity.trace,
            },
            top_down = false,
        },
        styles = {
            notification = {
                winblend = 0,
            },
        }
    },
}
