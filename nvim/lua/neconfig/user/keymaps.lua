--#region Helpers


-- List of modes
local mode = {
    ALL          = '',
    NORMAL       = 'n',
    INSERT       = 'i',
    VISUAL       = 'v',
    VISUAL_BLOCK = 'x',
    TERM         = 't',
    COMMAND      = 'c',
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

-- Container for plugin keymaps functions
local M = {}

--#endregion


--#region Leader key
map(mode.ALL, '<SPACE>', '<NOP>')
vim.g.mapleader = ' '
--#endregion


--#region Splits

-- Split
map(mode.NORMAL, '<A-UP>',    ':split<CR>',  'Split vertically')
map(mode.NORMAL, '<A-DOWN>',  ':split<CR>',  'Split vertically')
map(mode.NORMAL, '<A-LEFT>',  ':vsplit<CR>', 'Split horizontally')
map(mode.NORMAL, '<A-RIGHT>', ':vsplit<CR>', 'Split horizontally')
-- Close
map(
    mode.NORMAL,
    '<C-c>',
    function()
        local buffer_number = vim.api.nvim_get_current_buf()
        if not vim.bo[buffer_number].modified then
            vim.cmd('q')
        else
            print('Cannot close a modified buffer')
        end
    end,
    'Close the current buffer'
)
-- Go to
map(mode.NORMAL, '<C-k>', '<C-w>k', 'Go to split on the top')
map(mode.NORMAL, '<C-j>', '<C-w>j', 'Go to split on the bottom')
map(mode.NORMAL, '<C-h>', '<C-w>h', 'Go to split on the left')
map(mode.NORMAL, '<C-l>', '<C-w>l', 'Go to split on the right')
-- Resize
map(mode.NORMAL, '<C-UP>',    ':resize +1<CR>',          'Increase the size of the split vertically')
map(mode.NORMAL, '<C-DOWN>',  ':resize -1<CR>',          'Decrease the size of the split vertically')
map(mode.NORMAL, '<C-LEFT>',  ':vertical resize -1<CR>', 'Increase the size of the split horizontally')
map(mode.NORMAL, '<C-RIGHT>', ':vertical resize +1<CR>', 'Decrease the size of the split horizontally')

--#endregion


--#region Editing

-- Faster exit out of insert mode
map(mode.INSERT, '<A-SPACE>', '<ESC>', 'Exit out of insert mode')

-- Do not exit out of visual mode when indenting
map(mode.VISUAL, '<', '<gv', 'Unindent without quitting visual mode')
map(mode.VISUAL, '>', '>gv', 'Indent without quitting visual mode')

-- Keep clipboard when pasting in visual mode
map(mode.VISUAL, 'p', '"_dP', 'Paste in visual mode and keep clipboard')

-- Better SHIFT + direction navigation
map({ mode.NORMAL, mode.VISUAL }, 'H', '^', 'Go to the beginning of the line')
map({ mode.NORMAL, mode.VISUAL }, 'L', '$', 'Go to the end of the line')

-- Paste in insert mode
map(mode.INSERT, '<C-v>', '<C-r>+', 'Paste directly in insert mode')

-- Clear search
map(mode.NORMAL, '<M-/>', ':let @/ = ""<CR>', 'Clear previous search highlighting')

--#endregion


--#region Completion

function M.completion(cmp)
    return {
        -- Documentation
        ['<C-u>']     = cmp.mapping.scroll_docs(-1),
        ['<C-i>']     = cmp.mapping.scroll_docs(1),
        -- Items
        ['<C-j>']     = cmp.mapping.select_next_item(),
        ['<C-k>']     = cmp.mapping.select_prev_item(),
        -- Confirm & abort
        ['<C-SPACE>'] = cmp.mapping.complete(),
        ['<C-e>']     = cmp.mapping.abort(),
        ['<C-l>']     = cmp.mapping.confirm { select = true },
    }
end

--#endregion


--#region LSP

function M.lsp()
    local buffer_option = { buffer = true }
    -- Diagnostics
    map(mode.NORMAL, '<LEADER>do', vim.diagnostic.open_float, 'Open diagnostics menu')
    map(mode.NORMAL, '<LEADER>d[', vim.diagnostic.goto_prev,  'Go to previous diagnostic')
    map(mode.NORMAL, '<LEADER>d]', vim.diagnostic.goto_next,  'Go to next diagnostic')
    map(mode.NORMAL, '<LEADER>dl', vim.diagnostic.setloclist, 'Show diagnostic list')
    -- Go do
    map(mode.NORMAL, '<LEADER>lgd', vim.lsp.buf.definition,     'Go to definition',     buffer_option)
    map(mode.NORMAL, '<LEADER>lgi', vim.lsp.buf.implementation, 'Go to implementation', buffer_option)
    map(mode.NORMAL, '<LEADER>lgr', vim.lsp.buf.references,     'Go to references',     buffer_option)
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
    map(mode.NORMAL, '<LEADER>lrr', vim.lsp.buf.rename, buffer_option)
    map(
        mode.NORMAL,
        '<LEADER>lrf',
        function()
            vim.lsp.buf.format { async = true }
        end,
        'Format document',
        buffer_option
    )
    -- Code action
    map(mode.NORMAL, '<LEADER>lca', vim.lsp.buf.code_action, 'Show automatic fixes', buffer_option)
end

--#endregion


--#region Telescope

function M.telescope_menus(telescope)
    map(mode.NORMAL, '<LEADER>tf', telescope.find_files,    'Open file picker')
    map(mode.NORMAL, '<LEADER>tg', telescope.live_grep,     'Open grep picker')
    map(mode.NORMAL, '<LEADER>tb', telescope.buffers,       'Open buffers picker')
    map(mode.NORMAL, '<LEADER>tq', telescope.quickfix,      'Open quick fix picker')
    map(mode.NORMAL, '<LEADER>ts', telescope.spell_suggest, 'Open spell suggestion picker')
    map(mode.NORMAL, '<LEADER>td', telescope.diagnostics,   'Open diagnostics picker')
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

function M.comment_toggler()
    return {
        line  = '<LEADER>ccc',
        block = '<LEADER>cbc'
    }
end

function M.comment_opleader()
    return {
        line  = '<LEADER>cc',
        block = '<LEADER>cb'
    }
end

--#endregion


--#region Gitsigns

function M.gitsigns(gitsigns)
    map(mode.NORMAL, '<LEADER>gd', gitsigns.preview_hunk, 'Preview the differences in the current hunk')
    map(mode.NORMAL, '<LEADER>gb', gitsigns.blame_line,   'Blame current line')
    map(mode.NORMAL, '<LEADER>gr', gitsigns.reset_hunk,   'Reset current hunk')
end

--#endregion


--#region NvimTree

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

function M.bufferline(bufdelete)
    map(mode.NORMAL, '<M-h>',       ':BufferLineCyclePrev<CR>',                   'Go to previous buffer')
    map(mode.NORMAL, '<M-l>',       ':BufferLineCycleNext<CR>',                   'Go to next buffer')
    map(mode.NORMAL, '<M-j>',       ':BufferLineMovePrev<CR>',                    'Move buffer to the left')
    map(mode.NORMAL, '<M-k>',       ':BufferLineMoveNext<CR>',                    'Move buffer to the right')
    map(mode.NORMAL, '<LEADER>bpp', ':BufferLinePick<CR>',                        'Select a buffer')
    map(mode.NORMAL, '<LEADER>bpc', ':BufferLinePickClose<CR>',                   'Close a buffer')
    map(mode.NORMAL, '<LEADER>bc',  function() bufdelete.bufdelete(0, false) end, 'Close a buffer')
end

--#endregion

return M

