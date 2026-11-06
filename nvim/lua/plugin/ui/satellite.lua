---@module 'lazy'
---@module 'satellite'

local defs = require('defs')
local util = require('util')

---@type LazySpec
return {
    {
        'lewis6991/satellite.nvim',
        event = { 'UIEnter' },
        ---@type SatelliteConfig
        --- TODO: Figure out Partial<T>
        ---@diagnostic disable: missing-fields
        opts = {
            winblend = 0,
            handlers = {
                cursor = {
                    enable = true,
                    symbols = defs.icons.progress.position,
                },
                search = {
                    enable = true,
                },
                diagnostic = {
                    enable = true,
                    symbols = defs.icons.progress.count,
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
                    signs = defs.icons.progress.count,
                },
            },
        },
        ---@diagnostic enable: missing-fields
        config = function (_, opts)
            require('satellite').setup(opts)

            vim.api.nvim_create_autocmd({ 'WinNew' }, {
                group = util.vim.augroup('ne.plugin.satellite_refresh'),
                desc = 'Redraw scrollbars when windows are split',
                callback = function()
                    vim.cmd("SatelliteRefresh")
                end,
            })

        end,
    },
}
