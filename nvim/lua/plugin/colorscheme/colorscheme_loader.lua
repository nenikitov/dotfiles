local defs = require('defs')

---@module 'lazy'
---@type LazySpec
return {
    'nenikitov/colorscheme-loader.nvim',
    lazy = false,
    priority = 1000,
    opts = {
        custom = defs.settings.colorschemes,
    },
}
