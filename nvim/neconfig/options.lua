local opt = vim.opt


--#regioon Files and backup
opt.fileencoding = 'utf-8'      -- Set default file encoding
opt.backup = false              -- Do not backup if the file is overriden
opt.writebackup = false         -- Do not backup if the file is overriden
opt.swapfile = false            -- Do not create swap for buffers
--#endregion


--#region Clipboard and undo
opt.clipboard = 'unnamedplus'   -- Use system clipboard
opt.undofile = true             -- Save file history in a file to keep undos between sessions
--#endregion


--#region Delays
opt.timeoutlen = 1000           -- Wait for a mapped sequence to complete
opt.ttimeoutlen = 0             -- Wait for a keycode sequence to complete
--#endreigon


--#region Menu UI
opt.cmdheight = 2               -- Set the height of the command line
opt.showtabline = 2             -- Always show file tabs
opt.signcolumn = "yes"          -- Show an additional line before the line numbers
opt.number = true               -- Show line numbers
opt.relativenumber = true       -- Make the line numbers relative
opt.numberwidth = 4             -- Set minimum width of the line number column
opt.completeopt = {             -- Configure the the completetion options for Insert mode
    'menu',                         -- Popup menu
    'menuone',                      -- Popup menu even when one match
    'noselect'                      -- No selection by default
}
opt.pumheight = 10              -- Set the size of popup menus
--#endregion


--#region Editor UI
opt.mouse = 'a'                 -- Enable mouse in all modes
opt.cursorline = true           -- Hightlight the line where the cursor is
opt.wrap = false                -- Do not wrap the text
opt.scrolloff = 8               -- Keep lines on top and below the cursor when scrolling
opt.sidescrolloff = 16          -- Keep characters on the left and right of the cursor when scrolling
--#endregion


--#region Splits
opt.splitbelow = true           -- Focus the split below
opt.splitright = true           -- Focus the split to the right
--#endregion


--#region Indentation
opt.expandtab = true            -- Convert <TAB> to <SPACE>s automatically
opt.shiftwidth = 4              -- Set the size of indentation
opt.tabstop = 4                 -- Set the size of <TAB>
opt.smartindent = ture          -- Indent automatically the lines
--#endregion


--#region Typing
opt.backspace = {               -- Configure what can be erased with <BACKSPACE>
    'eol',                          -- Line breaks
    'indent',                       -- Indentation
    'start'                         -- Start of insert
}
--#endregion


--#region Search
opt.ignorecase = true           -- Do case-insensitive searches
opt.smartcase = true            -- Do case-sensitive searches if the pattern has an uppercase
opt.hlsearch= true              -- Hightlight search matches
--#endregion

