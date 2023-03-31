--#region Helpers

-- Imports
local log = require('neconfig.utils.log')

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

--- Default options for keybinds.
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

---@type fun(mode: string, keys: string, description: string)
local which_key_prefixes_registered_function = nil

--- Prefixes passed to WhichKey for more documentation.
--- @type {Mode: {string: string}}
local which_key_prefixes = {}

--- Add a description to WhichKey prefix.
---@param modes Mode | Mode[] Modes in which prefix will exist.
---@param keys string Key combination.
---@param description string Description.
local function add_to_which_key_prefixes(modes, keys, description)
    if type(modes) == 'string' then
        modes = { modes };
    end

    for _, mode in ipairs(modes) do
        which_key_prefixes[mode] = which_key_prefixes[mode] or {}
        if which_key_prefixes[mode][keys] ~= description then
            which_key_prefixes[mode][keys] = description

            if which_key_prefixes_registered_function then
                which_key_prefixes_registered_function(mode, keys, description)
            end
        end
    end
end

--#endregion



--#region Keymaps

--- WhichKey prefixes for better documentation.
---@param listener fun(mode: string, keys: string, description: string)
function M.which_key_prefixes_register(listener)
    which_key_prefixes_registered_function = listener
    for mode, prefixes in pairs(which_key_prefixes) do
        for keys, description in pairs(prefixes) do
            listener(mode, keys, description)
        end
    end
end

--- General keymaps.
function M.general()
    -- Leader key
    add_to_which_key_prefixes(mode.ALL, '<LEADER>', 'custom')
    map(mode.ALL,  '<SPACE>',  '<NOP>')
    vim.g.mapleader = ' '

    -- Close
    map(mode.ALL,  '<A-S-c>',  '<CMD>quitall!<CR>',  'Force quit everything')

    -- Buffer
    add_to_which_key_prefixes(mode.NOT_TYPING, '<LEADER>b', 'buffer/window')
    -- Split
    map(mode.NOT_TYPING,  '<LEADER>bs',  '<CMD>split<CR>',   'Spilt window horizontally')
    map(mode.NOT_TYPING,  '<LEADER>bv',  '<CMD>vsplit<CR>',  'Spilt window vertically')
    -- Manipulation
    map(mode.NOT_TYPING,  '<LEADER>bn',  '<CMD>enew<CR>',     'Create a new empty buffer')
    map(mode.NOT_TYPING,  '<LEADER>br',  '<CMD>edit<CR>',     'Refresh current buffer')
    map(mode.NOT_TYPING,  '<LEADER>bd',  '<CMD>bdelete<CR>',  'Delete current buffer')
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
    map({ mode.NORMAL, mode.TERM },  '<C-k>',  '<CMD>wincmd k<CR>',  'Go to split on the top')
    map({ mode.NORMAL, mode.TERM },  '<C-j>',  '<CMD>wincmd j<CR>',  'Go to split on the bottom')
    map({ mode.NORMAL, mode.TERM },  '<C-h>',  '<CMD>wincmd h<CR>',  'Go to split on the left')
    map({ mode.NORMAL, mode.TERM },  '<C-l>',  '<CMD>wincmd l<CR>',  'Go to split on the right')
    -- Resize
    map({ mode.NORMAL, mode.TERM },  '<C-UP>',     '<CMD>resize +1<CR>',           'Increase the size of the split vertically')
    map({ mode.NORMAL, mode.TERM },  '<C-DOWN>',   '<CMD>resize -1<CR>',           'Decrease the size of the split vertically')
    map({ mode.NORMAL, mode.TERM },  '<C-RIGHT>',  '<CMD>vertical resize +1<CR>',  'Increase the size of the split horizontally')
    map({ mode.NORMAL, mode.TERM },  '<C-LEFT>',   '<CMD>vertical resize -1<CR>',  'Decrease the size of the split horizontally')

    -- Faster exit to normal mode
    map({ mode.INSERT, mode.VISUAL, mode.TERM },  '<A-SPACE>',  '<ESC>',  'Exit to normal mode')
    -- Indent without exiting visual
    map(mode.VISUAL,  '<',  '<gv',  'Unindent without quitting visual mode')
    map(mode.VISUAL,  '>',  '>gv',  'Indent without quitting visual mode')
    -- Keep clipboard when pasting in visual mode
    map(mode.VISUAL,  'p',  '"_dP',  'Paste in visual mode and keep clipboard')
    -- Faster navigation
    map({ mode.NORMAL, mode.VISUAL },  'H',  '^',  'Go to the beginning of the line')
    map({ mode.NORMAL, mode.VISUAL },  'L',  '$',  'Go to the end of the line')
    map(mode.INSERT,  '<C-k>',  '<UP>',     'Move up')
    map(mode.INSERT,  '<C-j>',  '<DOWN>',   'Move down')
    map(mode.INSERT,  '<C-h>',  '<LEFT>',   'Move left')
    map(mode.INSERT,  '<C-l>',  '<RIGHT>',  'Move right')
    -- Paste in insert mode
    map(mode.INSERT,  '<C-v>',  '<ESC>pa',  'Paste directly in insert mode')

    -- Clear search
    map(mode.NORMAL,  '<A-/>',  '<CMD>let @/ = ""<CR>',  'Clear search')
end

-- TODO Add lazy keymaps


--- Open telescope pickers (menus).
function M.telescope_pickers()
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>t', 'telescope')

    local builtin = require('telescope.builtin')

    -- All
    map(mode.NORMAL,  '<LEADER>tt',  builtin.builtin,  'Open built-in picker picker')

    -- Other
    map(mode.NORMAL,  '<LEADER>tf',  builtin.find_files,   'Open files picker')
    map(mode.NORMAL,  '<LEADER>tg',  builtin.live_grep,    'Open grep picker')
    map(mode.NORMAL,  '<LEADER>tl',  builtin.filetypes,    'Open file type picker')
    map(mode.NORMAL,  '<LEADER>th',  builtin.highlights,   'Open highlights picker')
    map(mode.NORMAL,  '<LEADER>tc',  builtin.colorscheme,  'Open colorscheme picker')
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
            ['<C-s>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-i>'] = actions.preview_scrolling_down,
            ['<Tab>'] = actions.toggle_selection,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
        },
        n = {
            ['q']     = actions.close,
            ['<esc>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['j']     = actions.move_selection_next,
            ['k']     = actions.move_selection_previous,
            ['<CR>']  = actions.select_default,
            ['l']     = actions.select_default,
            ['h']     = actions.select_horizontal,
            ['v']     = actions.select_vertical,
            ['gg']    = actions.move_to_top,
            ['G']     = actions.move_to_bottom,
            ['u']     = actions.preview_scrolling_up,
            ['i']     = actions.preview_scrolling_down,
            ['<Tab>'] = actions.toggle_selection,
            ['?']     = actions.which_key,
            ['<C-/>'] = actions.which_key,
            ['<C-_>'] = actions.which_key,
        }
    })
end

--- Control cmp menus.
function M.cmp()
    local cmp = require('cmp')
    local mapping = cmp.mapping
    local luasnip = require('luasnip')

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
        -- Confirm & abort with jumps
        ['<C-SPACE>'] = map_cmp(mapping.complete()),
        ['<C-e>']     = map_cmp(mapping.abort()),
        ['<C-l>']     = map_cmp(function(fallback)
            if cmp.visible() then
                cmp.confirm { select = true }
            elseif luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end),
        ['<C-h>']     = map_cmp(function(fallback)
            if cmp.visible() then
                cmp.abort()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end),
    }
end

--- LSP related.
function M.lsp()
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>l', 'lsp')
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>ld', 'documentation')
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>le', 'errors')
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>lg', 'go to')
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>lr', 'refactor')
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>lw', 'workspace')

    local builtin = require('telescope.builtin')

    local buffer_option = { buffer = true }

    -- Documentation
    map(mode.NORMAL,  '<LEADER>ldo',  vim.lsp.buf.hover,           'Show documentation',  buffer_option)
    map(mode.NORMAL,  '<LEADER>lds',  vim.lsp.buf.signature_help,  'Show signature',      buffer_option)
    -- Errors
    map(mode.NORMAL,  '<LEADER>lel',  builtin.diagnostics,        'Show error list',       buffer_option)
    map(mode.NORMAL,  '<LEADER>leo',  vim.diagnostic.open_float,  'Show current error',    buffer_option)
    map(mode.NORMAL,  '[e',           vim.diagnostic.goto_prev,   'Go to previous error',  buffer_option)
    map(mode.NORMAL,  ']e',           vim.diagnostic.goto_next,   'Go to next error',      buffer_option)
    map(mode.NORMAL,  '<LEADER>lea',  vim.lsp.buf.code_action,    'Show automatic fixes',  buffer_option)
    -- Go to
    map(mode.NORMAL,  '<LEADER>lgd',  builtin.lsp_definitions,      'Go to definition',      buffer_option)
    map(mode.NORMAL,  '<LEADER>lgr',  builtin.lsp_references,       'Go to references',      buffer_option)
    map(mode.NORMAL,  '<LEADER>lgi',  builtin.lsp_implementations,  'Go to implementation',  buffer_option)
    -- Refactor
    map(mode.NORMAL,  '<LEADER>lrr',  vim.lsp.buf.rename,  'Rename',  buffer_option)
    map(
        mode.NORMAL,
        '<LEADER>lrf',
        function() vim.lsp.buf.format { async = true } end,
        'Rename',
        buffer_option
    )
    -- Workspace
    map(mode.NORMAL,  '<LEADER>lwa',  vim.lsp.buf.add_workspace_folder,     'Add workspace folder',     buffer_option)
    map(mode.NORMAL,  '<LEADER>lwr',  vim.lsp.buf.remove_workspace_folder,  'Remove workspace folder',  buffer_option)
    map(
        mode.NORMAL,
        '<LEADER>lwl',
        function()
            log.info(
                '# Workspace folders\n\n' ..
                table.concat(
                    vim.tbl_map(
                        function(f) return '- `' .. f .. '`' end,
                        vim.lsp.buf.list_workspace_folders()
                    ),
                    '\n'
                )
            )
        end,
        'Show workspace folders list',
        buffer_option
    )
end

--- File browser.
function M.nvim_tree_menu()
    map(mode.NOT_TYPING,  '<LEADER>f', '<CMD>NvimTreeToggle<CR>',  'Show file browser')
end

--- File browser navigation.
function M.nvim_tree_navigation(buffer_number)
    local api = require('nvim-tree.api')
    local buffer_option = { buffer = buffer_number, noremap = true, silent = true, nowait = true }

    -- Open
    map(mode.NORMAL,  'l',              api.node.open.edit,        'Open',                      buffer_option)
    map(mode.NORMAL,  '<CR>',           api.node.open.edit,        'Open',                      buffer_option)
    map(mode.NORMAL,  '<2-LeftMouse>',  api.node.open.edit,        'Open',                      buffer_option)
    map(mode.NORMAL,  's',              api.node.open.horizontal,  'Open in horizontal split',  buffer_option)
    map(mode.NORMAL,  'v',              api.node.open.vertical,    'Open in vertical split',    buffer_option)
    map(mode.NORMAL,  'o',              api.node.run.system,       'System open',               buffer_option)
    map(mode.NORMAL,  'L',              api.node.open.preview,     'Preview',                   buffer_option)
    -- Fast navigation
    map(mode.NORMAL,  'h',  api.node.navigate.parent,        'Go to parent',      buffer_option)
    map(mode.NORMAL,  'H',  api.node.navigate.parent_close,  'Close node',        buffer_option)
    map(mode.NORMAL,  'J',  api.node.navigate.sibling.next,  'Next sibling',      buffer_option)
    map(mode.NORMAL,  'K',  api.node.navigate.sibling.prev,  'Previous sibling',  buffer_option)
    -- Collapse
    map(mode.NORMAL,  '>',  api.tree.expand_all,    'Expand all',    buffer_option)
    map(mode.NORMAL,  '<',  api.tree.collapse_all,  'Collapse all',  buffer_option)
    -- Path copy
    map(mode.NORMAL,  'y',   api.fs.copy.filename,      'Copy file name',      buffer_option)
    map(mode.NORMAL,  'gy',  api.fs.copy.relative_path, 'Copy relative path',  buffer_option)
    map(mode.NORMAL,  'gY',  api.fs.copy.absolute_path, 'Copy absolute path',  buffer_option)
    -- File manipulation
    map(mode.NORMAL,  'a',  api.fs.create,        'New file',               buffer_option)
    map(mode.NORMAL,  'd',  api.fs.remove,        'Delete',                 buffer_option)
    map(mode.NORMAL,  'r',  api.fs.rename,        'Rename',                 buffer_option)
    map(mode.NORMAL,  'R',  api.fs.rename_sub,    'Full rename',            buffer_option)
    map(mode.NORMAL,  'c',  api.fs.copy.node,     'Copy file',              buffer_option)
    map(mode.NORMAL,  'x',  api.fs.cut,           'Cut file',               buffer_option)
    map(mode.NORMAL,  'p',  api.fs.paste,         'Paste file',             buffer_option)
    map(mode.NORMAL,  'm',  api.marks.toggle,     'Mark file',              buffer_option)
    map(mode.NORMAL,  'M',  api.marks.bulk.move,  'Bulk move marked files', buffer_option)
    -- Other
    map(mode.NORMAL,  'i',      api.node.show_info_popup,  'Info',         buffer_option)
    map(mode.NORMAL,  '?',      api.tree.toggle_help,      'Help',         buffer_option)
    map(mode.NORMAL,  ';',      api.node.run.cmd,          'Command',      buffer_option)
    map(mode.NORMAL,  'q',      api.tree.close,            'Quit',         buffer_option)
    map(mode.NORMAL,  '<ESC>',  api.tree.close,            'Quit',         buffer_option)
end

--- Treesitter.
function M.treesitter()
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>s', 'treesitter')

    map(mode.NORMAL, '<LEADER>sn', '<CMD>TSNodeUnderCursor<CR>',              'Show TS node')
    map(mode.NORMAL, '<LEADER>sh', '<CMD>TSHighlightCapturesUnderCursor<CR>', 'Show TS highlight')
    map(mode.NORMAL, '<LEADER>sp', '<CMD>TSPlaygroundToggle<CR>',             'Toggle TS playground')
    map(mode.NORMAL, '<LEADER>si', '<CMD>Inspect<CR>',                        'Inspect current highlight group')
end

--- Syntax aware selection.
function M.treesitter_textobjects_select()
    return {
        -- Function
        ['if'] = { query = '@function.inner', desc = 'Function body' },
        ['af'] = { query = '@function.outer', desc = 'Function' },
        -- Block
        ['ib'] = { query = '@block.inner', desc = 'Block body' },
        ['ab'] = { query = '@block.outer', desc = 'Block' },
        -- Class
        ['ic'] = { query = '@class.inner', desc = 'Class body' },
        ['ac'] = { query = '@class.outer', desc = 'Class' },
        -- Parameter
        ['ip'] = { query = '@parameter.inner', desc = 'Parameter body' },
        ['ap'] = { query = '@parameter.outer', desc = 'Parameter' },

        -- Comment
        ['id'] = { query = '@comment.outer',  desc = 'Comment' },
    }
end

function M.treesitter_textobjects_move()
    return {
        goto_next_start = {
            [']f'] = { query = '@function.outer',  desc = 'Function' },
            [']b'] = { query = '@block.outer',     desc = 'Block' },
            [']c'] = { query = '@class.outer',     desc = 'Class' },
            [']p'] = { query = '@parameter.outer', desc = 'Parameter' },
            [']d'] = { query = '@comment.outer',   desc = 'Comment' },
        },
        goto_next_end = {
            [']F'] = { query = '@function.outer',  desc = 'Function' },
            [']B'] = { query = '@block.outer',     desc = 'Block' },
            [']C'] = { query = '@class.outer',     desc = 'Class' },
            [']P'] = { query = '@parameter.outer', desc = 'Parameter' },
            [']D'] = { query = '@comment.outer',   desc = 'Comment' },
        },
        goto_previous_start = {
            ['[f'] = { query = '@function.outer',  desc = 'Function' },
            ['[b'] = { query = '@block.outer',     desc = 'Block' },
            ['[c'] = { query = '@class.outer',     desc = 'Class' },
            ['[p'] = { query = '@parameter.outer', desc = 'Parameter' },
            ['[d'] = { query = '@comment.outer',   desc = 'Comment' },
        },
        goto_previous_end = {
            ['[F'] = { query = '@function.outer',  desc = 'Function' },
            ['[B'] = { query = '@block.outer',     desc = 'Block' },
            ['[C'] = { query = '@class.outer',     desc = 'Class' },
            ['[P'] = { query = '@parameter.outer', desc = 'Parameter' },
            ['[D'] = { query = '@comment.outer',   desc = 'Comment' },
        }
    }
end

--- Easy commenting.
function M.comment()
    add_to_which_key_prefixes(mode.NOT_TYPING, '<LEADER>c', 'comment')

    return {
        toggler = {
            line  = '<LEADER>c/',
            block = '<LEADER>c?'
        },
        opleader = {
            line  = '<LEADER>cc',
            block = '<LEADER>cb'
        },
        extra = {
            above = '<LEADER>cO',
            below = '<LEADER>co',
            eol   = '<LEADER>cA'
        }
    }
end

--- Git integration.
function M.gitsigns()
    add_to_which_key_prefixes(mode.NORMAL, '<LEADER>g', 'git')

    local gitsigns = require('gitsigns')

    map(mode.NORMAL, '<LEADER>gd', gitsigns.preview_hunk, 'Preview the differences in the current hunk')
    map(mode.NORMAL, '<LEADER>gb', gitsigns.blame_line,   'Blame current line')
    map(mode.NORMAL, '<LEADER>gr', gitsigns.reset_hunk,   'Reset current hunk')
    map(mode.NORMAL, '[g',         gitsigns.prev_hunk,    'Previous hunk')
    map(mode.NORMAL, ']g',         gitsigns.next_hunk,    'Next hunk')
end

--- Toggle term open.
function M.toggleterm_open()
    return '<A-\\>'
end

--- More toggle term keymaps.
function M.toggleterm()
    map({ mode.NORMAL, mode.TERM }, '<A-CR>', '<CMD>ToggleTermToggleAll<CR>', 'Show/hide all popup terminals')
    map(mode.TERM, '<ESC>', '<C-\\><C-n>')
end

--#endregion



--#region Export

return M

--#endregion
