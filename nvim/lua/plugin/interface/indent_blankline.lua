---@module 'lazy'
---@module 'ibl'

local shared = require('shared')
local util = require('util')

local icons = shared.icons.space.indent

---@type LazySpec
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = {'LazyFile', 'VeryLazy'},
    ---@type ibl.config
    opts = {
        indent = {
            char = shared.icons.space.indent.space,
            tab_char = icons.tab,
        },
        scope = {
            -- TODO: make this highlight indent level instead of the scope
            enabled = true,
            show_start = false,
            show_end = false,
        },
    },
    config = function(_, opts)
        require('ibl').setup(opts)
        require('ibl').overwrite({
            exclude = {
                filetypes = vim.tbl_filter(function(ft) return ft ~= '' end, require('ibl.config').config.exclude.filetypes),
            },
        })

        -- HACK: Force-refresh indent-blankline UI on events upstream missed
        util.vim.autocmd({
            -- The search preview scrolls the view without redrawing the guides
            { 'CmdlineChanged', pattern = { '/', '?' } },
            -- Ending or cancelling the search restores the view without redrawing the guides
            { 'CmdlineLeave', pattern = { '/', '?' } },
            -- Resizing vim can also auto scroll (horizontal scrolloff)
            'VimResized',
        }, {
            group = util.vim.augroup('ne.plugin.indent_blankline_refresh'),
            desc = 'Force-refresh indent-blankline UI on events upstream missed',
            callback = function(args)
                local function refresh() require('ibl').refresh(0) end
                -- On leave, the view is restored after the event, so refresh after that
                if args.event == 'CmdlineLeave' then
                    vim.schedule(refresh)
                else
                    refresh()
                end
            end,
        })
    end,
}
