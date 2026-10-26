local defs = require('defs')

--#region Colors
if defs.settings.enable_tty_mode then
	vim.opt.termguicolors = false
end
--#endregion

--#region Gutter
-- Relative line numbers, with the absolute number on the cursor line
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
-- Always reserve one column for signs, so text doesn't shift when they appear
vim.opt.signcolumn = 'yes:1'
-- One column for fold markers
vim.opt.foldcolumn = '1'
--#endregion

--#region Lines
-- Highlight the cursor line
vim.opt.cursorline = true
-- Show a closed fold's first line with its normal highlighting
vim.opt.foldtext = ''
--#endregion

--#region Special characters
vim.opt.list = true
vim.opt.listchars = {
	tab = '  ' .. defs.icons.whitespace.tab,
	lead = defs.icons.whitespace.space_visible,
	trail = defs.icons.whitespace.space_visible,
	nbsp = defs.icons.whitespace.nbsp,
	extends = defs.icons.ui.next,
	precedes = defs.icons.ui.preceeds,
}
vim.opt.fillchars = {
	fold = ' ',
	foldsep = ' ',
	foldopen = vim.trim(defs.icons.ui.opened),
	foldclose = vim.trim(defs.icons.ui.closed),
}
--#endregion

--#region Windows
-- One status line for the whole editor instead of one per window
vim.opt.laststatus = 3
-- Default border for floating windows
vim.opt.winborder = defs.icons.border
--#endregion

--#region Messages
-- Don't show "written" messages after saving
vim.opt.shortmess:append('W')
-- Terminal title
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%) - %{fnamemodify(getcwd(), ":t")}'
--#endregion
