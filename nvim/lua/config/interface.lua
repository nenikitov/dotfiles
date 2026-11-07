local shared = require('shared')
local util = require('util')

--#region Colors
if shared.settings.enable_tty_mode then
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
vim.opt.cursorline = true
-- Show a closed fold's first line with its normal highlighting
vim.opt.foldtext = ''
--#endregion

--#region Wrapping
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.smoothscroll = true
--#endregion

--#region Special characters
vim.opt.list = true
vim.opt.listchars = {
	tab = '  ' .. shared.icons.space.char.tab,
	lead = shared.icons.space.char.space_visible,
	trail = shared.icons.space.char.space_visible,
	nbsp = shared.icons.space.char.nbsp,
	extends = shared.icons.ui.next,
	precedes = shared.icons.ui.previous,
}
vim.opt.fillchars = {
	fold = ' ',
	foldsep = ' ',
	foldopen = vim.trim(shared.icons.ui.opened),
	foldclose = vim.trim(shared.icons.ui.closed),
}
--#endregion

--#region Windows
vim.opt.showtabline = 2
vim.opt.laststatus = 3
vim.opt.winborder = shared.icons.border
vim.opt.cmdheight = 0
--#endregion

--#region Messages
-- Don't show "written" messages after saving
vim.opt.shortmess:append('W')
-- Terminal title
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%) - %{fnamemodify(getcwd(), ":t")}'
--#endregion

--#region Mouse
vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true
vim.opt.mousescroll = 'ver:1,hor:2'
vim.opt.mousemodel = 'extend'

util.map:k('<S-ScrollWheelUp>', 'Scroll left'):bind({ 'n', 'x', 'i' }, '<ScrollWheelLeft>'):set()
util.map:k('<S-ScrollWheelDown>', 'Scroll right'):bind({ 'n', 'x', 'i' }, '<ScrollWheelRight>'):set()
--#endregion

--#region Timing
vim.opt.updatetime = 300
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 0
--#endregion
