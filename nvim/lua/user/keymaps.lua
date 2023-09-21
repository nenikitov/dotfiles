local M = {}

---@alias KeymapMode
---| '' Normal, Visual, Select, Operator-pending.
---| 'n' Normal.
---| 'v' Visual and Select.
---| 's' Select.
---| 'x' Visual.
---| 'o' Operator-pending.
---| '!' Insert, Command-line.
---| 'i' Insert.
---| 'l' Insert, Command-line, Lang.
---| 'c' Command-line.
---| 't' Terminal.

--- Default keymap options.
local default_options = {
    noremap = true,
    silent = true,
}

--- Add a keymap.
---@param modes KeymapMode | KeymapMode[] Modes in which keymap will exist.
---@param keys string Key combination.
---@param func string | fun() What to do when keymap is triggered.
---@param description string? Description.
---@param options table? Options.
local function map(modes, keys, func, description, options)
    options = vim.tbl_deep_extend('force', default_options, options or {})
    options.desc = description
    vim.keymap.set(modes, keys, func, options)
end

function M.general()
    -- Leader
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    map('', '<SPACE>', '<NOP>')

    -- Split
    map('', '<LEADER>bs', '<CMD>split<RETURN>', 'Split horizontally')
    map('', '<LEADER>bv', '<CMD>vsplit<RETURN>', 'Split vertically')

    -- Manipulation
    map('', '<LEADER>bn', '<CMD>enew<RETURN>', 'Create a new empty buffer')
    map('', '<LEADER>br', '<CMD>edit<RETURN>', 'Refresh buffer')
    map('', '<LEADER>bd', '<CMD>bdelete<RETURN>', 'Delete buffer')
    map('', '<LEADER>bq', '<CMD>quit<RETURN>', 'Quit window')
    map('', '<LEADER>bw', '<CMD>write<RETURN>', 'Write buffer')

    -- Go to
    map({'', 't'}, '<C-h>', '<CMD>wincmd h<RETURN>', 'Go to split on left')
    map({'', 't'}, '<C-j>', '<CMD>wincmd j<RETURN>', 'Go to split on bottom')
    map({'', 't'}, '<C-k>', '<CMD>wincmd k<RETURN>', 'Go to split on top')
    map({'', 't'}, '<C-l>', '<CMD>wincmd l<RETURN>', 'Go to split on right')

    -- Resize
    map('', '<A-h>', "<CMD>vertical resize -2<RETURN>")
    map('', '<A-j>', "<CMD>resize -1<RETURN>")
    map('', '<A-k>', "<CMD>resize +1<RETURN>")
    map('', '<A-l>', "<CMD>vertical resize +2<RETURN>")

    -- Indent without exiting visual
    map('x', '<', '<gv', 'Unindent without exiting visual')
    map('x', '>', '>gv', 'Indent without exiting visual')


    -- Yank in visual without moving
    map('x', 'y', 'ygv<ESC>', 'Yank without moving')

    -- Keep clipboard when pasting in visual mode
    map('x', 'p', '"_dP', 'Paste and keep the clipboard')

    -- Faster navigation
    map('', 'H', '^', 'To first non-blank character of the line')
    map('', 'L', '$', 'To the end of the line')

    -- Clear search
    map('', '<A-/>', function() vim.fn.setreg('/', '') end, 'Clear search')

    -- Remove whole words in insert mode
    map('i', '<C-BS>', '<C-w>', 'Remove word to the left')
    map('i', '<A-BS>', '<C-u>', 'Remove all to the left')

    -- Redo
    map('n', 'U', '<C-r>', 'Redo')

    -- Normal mode in ternimal
    map('t', '<ESC><ESC>', '<C-\\><C-n>')
end

function M.lazy_open()
    map('n', '<LEADER>pp', '<CMD>Lazy<CR>', 'Open package manager')
end

function M.telescope_open()
    local builtin = require('telescope.builtin')
    -- local extensions = require('telescope.extensions')

    map('n', '<LEADER>tt', builtin.builtin, 'Builtin pickers')

    map('n', '<LEADER>tf', builtin.find_files, 'Files')
    map(
        'n',
        '<LEADER>tg',
        function()
            vim.fn.system('git rev-parse --is-inside-work-tree')
            if vim.v.shell_error == 0 then
                builtin.git_files()
            else
                builtin.find_files()
            end
        end,
        'Git files'
    )
    map('n', '<LEADER>tr', builtin.live_grep, 'Regex')

    map('n', '<LEADER>tm', builtin.help_tags, 'Help')
    map('n', '<LEADER>th', builtin.highlights, 'Hightlights')
    map('n', '<LEADER>tc', builtin.colorscheme, 'Colorscheme')
    map('n', '<LEADER>tl', builtin.filetypes, 'File type')
end

function M.telescope_navigation()
    local actions = require('telescope.actions')

    return {
        i = {
            ['<C-q>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<RETURN>'] = actions.select_default,
            ['<C-l>'] = actions.select_default,
            ['<C-s>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['<C-y>'] = actions.preview_scrolling_up,
            ['<C-e>'] = actions.preview_scrolling_down,
            ['<TAB>'] = actions.toggle_selection,
            ['<C-w>'] = function()
                vim.api.nvim_input('<ESC>vbdi')
            end,
            ['<C-u>'] = function()
                vim.api.nvim_input('<ESC>v^di')
            end,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
        },
        n = {
            ['q'] = actions.close,
            ['<ESC>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['j'] = actions.move_selection_next,
            ['k'] = actions.move_selection_previous,
            ['<RETURN>'] = actions.select_default,
            ['<C-l>'] = actions.select_default,
            ['<C-s>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['gg'] = actions.move_to_top,
            ['G'] = actions.move_to_bottom,
            ['y'] = actions.preview_scrolling_up,
            ['e'] = actions.preview_scrolling_down,
            ['<TAB>'] = actions.toggle_selection,
            ['?'] = actions.which_key,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
        }
    }
end

function M.mason_navigation()
    return {
        toggle_package_expand = 'l',
        install_package = 'i',
        update_package = 'u',
        check_package_version = 'c',
        uninstall_package = 'd',
        update_all_packages = 'U',
        check_outdated_packages = 'C',
        cancel_installation = '<C-c>',
        apply_language_filter = 'f',
        toggle_package_install_log = 'l',
        toggle_help = '?',
    }
end

function M.completion()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local mapping = cmp.mapping

    local function map_cmp(callback)
        return mapping(callback, { 'i', 'c' })
    end

    return {
        ['<C-y>'] = map_cmp(mapping.scroll_docs(1)),
        ['<C-e>'] = map_cmp(mapping.scroll_docs(-1)),
        ['<C-j>'] = map_cmp(mapping.select_next_item()),
        ['<C-k>'] = map_cmp(mapping.select_prev_item()),
        ['<C-SPACE>'] = map_cmp(mapping.complete()),
        ['<C-q>'] = map_cmp(mapping.abort()),
        ['<C-l>'] = map_cmp(function(fallback)
            if cmp.visible() then
                cmp.confirm()
            else
                fallback()
            end
        end),
        ['<C-h>'] = map_cmp(function(fallback)
            if cmp.visible() then
                cmp.abort()
            else
                fallback()
            end
        end),
    }
end

function M.diagnostics()
end

return M