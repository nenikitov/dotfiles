--#region Helpers

-- List of modes
local MODE = {
    ALL          = '',
    NORMAL       = 'n',
    INSERT       = 'i',
    VISUAL       = 'v',
    VISUAL_BLOCK = 'x',
    TERM         = 't',
    COMMAND      = 'c',
}

-- Default options for keybinds
local DEFAULT_OPTIONS = {
    noremap = true,
    silent = true
}

-- Append default options to the options
local function treat_options(options, description)
    if not options then
        options = {}
    end
    for k, v in pairs(DEFAULT_OPTIONS) do
        if options[k] == nil then
            options[k] = v
        end
    end
    options['desc'] = description
    return options
end

-- Set the keymap
local function map(mode, keys, func, description, options)
    options = treat_options(options, description)
    vim.keymap.set(mode, keys, func, options)
end

-- Container for plugin keymaps functions
local M = {}

--#endregion


--#region Leader key
map(MODE.ALL, '<SPACE>', '<NOP>')
vim.g.mapleader = ' '
--#endregion


--#region Splits

-- Split
map(MODE.NORMAL, '<A-UP>',    ':split<CR>',  'Split vertically')
map(MODE.NORMAL, '<A-DOWN>',  ':split<CR>',  'Split vertically')
map(MODE.NORMAL, '<A-LEFT>',  ':vsplit<CR>', 'Split horizontally')
map(MODE.NORMAL, '<A-RIGHT>', ':vsplit<CR>', 'Split horizontally')
-- Close
map(
    MODE.NORMAL,
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
map(MODE.NORMAL, '<C-k>', '<C-w>k', 'Go to split on the top')
map(MODE.NORMAL, '<C-j>', '<C-w>j', 'Go to split on the bottom')
map(MODE.NORMAL, '<C-h>', '<C-w>h', 'Go to split on the left')
map(MODE.NORMAL, '<C-l>', '<C-w>l', 'Go to split on the right')
-- Resize
map(MODE.NORMAL, '<C-UP>',    ':resize -1<CR>',          'Increase the size of the split vertically')
map(MODE.NORMAL, '<C-DOWN>',  ':resize +1<CR>',          'Decrease the size of the split vertically')
map(MODE.NORMAL, '<C-LEFT>',  ':vertical resize -1<CR>', 'Increase the size of the split horizontally')
map(MODE.NORMAL, '<C-RIGHT>', ':vertical resize +1<CR>', 'Decrease the size of the split horizontally')

--#endregion


--#region Editing

-- Faster exit out of insert mode
map(MODE.INSERT, '<A-SPACE>', '<ESC>', 'Exit out of insert mode')

-- Do not exit out of visual mode when indenting
map(MODE.VISUAL, '<', '<gv', 'Unindent without quitting visual mode')
map(MODE.VISUAL, '>', '>gv', 'Indent without quitting visual mode')

-- Keep clipboard when pasting in visual mode
map(MODE.VISUAL, 'p', '"_dP', 'Paste in visual mode and keep clipboard')

--#endregion


--#region Completion
function M.completion(cmp, luasnip)
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
    map(MODE.NORMAL, '<LEADER>do', vim.diagnostic.open_float, 'Open diagnostics menu')
    map(MODE.NORMAL, '<LEADER>d[', vim.diagnostic.goto_prev,  'Go to previous diagnostic')
    map(MODE.NORMAL, '<LEADER>d]', vim.diagnostic.goto_next,  'Go to next diagnostic')
    map(MODE.NORMAL, '<LEADER>dl', vim.diagnostic.setloclist, 'Show diagnostic list')
    -- Go do
    map(MODE.NORMAL, '<LEADER>lgd', vim.lsp.buf.definition,     'Go to definition',     buffer_option)
    map(MODE.NORMAL, '<LEADER>lgi', vim.lsp.buf.implementation, 'Go to implementation', buffer_option)
    map(MODE.NORMAL, '<LEADER>lgr', vim.lsp.buf.references,     'Go to references',     buffer_option)
    -- Documentation
    map(MODE.NORMAL, '<LEADER>ldh', vim.lsp.buf.hover,          'Show documentation',    buffer_option)
    map(MODE.NORMAL, '<LEADER>lds', vim.lsp.buf.signature_help, 'Show singature', buffer_option)
    -- Workspace folders
    map(MODE.NORMAL, '<LEADER>lwa', vim.lsp.buf.add_workspace_folder,    'Add the folder to workspaces',      buffer_option)
    map(MODE.NORMAL, '<LEADER>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove the folder from workspaces', buffer_option)
    map(
        MODE.NORMAL,
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
    map(MODE.NORMAL, '<LEADER>lrr', vim.lsp.buf.rename, buffer_option)
    map(
        MODE.NORMAL,
        '<LEADER>lrf',
        function()
            vim.lsp.buf.format { async = true }
        end,
        'Format document',
        buffer_option
    )
    -- Code action
    map(MODE.NORMAL, '<LEADER>lca', vim.lsp.buf.code_action, 'Show automatic fixes', buffer_option)
end
--#endregion


--#region Telescope

function M.telescope_pickers(telescope)
    map(MODE.NORMAL, '<LEADER>tf', telescope.find_files,    'Open file picker')
    map(MODE.NORMAL, '<LEADER>tg', telescope.live_grep,     'Open grep picker')
    map(MODE.NORMAL, '<LEADER>tb', telescope.buffers,       'Open buffers picker')
    map(MODE.NORMAL, '<LEADER>tq', telescope.quickfix,      'Open quick fix picker')
    map(MODE.NORMAL, '<LEADER>ts', telescope.spell_suggest, 'Open spell suggestion picker')
    map(MODE.NORMAL, '<LEADER>td', telescope.diagnostics,   'Open diagnostics picker')
end

function M.telescope(actions)
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

return M

