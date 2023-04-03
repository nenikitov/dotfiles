--#region Helpers

--- Shortcut to `vim.opt`.
local o = vim.opt

--#endregion



--#region Options

-- Files and backup
o.fileencoding = 'utf-8'        -- Set default file encoding
o.backup = false                -- Do not backup if the file is overwritten
o.writebackup = false           -- Do not backup if the file is overwritten
o.swapfile = false              -- Do not create swap for buffers
o.autoread = true               -- Automatically re-read the file if it was modified outside the editor


-- Clipboard and undo
o.clipboard = 'unnamedplus'     -- Use system clipboard
o.undofile = true               -- Save file history in a file to keep undo between sessions


-- Delays
o.timeoutlen = 500              -- Wait for a mapped sequence to complete
o.ttimeoutlen = 0               -- Wait for a keycode sequence to complete


-- Colors
o.termguicolors = false         -- Enable true color
o.background = 'dark'           -- Hint at dark color scheme


-- Menu UI
o.showtabline = 2               -- Always show file tabs
o.signcolumn = 'yes:1'          -- Show an additional line before the line numbers
o.number = true                 -- Show line numbers
o.relativenumber = true         -- Make the line numbers relative
o.numberwidth = 4               -- Set minimum width of the line number column
o.completeopt = {               -- Configure the the completion options for Insert mode
    'menu',                         -- Popup menu
    'menuone',                      -- Popup menu even when one match
    'noselect'                      -- No selection by default
}
o.pumheight = 10                -- Set the size of popup menus

-- Folding
o.foldcolumn = '1'              -- Show fold column
o.foldlevel = 99
o.foldlevelstart = -1           -- Don't fold by default
o.foldenable = true             -- Enable folding
o.fillchars =                   -- Status column characters
    require('neconfig.user.icons').fillchars

-- Editor UI
o.mouse = 'a'                   -- Enable mouse in all modes
o.cursorline = true             -- Highlight the line where the cursor is
o.wrap = false                  -- Do not wrap the text
o.scrolloff = 4                 -- Keep lines on top and below the cursor when scrolling
o.sidescrolloff = 8             -- Keep characters on the left and right of the cursor when scrolling
o.list = true                   -- Show special white-space characters
o.listchars =                   -- How these special white-space characters are displayed
    require('neconfig.user.icons').listchars
o.showmode = false              -- Hide mode from the command line


-- Splits
o.splitbelow = true             -- Focus the split below
o.splitright = true             -- Focus the split to the right


-- Indentation
o.expandtab = true              -- Convert <TAB> to <SPACE>s automatically
o.shiftwidth = 4                -- Set the size of indentation
o.tabstop = 4                   -- Set the size of <TAB>
o.smartindent = true            -- Indent automatically the lines


-- Typing
o.backspace = {                 -- Configure what can be erased with <BACKSPACE>
    'eol',                          -- Line breaks
    'indent',                       -- Indentation
    'start'                         -- Start of insert
}
vim.cmd(                        -- Disable auto comment
    [[ set formatoptions-=cro ]]
)


-- Search
o.ignorecase = true             -- Do case-insensitive searches
o.smartcase = true              -- Do case-sensitive searches if the pattern has an uppercase
o.hlsearch = true               -- Highlight search matches

--#endregion
