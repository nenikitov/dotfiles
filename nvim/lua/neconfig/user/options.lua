--#region Helpersoption

-- Shortcut to access vim options
local o = vim.opt

--#endregion


--#region Files and backup
o.fileencoding = 'utf-8'        -- Set default file encoding
o.backup = false                -- Do not backup if the file is overriden
o.writebackup = false           -- Do not backup if the file is overriden
o.swapfile = false              -- Do not create swap for buffers
--#endregion


--#region Clipboard and undo
o.clipboard = 'unnamedplus'     -- Use system clipboard
o.undofile = true               -- Save file history in a file to keep undos between sessions
--#endregion


--#region Delays
o.timeoutlen = 500              -- Wait for a mapped sequence to complete
o.ttimeoutlen = 0               -- Wait for a keycode sequence to complete
--#endreigon


--#region Colors
o.termguicolors = false         -- Enable true color
o.background = 'dark'           -- Hint at dark color scheme
--#endreigon


--#region Menu UI
o.showtabline = 2               -- Always show file tabs
o.signcolumn = 'yes:1'          -- Show an additional line before the line numbers
o.number = true                 -- Show line numbers
o.relativenumber = true         -- Make the line numbers relative
o.numberwidth = 4               -- Set minimum width of the line number column
o.completeopt = {               -- Configure the the completetion options for Insert mode
    'menu',                         -- Popup menu
    'menuone',                      -- Popup menu even when one match
    'noselect'                      -- No selection by default
}
o.pumheight = 10                -- Set the size of popup menus
--#endregion


--#region Editor UI
o.mouse = 'a'                   -- Enable mouse in all modes
o.cursorline = true             -- Hightlight the line where the cursor is
o.wrap = false                  -- Do not wrap the text
o.scrolloff = 8                 -- Keep lines on top and below the cursor when scrolling
o.sidescrolloff = 16            -- Keep characters on the left and right of the cursor when scrolling
o.list = true                   -- Show special white-space characters
o.listchars =                   -- How these special white-space characters are displayed
    require('neconfig.user.icons').listchars
o.showmode = false              -- Hide mode from the command line
--#endregion


--#region Splits
o.splitbelow = true             -- Focus the split below
o.splitright = true             -- Focus the split to the right
--#endregion


--#region Indentation
o.expandtab = true              -- Convert <TAB> to <SPACE>s automatically
o.shiftwidth = 4                -- Set the size of indentation
o.tabstop = 4                   -- Set the size of <TAB>
o.smartindent = true            -- Indent automatically the lines
--#endregion


--#region Typing
o.backspace = {                 -- Configure what can be erased with <BACKSPACE>
    'eol',                          -- Line breaks
    'indent',                       -- Indentation
    'start'                         -- Start of insert
}
vim.cmd                         -- Disable auto comment
    [[ set formatoptions-=cro ]]
--#endregion


--#region Search
o.ignorecase = true             -- Do case-insensitive searches
o.smartcase = true              -- Do case-sensitive searches if the pattern has an uppercase
o.hlsearch= true                -- Highlight search matches
--#endregion

