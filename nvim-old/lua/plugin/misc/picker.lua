local icon = require('util.icon')
local tty = require('util.tty')


local function overwrite_defaults(keys_default, keys_new)
    local d = vim.iter(pairs(keys_default))
        :map(function(k) return {k, false} end)
        :fold({}, function(acc, e)
            acc[e[1]] = e[2]
            return acc
        end)
    return vim.tbl_deep_extend('force', d, keys_new)
end

return {
    'snacks.nvim',
    opts = function(_, opts)
        local defaults = require('snacks.picker.config.defaults').defaults

        return vim.tbl_deep_extend('force', opts, {
            picker = {
                prompt = icon.ui.prompt .. ' ',
                sources = {
                    files = { hidden = true },
                    grep = { hidden = true },
                },
                matcher = { sort_empty = true, },
                formatters = { severity = { pos = 'right' } },
                icons = {
                    files = {
                        dir_open = tty.gui_choose('󰝰', 'D')
                    },
                    tree = {
                        vertical = "│ ",
                        middle   = "├ ",
                        last     = "└ ",
                    },
                    ui = {
                        live = 'l',
                        selected = icon.ui.filled,
                        unselected = ' ',
                    },
                    git = {
                        commit = icon.version_control.commit,
                        staged = icon.version_control.staged,
                        added = icon.version_control.added,
                        deleted = icon.version_control.deleted,
                        ignored = icon.version_control.ignored,
                        modified = icon.version_control.modified,
                        renamed = icon.version_control.renamed,
                        unmerged = icon.version_control.unmerged,
                        untracked = icon.version_control.untracked,
                    },
                    lsp = {
                        unavailable = '[lsp none]',
                        enabled = '[lsp on]',
                        disabled = '[lsp off]',
                        attached = '[lsp]',
                    },
                    -- TODO: figure out if I need to add `diagnostics` and `kinds`
                    -- from [here](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/picker/config/defaults.lua#L361)
                    -- or they will be picked up once LSP is set up
                },
                layouts = {
                    default = {
                        layout = {
                            backdrop = false,
                            box = "horizontal",
                            width = 0.8,
                            height = 0.8,
                            {
                                box = "vertical",
                                border = vim.o.winborder or "rounded",
                                title = "{title} {live} {flags}",
                                { win = "input", height = 1, border = "bottom" },
                                { win = "list", border = "none" },
                            },
                            {
                                win = "preview",
                                title = "{preview}",
                                border = vim.o.winborder or "rounded",
                                width = 0.5
                            },
                        }
                    },
                    vertical = {
                        layout = {
                            backdrop = false,
                            width = 0.8,
                            height = 0.8,
                            box = "vertical",
                            border = vim.o.winborder or "rounded",
                            title = "{title} {live} {flags}",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                        },
                    },
                    vscode = {
                        preview = false,
                        layout = {
                            backdrop = false,
                            width = 0.8,
                            height = 0.8,
                            box = "vertical",
                            border = vim.o.winborder or "rounded",
                            title = "{title} {live} {flags}",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                        },
                    },
                    select = {
                        layout = {
                            border = vim.o.winborder or "rounded"
                        }
                    }
                },
                win = {
                    input = { keys = overwrite_defaults(defaults.win.input.keys, {
                        -- Focus
                        ['<m-c>'] = { 'close', mode = {'i', 'n'} },
                        ['q'] = { 'close' },
                        ['<esc>'] = { 'cancel' },
                        ['/'] = { 'toggle_focus' },
                        ['<c-/>'] = { 'toggle_focus', mode = {'i', 'n'} },
                        ['<a-m>'] = { 'toggle_maximize', mode = {'i', 'n'} },
                        -- Input
                        ['<C-w>'] = { '<c-s-w>', mode = 'i', expr = true, desc = 'Delete word' },
                        -- Navigation
                        ['j'] = { 'list_down' },
                        ['<c-j>'] = { 'list_down', mode = {'i', 'n'} },
                        ['k'] = { 'list_up' },
                        ['<c-k>'] = { 'list_up', mode = {'i', 'n'} },
                        ['G'] = { 'list_bottom' },
                        ['gg'] = { 'list_top' },
                        -- Flags
                        ['<a-f>'] = { 'toggle_follow', mode = {'i', 'n'}},
                        ['<a-h>'] = { 'toggle_hidden', mode = {'i', 'n'}},
                        ['<a-i>'] = { 'toggle_ignored', mode = {'i', 'n'}},
                        ['<a-p>'] = { 'toggle_preview', mode = {'i', 'n'}},
                        -- Accept
                        ['<c-l>'] = { 'confirm', mode = {'i', 'n'} },
                        ['<RETURN>'] = { 'confirm', mode = {'i', 'n'} },
                        ['<c-s>'] = { 'edit_split', mode = {'i', 'n'} },
                        ['<c-v>'] = { 'edit_vsplit', mode = {'i', 'n'} },
                        -- Other
                        ['<c-y>'] = { 'preview_scroll_up', mode = {'i', 'n'} },
                        ['<c-e>'] = { 'preview_scroll_down', mode = {'i', 'n'} },
                        ['?'] = { 'toggle_help_input' },
                    }) },
                    list = { keys = overwrite_defaults(defaults.win.list.keys, {
                        -- Focus
                        ['<m-c>'] = { 'close' },
                        ['q'] = { 'close' },
                        ['<esc>'] = { 'cancel' },
                        ['/'] = { 'toggle_focus' },
                        ['<c-/>'] = { 'toggle_focus' },
                        ['<a-m>'] = { 'toggle_maximize' },
                        -- Navigation
                        ['j'] = { 'list_down' },
                        ['k'] = { 'list_up' },
                        ['G'] = { 'list_bottom' },
                        ['gg'] = { 'list_top' },
                        -- Flags
                        ['<a-f>'] = { 'toggle_follow' },
                        ['<a-h>'] = { 'toggle_hidden' },
                        ['<a-i>'] = { 'toggle_ignored' },
                        ['<a-p>'] = { 'toggle_preview' },
                        -- Accept
                        ['l'] = { 'confirm' },
                        ['<RETURN>'] = { 'confirm' },
                        ['<2-LeftMouse>'] = { 'confirm' },
                        ['<c-s>'] = { 'edit_split' },
                        ['<c-v>'] = { 'edit_vsplit' },
                        -- Other
                        ['<c-y>'] = { 'preview_scroll_up' },
                        ['<c-e>'] = { 'preview_scroll_down' },
                        ['?'] = { 'toggle_help_list' },
                    }) },
                    preview = { keys = overwrite_defaults(defaults.win.preview.keys, {
                        -- Focus
                        ['<m-c>'] = { 'close' },
                        ['q'] = { 'close' },
                        ['<esc>'] = { 'cancel' },
                        ['/'] = { 'focus_input' },
                        ['<c-/>'] = { 'focus_input' },
                        ['a'] = { 'focus_input' },
                        ['A'] = { 'focus_input' },
                        ['<a-m>'] = { 'toggle_maximize' },
                        -- Other
                        ['?'] = { 'toggle_help_preview' },
                    }) },
                }
            },
        })
    end,
    keys = {
        -- Prefix
        { '<LEADER>f', '<NOP>', desc = 'find' },
        -- Main
        { '<LEADER>ff', function() Snacks.picker.files() end, desc = 'Files' },
        { '<LEADER>fg', function() Snacks.picker.grep() end, desc = 'Grep' },
        { '<LEADER>f:', function() Snacks.picker.command_history() end, desc = 'Command history' },
        { '<LEADER>f/', function() Snacks.picker.search_history() end, desc = 'Search history' },
        { '<LEADER>fm', function() Snacks.picker.help() end, desc = 'Help' },
        { '<LEADER>fM', function() Snacks.picker.man() end, desc = 'Man' },
        -- Secondary
        { '<LEADER>fP', function() Snacks.picker.pickers() end, desc = 'Pickers' },
        { '<LEADER>fC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
        { '<LEADER>fH', function() Snacks.picker.highlights() end, desc = 'Highlight groups' },
        { '<LEADER>fI', function() Snacks.picker.icons() end, desc = 'Icons' },
        { '<LEADER>fL', function() Snacks.picker.lazy() end, desc = 'Plugin specs' },
        { '<LEADER>fN', function() Snacks.picker.notifications() end, desc = 'Notifications' },
    },
}
