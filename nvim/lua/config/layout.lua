local util = require('util')
local defs = require('defs')

--#region Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'
vim.opt.equalalways = false

defs.keys.buffer:k('s', 'Split horizontally'):bind('n', '<CMD>split<CR>'):set()
defs.keys.buffer:k('v', 'Split vertically'):bind('n', '<CMD>vsplit<CR>'):set()
--#endregion

--#region Buffers
defs.keys.buffer:k('n', 'Create new empty buffer'):bind('n', '<CMD>enew<CR>'):set()
defs.keys.buffer:k('r', 'Reload from disk'):bind('n', '<CMD>edit<CR>'):set()
--#endregion

--#region Closing
defs.keys.buffer:k('q', 'Quit window'):bind('n', '<CMD>quit<CR>'):set()

vim.api.nvim_create_autocmd('FileType', {
	group = util.vim.augroup('fast close'),
	desc = 'Close informational windows with q or <ESC>',
	pattern = { 'checkhealth', 'help', 'lspinfo', 'man', 'lazy', 'notify', 'query', 'qf' },
	callback = function(event)
		local function close()
			vim.cmd('close')
			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end
		local map = util.map:buf(event.buf)
		map:k('q', 'Quit'):bind('n', close):set()
		map:k('<ESC>', 'Quit'):bind('n', close):set()
	end,
})
--#endregion

--#region Scrolling
-- Keep a percentage of the window visible around the cursor, instead of a fixed number of lines
local scrolloff = 0.2
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinResized', 'VimEnter' }, {
	group = util.vim.augroup('auto scrolloff'),
	desc = 'Update scrolloff to a percentage of each window',
	callback = function()
		vim.opt_local.scrolloff = math.floor(vim.api.nvim_win_get_height(0) * scrolloff)
		vim.opt_local.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) * scrolloff)
	end,
})
--#endregion
