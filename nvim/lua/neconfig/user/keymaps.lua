--#region Helpers

-- Container for plugin keymaps functions
local M = {}

-- List of modes
local mode = {
    ALL          = '',
    NORMAL       = 'n',
    INSERT       = 'i',
    VISUAL       = 'v',
    VISUAL_BLOCK = 'x',
    TERM         = 't',
    COMMAND      = 'c',
    OPERATOR     = 'o'
}

-- Default options for keybinds
local default_options = {
    noremap = true,
    silent = true
}

-- Append default options to the options
local function treat_options(options, description)
    if not options then
        options = {}
    end
    for k, v in pairs(default_options) do
        if options[k] == nil then
            options[k] = v
        end
    end
    options['desc'] = description
    return options
end

-- Set the keymap
local function map(modes, keys, func, description, options)
    options = treat_options(options, description)
    vim.keymap.set(modes, keys, func, options)
end

local whichkey_prefixes = {}
local function add_to_whichkey_prefixes(modes, path, name)
    if whichkey_prefixes[modes] == nil then
        whichkey_prefixes[modes] = {}
    end

    local target = whichkey_prefixes[modes]
    for _, p in ipairs(path) do
        if target[p] == nil then
            target[p] = {}
        end
        target = target[p]
    end

    target.name = name
end

--#endregion


--#region Leader key
map(mode.ALL, '<SPACE>', '<NOP>')
vim.g.mapleader = ' '
add_to_whichkey_prefixes(mode.ALL, { '<LEADER>' }, 'custom')
--#endregion


--#region Splits

-- Split
map(mode.NORMAL, '<A-UP>',    '<CMD>split<CR>',  'Split vertically')
map(mode.NORMAL, '<A-DOWN>',  '<CMD>split<CR>',  'Split vertically')
map(mode.NORMAL, '<A-LEFT>',  '<CMD>vsplit<CR>', 'Split horizontally')
map(mode.NORMAL, '<A-RIGHT>', '<CMD>vsplit<CR>', 'Split horizontally')
-- Close
map(
    mode.NORMAL,
    '<A-c>',
    function()
        local closed = pcall(vim.cmd, 'q')
        if not closed then
            vim.notify('Cannot close this buffer', vim.log.levels.INFO)
        end
    end,
    'Close the current buffer'
)
map( { mode.NORMAL, mode.TERM }, '<A-S-c>', '<CMD>quitall!<CR>', 'Force close everything')
-- Go to
map({ mode.NORMAL, mode.TERM }, '<C-k>', '<CMD>wincmd k<CR>', 'Go to split on the top')
map({ mode.NORMAL, mode.TERM }, '<C-j>', '<CMD>wincmd j<CR>', 'Go to split on the bottom')
map({ mode.NORMAL, mode.TERM }, '<C-h>', '<CMD>wincmd h<CR>', 'Go to split on the left')
map({ mode.NORMAL, mode.TERM }, '<C-l>', '<CMD>wincmd l<CR>', 'Go to split on the right')
-- Resize
map({ mode.NORMAL, mode.TERM }, '<C-UP>',    '<CMD>resize +1<CR>',          'Increase the size of the split vertically')
map({ mode.NORMAL, mode.TERM }, '<C-DOWN>',  '<CMD>resize -1<CR>',          'Decrease the size of the split vertically')
map({ mode.NORMAL, mode.TERM }, '<C-LEFT>',  '<CMD>vertical resize -1<CR>', 'Increase the size of the split horizontally')
map({ mode.NORMAL, mode.TERM }, '<C-RIGHT>', '<CMD>vertical resize +1<CR>', 'Decrease the size of the split horizontally')

--#endregion


--#region Editing

-- Faster exit out of insert mode
map({ mode.INSERT, mode.VISUAL, mode.TERM }, '<A-SPACE>', '<ESC>', 'Exit out of insert mode')

-- Do not exit out of visual mode when indenting
map(mode.VISUAL, '<', '<gv', 'Unindent without quitting visual mode')
map(mode.VISUAL, '>', '>gv', 'Indent without quitting visual mode')

-- Keep clipboard when pasting in visual mode
map(mode.VISUAL, 'p', '"_dP', 'Paste in visual mode and keep clipboard')

-- Better SHIFT + direction navigation
map({ mode.NORMAL, mode.VISUAL }, 'H', '^', 'Go to the beginning of the line')
map({ mode.NORMAL, mode.VISUAL }, 'L', '$', 'Go to the end of the line')

-- Paste in insert mode
map(mode.INSERT, '<C-v>', '<ESC>pi', 'Paste directly in insert mode')

-- Clear search
map(mode.NORMAL, '<A-/>', '<CMD>let @/ = ""<CR>', 'Clear previous search highlighting')

--#endregion


--#region Which key

function M.whichkey_groups()
    return whichkey_prefixes
end

--#endregion


--#region Completion

function M.completion(cmp)
    local function mapping(callback)
        return cmp.mapping(callback, { 'i', 'c' })
    end
    return {
        -- Documentation
        ['<C-u>']     = mapping(cmp.mapping.scroll_docs(1)),
        ['<C-i>']     = mapping(cmp.mapping.scroll_docs(-1)),
        -- Items
        ['<C-j>']     = mapping(cmp.mapping.select_next_item()),
        ['<C-k>']     = mapping(cmp.mapping.select_prev_item()),
        -- Confirm & abort
        ['<C-SPACE>'] = mapping(cmp.mapping.complete()),
        ['<C-e>']     = mapping(cmp.mapping.abort()),
        ['<C-l>']     = mapping(cmp.mapping.confirm { select = true }),
    }
end

--#endregion


--#region LSP

add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'l' },      'LSP')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'l', 'g'},      'go to')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'l', 'd'},      'documentation')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'l', 'w'},      'workspace')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'l', 'r'},      'refactor')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'l', 'e' },     'errors')
function M.lsp()
    local buffer_option = { buffer = true }
    -- Diagnostics
    -- <LEADER>lel for diagnostic list
    map(mode.NORMAL, '<LEADER>leo', vim.diagnostic.open_float, 'Open diagnostics menu')
    map(mode.NORMAL, '<LEADER>lek', vim.diagnostic.goto_prev,  'Go to previous diagnostic')
    map(mode.NORMAL, '<LEADER>lej', vim.diagnostic.goto_next,  'Go to next diagnostic')
    -- Code action
    map(mode.NORMAL, '<LEADER>lea', vim.lsp.buf.code_action, 'Show automatic fixes', buffer_option)
    -- Go do
    -- <LEADER>lgd for go to definition
    -- <LEADER>lgi for go to implementation
    -- <LEADER>lgr for go to references
    -- Documentation
    map(mode.NORMAL, '<LEADER>ldh', vim.lsp.buf.hover,          'Show documentation',    buffer_option)
    map(mode.NORMAL, '<LEADER>lds', vim.lsp.buf.signature_help, 'Show singature',        buffer_option)
    -- Workspace folders
    map(mode.NORMAL, '<LEADER>lwa', vim.lsp.buf.add_workspace_folder,    'Add the folder to workspaces',      buffer_option)
    map(mode.NORMAL, '<LEADER>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove the folder from workspaces', buffer_option)
    map(
        mode.NORMAL,
        '<LEADER>lwl',
        function()
            print(vim.inspect(
                vim.lsp.buf.list_workspace_folders()
            ))
        end,
        'List workspace folders',
        buffer_option
    )
    -- Refactor
    map(mode.NORMAL, '<LEADER>lrr', vim.lsp.buf.rename, 'Rename symbol', buffer_option)
    map(
        mode.NORMAL,
        '<LEADER>lrf',
        function()
            vim.lsp.buf.format { async = true }
        end,
        'Format document',
        buffer_option
    )
end

--#endregion


--#region Telescope

add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 't' }, 'telescope')
function M.telescope_menus(telescope, builtin)
    -- All
    map(mode.NORMAL, '<LEADER>tt',  '<CMD>Telescope<cr>', 'Open all pickers')
    -- Diagnostics
    map(mode.NORMAL, '<LEADER>lel', builtin.diagnostics,         'Open diagnostics list')
    map(mode.NORMAL, '<LEADER>lgd', builtin.lsp_definitions,     'Go to definition')
    map(mode.NORMAL, '<LEADER>lgi', builtin.lsp_implementations, 'Go to implementation')
    map(mode.NORMAL, '<LEADER>lgr', builtin.lsp_references,      'Go to references')
    -- Other
    map(mode.NORMAL, '<LEADER>tf',  builtin.find_files,                     'Open file picker')
    map(mode.NORMAL, '<LEADER>tg',  builtin.live_grep,                      'Open grep picker')
    map(mode.NORMAL, '<LEADER>tb',  builtin.buffers,                        'Open buffers picker')
    map(mode.NORMAL, '<LEADER>td',  builtin.diagnostics,                    'Open diagnostics picker')
    map(mode.NORMAL, '<LEADER>tl',  builtin.filetypes,                      'Open file type picker')
    -- Extensions
    map(mode.NORMAL, '<LEADER>tp',  telescope.extensions.projects.projects, 'Open project picker')
    -- map(mode.NORMAL, '<LEADER>ts',  telescope.extensions.aerial.aerial,     'Open symbol tree picker')
    map(mode.NORMAL, '<LEADER>tn',  telescope.extensions.notify.notify,     'Open notifications picker')
end

function M.telescope_navigation(actions)
    return {
        i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-l>'] = actions.select_default,
            ['<C-c>'] = actions.close
        },
        n = {
            ['gg']    = actions.move_to_top,
            ['G']     = actions.move_to_bottom,
            ['k']     = actions.move_selection_previous,
            ['j']     = actions.move_selection_next,
            ['l']     = actions.select_default,
            ['q']     = actions.close,
            ['<ESC>'] = actions.close
        }
    }
end

--#endregion


--#region Telescope

add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'c' }, 'comment')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'c', 'c' }, 'inline')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'c', 'b' }, 'block')
function M.comment_toggler()
    return {
        line  = '<LEADER>ccc',
        block = '<LEADER>cbc'
    }
end

add_to_whichkey_prefixes(mode.VISUAL, { '<LEADER>', 'c' }, 'comment')
function M.comment_opleader()
    return {
        line  = '<LEADER>cc',
        block = '<LEADER>cb'
    }
end

--#endregion


--#region Gitsigns

add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'g' }, 'git')
function M.gitsigns(gitsigns)
    map(mode.NORMAL, '<LEADER>gd', gitsigns.preview_hunk, 'Preview the differences in the current hunk')
    map(mode.NORMAL, '<LEADER>gb', gitsigns.blame_line,   'Blame current line')
    map(mode.NORMAL, '<LEADER>gr', gitsigns.reset_hunk,   'Reset current hunk')
    map(mode.NORMAL, '<LEADER>gk', gitsigns.prev_hunk,    'Go to previous hunk')
    map(mode.NORMAL, '<LEADER>gj', gitsigns.next_hunk,    'Go to next hunk')
end

--#endregion


--#region NvimTree

add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'f' }, 'files')
function M.nvim_tree_menus(nvim_tree)
    map(mode.NORMAL, '<LEADER>ff', nvim_tree.tree.toggle, 'Open file explorer')
end

function M.nvim_tree_navigation()
    return {
        -- Faster navigation
        {
            key    = { 'l', '<CR>', '<2-LeftMouse>' },
            action = 'edit'
        },
        {
            key    = 'h',
            action = 'parent_node'
        },
        {
            key    = 'H',
            action = 'close_node'
        },
        -- Parent directory
        {
            key    = { '>', '<2-RightMouse>' },
            action = 'cd'
        },
        {
            key    = '<',
            action = 'dir_up'
        },
        -- Collapse
        {
            key    = '[',
            action = 'collapse_all'
        },
        {
            key    = ']',
            action = 'expand_all'
        },
        -- Path copy
        {
            key    = 'y',
            action = 'copy_name'
        },
        {
            key    = 'gy',
            action = 'copy_path'
        },
        {
            key    = 'gY',
            action = 'copy_absolute_path'
        },
        -- File manipulation
        {
            key    = 'a',
            action = 'create'
        },
        {
            key    = 'd',
            action = 'remove'
        },
        {
            key    = 'D',
            action = 'trash'
        },
        {
            key    = 'r',
            action = 'rename'
        },
        {
            key    = 'R',
            action = 'full_rename'
        },
        {
            key    = 'c',
            action = 'copy'
        },
        {
            key    = 'x',
            action = 'cut'
        },
        {
            key    = 'p',
            action = 'paste'
        },
        {
            key    = 'm',
            action = 'toggle_mark'
        },
        {
            key    = 'b',
            action = 'bulk_move'
        },
        -- Filtering
        {
            key    = 'f',
            action = 'live_filter'
        },
        {
            key    = 'F',
            action = 'clear_live_filter'
        },
        -- Other
        {
            key    = 'i',
            action = 'toggle_file_info'
        },
        {
            key    = 'o',
            action = 'system_open'
        },
        {
            key    = '?',
            action = 'toggle_help'
        },
        {
            key    = { 'q', '<ESC>' },
            action = 'close'
        },
    }
end

--#endregion


--#region Bufferline

add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'b' }, 'buffer')
add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 'b', 'p' }, 'picker')
function M.bufferline(bufdelete)
    map(mode.NORMAL, '<A-h>',       '<CMD>BufferLineCyclePrev<CR>',               'Go to previous buffer')
    map(mode.NORMAL, '<A-l>',       '<CMD>BufferLineCycleNext<CR>',               'Go to next buffer')
    map(mode.NORMAL, '<A-j>',       '<CMD>BufferLineMovePrev<CR>',                'Move buffer to the left')
    map(mode.NORMAL, '<A-k>',       '<CMD>BufferLineMoveNext<CR>',                'Move buffer to the right')
    map(mode.NORMAL, '<LEADER>bpp', '<CMD>BufferLinePick<CR>',                    'Select a buffer')
    map(mode.NORMAL, '<LEADER>bpc', '<CMD>BufferLinePickClose<CR>',               'Close a buffer')
    map(mode.NORMAL, '<LEADER>bpc', '<CMD>BufferLinePickClose<CR>',               'Close a buffer')
    map(mode.NORMAL, '<LEADER>bn',  '<CMD>enew<CR>',                              'Create a new empty buffer')
    map(mode.NORMAL, '<LEADER>br',  '<CMD>edit<CR>',                              'Refresh current buffer')
end

--#endregion


--#region Toggleterm

function M.toggleterm_open()
    return '<A-\\>'
end

function M.toggleterm()
    -- Show / hide all terminals
    map({ mode.NORMAL, mode.TERM }, '<A-CR>', '<CMD>ToggleTermToggleAll<CR>', 'Show / hide all popup terminals')
end

function M.toggleterm_hook()
    local opts = { buffer = 0 }
    -- Show / hide all terminals
    map(mode.TERM, '<A-SPACE>', '<C-\\><C-n>', 'Go into insert mode in terminal', opts)
end

--#endregion


--#region Toggleterm

function M.aerial_menus()
    map(mode.NORMAL, '<LEADER>ldt', '<CMD>AerialToggle<CR>', 'Show symbol tree')
end

function M.aerial_navigation(aerial)
    return {
        -- Faster navigation
        ['l'] = aerial.tree_open,
        ['L'] = aerial.jump,
        ['h'] = {
            callback = function()
                aerial.tree_close.callback()
                aerial.tree_open.callback()
            end,
            desc = 'Go to previous level in the tree'
        },
        ['H']             = aerial.tree_close,
        ['<2-LeftMouse>'] = 'actions.jump',
        ['<CR>']          = 'actions.jump',
        -- Other
        ['q']             = 'actions.close',
        ['<EC>']          = 'actions.close',
        ['?']             = 'actions.show_help',
    }
end

--#endregion


--#region Treesitter

add_to_whichkey_prefixes(mode.NORMAL, { '<LEADER>', 's' }, 'treesitter')
function M.treesitter()
    map(mode.NORMAL, '<LEADER>sn', '<CMD>TSNodeUnderCursor<CR>',              'Show TS node')
    map(mode.NORMAL, '<LEADER>sh', '<CMD>TSHighlightCapturesUnderCursor<CR>', 'Show TS highlight')
    map(mode.NORMAL, '<LEADER>sp', '<CMD>TSPlaygroundToggle<CR>',             'Toggle TS playground')
end
map(mode.NORMAL, '<LEADER>si', '<CMD>Inspect<CR>',                        'Inspect current highlight group')

function M.treesitter_textobjects()
    return {
        -- Function
        ['if'] = { query = '@function.inner',   desc = 'function body' },
        ['af'] = { query = '@function.outer',   desc = 'function declaration' },
        -- Class
        ['ic'] = { query = '@class.inner',      desc = 'class body' },
        ['ac'] = { query = '@class.outer',      desc = 'class declaration' },
        -- Comment
        ['id'] = { query = '@comment.outer',    desc = 'comment' },
    }
end

--#endregion

return M

