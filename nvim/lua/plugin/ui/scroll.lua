---@module 'lazy'
---@module 'satellite'

local defs = require('defs')
local util = require('util')

---@type LazySpec
return {
    {
        'lewis6991/satellite.nvim',
        enabled = true,
        event = { 'UIEnter' },
        config = function (_, opts)
            require('satellite').setup(opts)

            local group = util.vim.augroup('ne.satellite')
            vim.api.nvim_create_autocmd({ 'WinNew' }, {
                group = group,
                callback = function()
                    vim.cmd("SatelliteRefresh")
                end,
            })

        end,
        ---@type SatelliteConfig
        ---@diagnostic disable: missing-fields
        opts = {
            winblend = 0,
            handlers = {
                cursor = {
                    enable = true,
                    symbols = defs.icons.status.position,
                },
                search = {
                    enable = true,
                },
                diagnostic = {
                    enable = true,
                    symbols = defs.icons.status.count,
                },
                gitsigns = {
                    enable = true,
                    signs = {
                        add = defs.icons.diff_bar.added,
                        change = defs.icons.diff_bar.changed,
                        delete = defs.icons.diff_bar.deleted,
                    },
                },
                quickfix = {
                    signs = defs.icons.status.count,
                },
            },
        },
        ---@diagnostic enable: missing-fields
    },
}
