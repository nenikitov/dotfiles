local icon = require('util.icon')

--#region Recovery

-- Do not use swap files for recovery if (obviously never happens) neovim crashes
vim.opt.swapfile = false
-- Save undo history to a file to persist between sessions
vim.opt.undofile = true
-- Number of changes that can be undone
vim.opt.undolevels = 10000
-- Show confirmation dialogues instead of failing the operation (for example closing an unsaved buffer)
vim.opt.confirm = true

--#endregion

--#region GUI

-- Show line numbers
vim.opt.number = true
-- Use relative numbers instead of absolute
vim.opt.relativenumber = true
-- Minimal width of the number column
vim.opt.numberwidth = 3
-- Show sign column (gutter and folds)
vim.opt.signcolumn = "yes:1"
-- Characters to use for sign column
vim.opt.fillchars = {
    fold = " ",
    foldsep = " ",
    --foldopen = icon.ui.opened,
    --foldclose = icon.ui.collapsed,
    eob = "`",
}
-- Show a global status line instead of having one for each split
vim.opt.laststatus = 3
-- Highlight current line
vim.opt.cursorline = true
-- Do not show command line (is replaced by noice)
vim.opt.cmdheight = 0
-- Use 24-bit color
--vim.opt.termguicolors = not vim.g.tty_mode
-- Default floating window borders
--vim.opt.winborder = icon.border_name

--#endregion

--#region Editor

-- Percentage of lines (or columns) to keep above/below (left/right) of the cursor at all times
local scrolloff = 0.2
vim.api.nvim_create_autocmd({ "WinEnter", "WinResized", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("auto scrolloff", { clear = true }),
    callback = function()
        vim.opt_local.scrolloff = math.floor(vim.api.nvim_win_get_height(0) * scrolloff)
        vim.opt_local.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) * scrolloff)
    end,
    desc = "Update scrolloff to a percentage for each window",
})
-- Show special characters
vim.opt.list = true
-- Characters to use for special characters
vim.opt.listchars = {
    --tab = icon.special.tab,
    --trail = icon.special.trailing,
    --nbsp = icon.special.nbsp,
    --extends = icon.ui.ellipsis,
    --precedes = icon.ui.ellipsis,
}
-- Format options
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("format options", { clear = true }),
    callback = function()
        vim.opt_local.formatoptions:remove("o")
    end,
    desc = "Update format options to not auto insert comments on `o` and `O`",
})
-- Modes in which cursor is allowed to move past text boundaries
vim.opt.virtualedit = 'block'

--#endregion

--#region Input

-- Enable mouse (for resizing splits)
vim.opt.mouse = "a"
-- Milliseconds to wait for `CursorHold` event
vim.opt.updatetime = 300
-- Milliseconds to wait for completion of a hotkey
vim.opt.timeoutlen = 300
-- Use system clipboard
-- NOTE: `kickstart.nvim` schedules it to reduce startup time
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

--#endregion

--#region Indentation

-- Enable automatic indentation when starting a new line
vim.opt.smartindent = true
-- Insert spaces instead of tab character on `TAB` in INSERT mode
vim.opt.expandtab = true
-- Number of spaces tab character counts for
vim.opt.tabstop = 4
-- Number of spaces used for indentation with `>>` (0 means sync with `tabstop`)
vim.opt.shiftwidth = 0

--#endregion

--#region Wrapping

-- Do not wrap long lines
vim.opt.wrap = false
-- Indent broken long lines that were wrapped
vim.opt.breakindent = true
-- Break long lines at word boundaries instead of exactly at the specified width
vim.opt.linebreak = true
-- Scroll over wrapped lines
vim.opt.smoothscroll = true

--#endregion

--#region Splits

-- When performing a horizontal split, focus the one on the bottom
vim.opt.splitbelow = true
-- When performing a vertical split, focus the one on the right
vim.opt.splitright = true

--#endregion

--#region Search

-- Always perform case-insensitive searches on `:s` or `/`
vim.opt.ignorecase = true
-- When the search contains an uppercase, switch to case-sensitive search instead
vim.opt.smartcase = true

--#endregion

--#region Other

-- Reduce messges
vim.opt.shortmess:append('W')

--#endregion
