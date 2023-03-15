--#region Helpers

-- Imports
local log = require "neconfig.utils.log"

--- Module return.
local M = {}

---@alias Mode '' | 'n' | 'i' | 'c' | 'v' | 'x' | 'o' | 't'

--- List of modes.
---@type {string: Mode | Mode[]}
local mode = {
    NORMAL       = 'n',
    INSERT       = 'i',
    COMMAND      = 'c',
    VISUAL       = 'v',
    VISUAL_BLOCK = 'x',
    OPERATOR     = 'o',
    TERM         = 't',

    ALL          = '',
    NOT_TYPING   = { 'n', 'v', 'x' }
}

--- Default options for keyminds.
local default_options = {
    noremap = true,
    silent = true
}

--- Add a keymap.
---@param modes Mode | Mode[] Modes in which keymap will exist.
---@param keys string Key combination.
---@param func string | fun() What to do when keymap is triggered.
---@param description string? Description.
---@param options table? Options.
local function map(modes, keys, func, description, options)
    options = vim.tbl_deep_extend('force', default_options, options or {})
    options.desc = description
    vim.keymap.set(modes, keys, func, options)
end

--- Prefixes passed to WhichKey for more documentation.
local whichkey_prefixes = {}

--- Add a description to WhichKey prefix.
---@param modes Mode | Mode[] Modes in which prefix will exist.
---@param path string[] Key combination.
---@param description string Description.
local function add_to_whichkey_prefixes(modes, path, description)
    if type(modes) == 'string' then
        modes = { modes };
    end

    for _, m in ipairs(modes) do
        whichkey_prefixes[m] = whichkey_prefixes[m] or {}
        local target = whichkey_prefixes[m]
        for _, p in ipairs(path) do
            target[p] = target[p] or {}
        end
        target.name = description
    end
end

--#endregion



--#region Keymaps

--- WhichKey prefixes for better documentation.
function M.whichkey_prefixes()
    return whichkey_prefixes
end


--- General keymaps.
function M.general()
    -- Leader key
    add_to_whichkey_prefixes(mode.ALL, { '<LEADER>' }, 'custom')
    map(mode.ALL, '<SPACE>', '<NOP>')
    vim.g.mapleader = ' '

    -- Close
    map(mode.ALL, '<A-S-c>', '<CMD>quitall!<CR>', 'Force quit everything')

    -- Buffer
    add_to_whichkey_prefixes(mode.NOT_TYPING, { '<LEADER>', 'b' }, 'buffer/window')
    -- Split
    map(mode.NOT_TYPING, '<LEADER>bh',  '<CMD>split<CR>',   'Spilt window horizontally')
    map(mode.NOT_TYPING, '<LEADER>bv',  '<CMD>vsplit<CR>',  'Spilt window vertically')
    -- Manipulation
    map(mode.NOT_TYPING, '<LEADER>bn',  '<CMD>enew<CR>',      'Create a new empty buffer')
    map(mode.NOT_TYPING, '<LEADER>br',  '<CMD>edit<CR>',      'Refresh current buffer')
    map(mode.NOT_TYPING, '<LEADER>bd',  '<CMD>bdelete<CR>',   'Delete current buffer')
    map(
        mode.NOT_TYPING,
        '<LEADER>bc',
        function()
            local closed = pcall(vim.cmd, 'quit')
            if not closed then
                log.error('Cannot close this window')
            end
        end,
        'Close current window'
    )
    -- Go to
    map({ mode.NORMAL, mode.TERM }, '<A-k>',  '<CMD>wincmd k<CR>',  'Go to split on the top')
    map({ mode.NORMAL, mode.TERM }, '<A-j>',  '<CMD>wincmd j<CR>',  'Go to split on the bottom')
    map({ mode.NORMAL, mode.TERM }, '<A-h>',  '<CMD>wincmd h<CR>',  'Go to split on the left')
    map({ mode.NORMAL, mode.TERM }, '<A-l>',  '<CMD>wincmd l<CR>',  'Go to split on the right')
    -- Resize
    map({ mode.NORMAL, mode.TERM }, '<A-UP>',     '<CMD>resize +1<CR>',           'Increase the size of the split vertically')
    map({ mode.NORMAL, mode.TERM }, '<A-DOWN>',   '<CMD>resize -1<CR>',           'Decrease the size of the split vertically')
    map({ mode.NORMAL, mode.TERM }, '<A-RIGHT>',  '<CMD>vertical resize +1<CR>',  'Increase the size of the split horizontally')
    map({ mode.NORMAL, mode.TERM }, '<A-LEFT>',   '<CMD>vertical resize -1<CR>',  'Decrease the size of the split horizontally')

    -- Faster exit to normal mode
    map({ mode.INSERT, mode.VISUAL, mode.TERM },  '<A-SPACE>',  '<ESC>',  'Exit to normal mode')
    -- Indent without exiting visual
    map(mode.VISUAL,  '<',  '<gv',  'Unindent without quitting visual mode')
    map(mode.VISUAL,  '>',  '>gv',  'Indent without quitting visual mode')
    -- Keep clipboard when pasting in visual mode
    map(mode.VISUAL,  'p',  '"_dP',  'Paste in visual mode and keep clipboard')
    -- Faster beginning/end of line navigation
    map({ mode.NORMAL, mode.VISUAL },  'H',  '^',  'Go to the beginning of the line')
    map({ mode.NORMAL, mode.VISUAL },  'L',  '$',  'Go to the end of the line')
    -- Paste in insert mode
    map(mode.INSERT,  '<C-v>',  '<ESC>pi',  'Paste directly in insert mode')

    -- Clear search
    map(mode.NORMAL,  '<A-/>',  '<CMD>let @/ = ""<CR>',  'Clear search')
end


-- TODO Add lazy keymaps


--- Open telescope pickers (menus).
function M.telescope_pickers()
    add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 't' }, 'telescope')

    local builtin = require('telescope.builtin')

    -- All
    map(mode.NORMAL,  '<LEADER>tt',  builtin.builtin,  'Open built-in picker picker')

    -- Other
    map(mode.NORMAL,  '<LEADER>tf',  builtin.find_files,  'Open files picker')
    map(mode.NORMAL,  '<LEADER>tg',  builtin.live_grep,   'Open grep picker')
    map(mode.NORMAL,  '<LEADER>tl',  builtin.filetypes,   'Open file type picker')
    map(mode.NORMAL,  '<LEADER>th',  builtin.highlights,  'Open highlights picker')
end

--- Telescope in-picker navigation.
function M.telescope_navigation()
    local actions = require('telescope.actions')
    local mappings_default = require('telescope.mappings').default_mappings

    local mappings_empty = {
        i = {},
        n = {}
    }
    for k, _ in pairs(mappings_default.i) do
        mappings_empty.i[k] = false
    end
    for k, _ in pairs(mappings_default.n) do
        mappings_empty.n[k] = false
    end

    return vim.tbl_deep_extend('force', mappings_empty, {
        i = {
            ['<C-c>'] = actions.close,

            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,

            ['<CR>']  = actions.select_default,
            ['<C-l>'] = actions.select_default,
            ['<C-h>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,

            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-i>'] = actions.preview_scrolling_down,

            ['<Tab>'] = actions.toggle_selection,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
            ['<C-j>'] = actions.nop,
        },
        n = {
            ['q']     = actions.close,
            ['<esc>'] = actions.close,
            ['<C-c>'] = actions.close,

            ['j'] = actions.move_selection_next,
            ['k'] = actions.move_selection_previous,

            ['<CR>']  = actions.select_default,
            ['l']     = actions.select_default,
            ['h']     = actions.select_horizontal,
            ['v']     = actions.select_vertical,

            ['gg'] = actions.move_to_top,
            ['G']  = actions.move_to_bottom,

            ['u'] = actions.preview_scrolling_up,
            ['i'] = actions.preview_scrolling_down,

            ['<Tab>'] = actions.toggle_selection,
            ['?']     = actions.which_key,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
        }
    })
end


--- Control cmp menus.
function M.cmp()
    local mapping = require('cmp').mapping

    local function map_cmp(callback)
        return mapping(callback, { mode.INSERT, mode.COMMAND })
    end

    return {
        -- Documentation
        ['<C-u>']     = map_cmp(mapping.scroll_docs(1)),
        ['<C-i>']     = map_cmp(mapping.scroll_docs(-1)),
        -- Items
        ['<C-j>']     = map_cmp(mapping.select_next_item()),
        ['<C-k>']     = map_cmp(mapping.select_prev_item()),
        -- Confirm & abort
        ['<C-SPACE>'] = map_cmp(mapping.complete()),
        ['<C-e>']     = map_cmp(mapping.abort()),
        ['<C-l>']     = map_cmp(mapping.confirm { select = true }),}
end


--#endregion



--#region Export

return M

--#endregion
