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

