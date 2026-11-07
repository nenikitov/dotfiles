---@module 'lazy'
---@module 'satellite'

local shared = require('shared')
local util = require('util')

---@type LazySpec
return {
    {
        'lewis6991/satellite.nvim',
        event = 'UIEnter',
        ---@type SatelliteConfig
        --- TODO: Figure out Partial<T>
        ---@diagnostic disable: missing-fields
        opts = {
            winblend = 0,
            handlers = {
                cursor = {
                    enable = true,
                    symbols = shared.icons.ui.progress.position,
                },
                search = {
                    enable = true,
                    symbols = shared.icons.ui.progress.count,
                },
                diagnostic = {
                    enable = true,
                    signs = {
                        error = shared.icons.ui.progress.count,
                        warn = shared.icons.ui.progress.count,
                        info = shared.icons.ui.progress.count,
                        hint = shared.icons.ui.progress.count,
                    },
                },
                gitsigns = {
                    enable = true,
                    signs = {
                        add = shared.icons.git.sign.added,
                        change = shared.icons.git.sign.changed,
                        delete = shared.icons.git.sign.deleted,
                    },
                },
                quickfix = {
                    signs = shared.icons.ui.progress.count,
                },
            },
        },
        ---@diagnostic enable: missing-fields
        config = function(_, opts)
            require('satellite').setup(opts)

            util.vim.autocmd_multiple_events({
                -- Splitting a window doesn't draw a scrollbar in the new one
                'WinNew',
                -- Having a noice CMD popup makes the scrollbar lag one resize behind
                'VimResized',
            }, {
                group = util.vim.augroup('ne.plugin.satellite_refresh'),
                desc = 'Force-refresh satellite UI on events upstream missed',
                callback = function()
                    vim.cmd.SatelliteRefresh()
                end,
            })
        end,
    },
}
