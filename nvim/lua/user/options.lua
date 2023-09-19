local o = vim.opt

-- Files
o.swapfile = false            -- Do not create swap file for buffers
o.clipboard = 'unnamedplus'   -- Use system clipboard
o.undofile = true

-- Keymap delays
o.timeoutlen = 500            -- Wait for a mapped sequence to complete
o.ttimeoutlen = 0             -- Wait for a keycode sequence to complete

-- Line numbers column
o.number = true               -- Show line numbers
o.relativenumber = true       -- Make line numbers relative
o.numberwidth = 3             -- Set minimum width of the line number column

-- Sign column
o.signcolumn = 'yes:1'        -- Always show sign column

-- Tabs
o.showtabline = 2             -- Always show file tabs

-- Menus
o.completeopt = {             -- Set completion options
    'menu',                       -- Popup
    'menuone',                    -- Show menu even with only 1 match
    'noselect'                    -- No selection by default
}
o.pumheight = 10              -- Set size of popups menu

-- Mouse
o.mouse = 'a'                 -- Enable mouse
o.mousemoveevent = true       -- Enable mouse movement tracking

-- Editor UI
o.wrap = false                -- Disable word wrapping
o.scrolloff = 4               -- Keep lines above/below of the cursor
o.sidescrolloff = 8           -- Keep characters left/right of the cursor
o.list = true                 -- Show special characters
o.cursorline = true           -- Highlight current line
o.showmode = false            -- Hide mode from command line

-- Splits
o.splitbelow = true           -- Focus the split below
o.splitright = true           -- Focus the split to the right

-- Indentation
o.expandtab = true            -- Convert <TAB> to <SPACE>s automatically
o.shiftwidth = 4              -- Set the size of indentation
o.tabstop = 4                 -- Set the size of <TAB>
o.smartindent = true          -- Indent automatically the lines

-- Typing
o.backspace = {               -- Configure what can be erased with <BACKSPACE>
    'eol',                        -- Line breaks
    'indent',                     -- Indentation
    'start'                       -- Start of insert
}
vim.cmd(                      -- Disable auto comment
    [[ set formatoptions-=cro ]]
)


-- Search
o.ignorecase = true           -- Do case-insensitive searches
o.smartcase = true            -- Do case-sensitive searches if the pattern has an uppercase
o.hlsearch = true             -- Highlight search matches
