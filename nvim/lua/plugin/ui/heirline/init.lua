---@module 'lazy'
---@module 'heirline'

local defs = require('defs')
local util = require('util')

---@type LazySpec
return {
    'rebelot/heirline.nvim', -- for statusline and tabline
    dependencies = { defs.plugins.mini_icons },
    event = 'UIEnter',
    config = function()
        local cursor = require('plugin.ui.heirline.cursor')
        local file = require('plugin.ui.heirline.file')
        local git = require('plugin.ui.heirline.git')
        local input = require('plugin.ui.heirline.input')
        local layout = require('plugin.ui.heirline.layout')
        local lsp = require('plugin.ui.heirline.lsp')

        -- Statusline widths for `layout.by_width`
        local WIDE   = 175 -- icons
        local MEDIUM = 150 -- secondary details
        local NARROW = 80  -- context

        -- Flexible priorities for `layout.flexible`
        local ESSENTIAL = 1

        local mode_highlights = {
            normal           = 'StatusLine',
            operator_pending = 'StatusLine',
            insert           = 'DiffAdd',
            visual           = 'Visual',
            visual_line      = 'Visual',
            visual_block     = 'Visual',
            select           = 'Visual',
            select_line      = 'Visual',
            select_block     = 'Visual',
            replace          = 'DiffDelete',
            visual_replace   = 'DiffDelete',
            command          = 'DiffText',
            ex               = 'DiffText',
            more             = 'DiffText',
            confirm          = 'DiffText',
            shell            = 'DiffText',
            terminal         = 'DiffChange',
        }

        local statusline = layout.statusline({
            highlight = function(active, section, mode)
                if not active then
                    return 'StatusLineNC'
                end
                local distance = math.abs(section)
                if distance >= 3 then
                    return mode_highlights[mode] or 'StatusLine'
                elseif distance == 2 then
                    return 'TabLine'
                end
                return 'TabLineSel'
            end,

            section_separator = function(section)
                return section < 0 and defs.icons.status_line.section.left or defs.icons.status_line.section.right
            end,

            component_separator = function(section)
                return section < 0 and defs.icons.status_line.component.left or defs.icons.status_line.component.right
            end,

            -- ┌───┬───┬───┬───────────────────────────┬───┬───┬───┐
            -- │-3 │-2 │-1 │ 0 ///////////////////// 0 │ 1 │ 2 │ 3 │
            -- └───┴───┴───┴───────────────────────────┴───┴───┴───┘
            active = {
                [-3] = {
                    input.mode(),
                    input.selection(),
                    input.recording(),
                },
                [-2] = {
                    layout.by_width({
                        { min = WIDE, git.branch() },
                        { min = NARROW, git.branch({ icon = false }) },
                    }),
                    layout.by_width({
                        { min = WIDE, git.diff({ show_when_zero = 'with_nonzero' }) },
                        { min = MEDIUM, git.diff({ show_when_zero = 'with_nonzero', icon = false }) },
                        { min = 0, git.diff({ show_when_zero = false, icon = false }) },
                    }),
                },
                [-1] = {
                    layout.flexible(
                        { shorten = ESSENTIAL },
                        file.name({ name = 'full' }),
                        file.name({ name = 'full', max_directory_length = 20 }),
                        file.name({ name = 'shorten' }),
                        file.name({ name = 'filename' })
                    ),
                    file.flags(),
                },
                [1] = {
                    layout.by_width({
                        { min = WIDE, file.encoding() },
                        { min = MEDIUM, file.encoding({ icon = false }) },
                    }),
                    layout.by_width({
                        { min = WIDE, file.line_ending() },
                        { min = MEDIUM, file.line_ending({ icon = false }) },
                    }),
                    file.indent(),
                    layout.by_width({
                        { min = WIDE, file.filetype() },
                        { min = NARROW, file.filetype({ icon = false }) },
                    }),
                },
                [2] = {
                    layout.by_width({
                        { min = WIDE, lsp.diagnostics({ show_when_zero = false }) },
                        { min = 0, lsp.diagnostics({ show_when_zero = false, icon = false }) },
                    }),
                    layout.by_width({
                        { min = MEDIUM, lsp.progress() },
                        { min = 0, lsp.progress({ percentage = false }) },
                    }),
                    layout.by_width({
                        { min = NARROW, lsp.clients() },
                    }),
                },
                [3] = {
                    layout.by_width({
                        { min = MEDIUM, cursor.scroll() },
                    }),
                    layout.by_width({
                        { min = MEDIUM, cursor.location() },
                        { min = 0, cursor.location({ line_width = 0, column_width = 0 }) },
                    }),
                },
            },

            inactive = {
                [-1] = { file.name({ name = 'filename' }) },
                [1] = { cursor.location() },
            },
        })

        require('heirline').setup({ statusline = statusline })

        local group = vim.api.nvim_create_augroup('ne.heirline', { clear = true })

        -- Redraw, at most once per tick
        local pending = false
        local function redraw()
            if pending then
                return
            end
            pending = true
            vim.schedule(function()
                pending = false
                vim.cmd.redrawstatus({ bang = true })
            end)
        end

        local events = {}
        for _, module in ipairs({ input, file, git, lsp, cursor }) do
            vim.list_extend(events, module.events or {})
        end

        util.vim.autocmd_multiple_events(events, {
            group = group,
            callback = redraw,
        })

        -- Recreate merged highlight groups after colorscheme changes
        util.vim.autocmd_multiple_events({
            'ColorScheme',
            { 'OptionSet', pattern = 'background' },
        }, {
            group = group,
            callback = function()
                require('heirline.utils').on_colorscheme({})
            end,
        })
    end,
}
