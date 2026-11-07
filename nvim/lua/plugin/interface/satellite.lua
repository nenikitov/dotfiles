---@module 'lazy'
---@module 'satellite'

local shared = require('shared')
local util = require('util')

---@type LazySpec
return {
    {
        'lewis6991/satellite.nvim',
        event = 'VeryLazy',
        -- TODO: Figure out Partial<T>
        ---@diagnostic disable: missing-fields
        ---@type SatelliteConfig
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

            -- HACK: Force-refresh satellite UI on events upstream missed
            util.vim.autocmd({
                -- Splitting a window doesn't draw a scrollbar in the new one
                'WinNew',
                -- Having a noice CMD popup makes the scrollbar lag one resize behind
                'VimResized',
                -- Git signs add a sign column to the scrollbar, which hides it until the next refresh widens it
                { 'User', pattern = 'GitSignsUpdate' },
            }, {
                group = util.vim.augroup('ne.plugin.satellite_refresh'),
                desc = 'Force-refresh satellite UI on events upstream missed',
                callback = function(args)
                    -- Satellite places the git signs asynchronously in its own handler for the same event, so refresh after it
                    if args.event == 'User' then
                        vim.defer_fn(vim.cmd.SatelliteRefresh, 50)
                    else
                        vim.cmd.SatelliteRefresh()
                    end
                end,
            })
        end,
    },
}
