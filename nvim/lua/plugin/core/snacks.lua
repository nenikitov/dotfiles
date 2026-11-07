---@module 'lazy'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.snacks,
    lazy = false,
    priority = 1000,
}
