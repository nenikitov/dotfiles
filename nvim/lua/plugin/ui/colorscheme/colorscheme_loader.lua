local defs = require('defs')

---@module 'lazy'
---@module 'colorscheme_loader'
---@type LazySpec
return {
    'nenikitov/colorscheme-loader.nvim',
    lazy = false,
    priority = 1000,
    ---@type colorscheme_loader.Opts
    opts = {
        custom = defs.settings.colorschemes,
    },
}
