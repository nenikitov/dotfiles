local shared = require('shared')
local util = require('util')

--#region Recovery
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.confirm = true
--#endregion

--#region Start with cwd if directory was passed
if vim.fn.argc() == 1 then
	local arg = vim.fn.argv(0) --[[@as string]]
	if vim.fn.isdirectory(arg) == 1 then
		vim.fn.chdir(arg)
	end
end
--#endregion

--#region Reloading
util.vim.autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'TermClose', 'TermLeave' }, {
	group = util.vim.augroup('ne.config.reload_changed_files'),
	desc = 'Check if a buffer was changed outside Neovim and reload it',
	callback = function()
		if vim.o.buftype ~= 'nofile' then
			vim.cmd('checktime')
		end
	end,
})
--#endregion

--#region Cursor position
vim.o.shada = vim.o.shada:gsub("'%d+", "'1000")
util.vim.autocmd({ 'BufRead' }, {
	group = util.vim.augroup('ne.config.restore_cursor'),
	desc = 'Return the cursor to its last position when a file is opened',
	callback = function(event)
		util.vim.autocmd({ 'BufWinEnter' }, {
			buffer = event.buf,
			once = true,
			callback = function()
				local ignore_buftype = { 'help' }
				local ignore_filetype = { 'gitcommit', 'gitrebase' }

				if vim.tbl_contains(ignore_buftype, vim.bo[event.buf].buftype) or vim.tbl_contains(ignore_filetype, vim.bo[event.buf].filetype) then
					return
				end

				local line = vim.api.nvim_buf_get_mark(event.buf, '"')[1]
				if line > 1 and line <= vim.api.nvim_buf_line_count(event.buf) then
					vim.cmd('normal! g`"')
				end
			end,
		})
	end,
})
--#endregion

--#region Saving
util.vim.autocmd({ 'BufWritePre', 'FileWritePre' }, {
	group = util.vim.augroup('ne.config.create_missing_directories'),
	desc = "Create a new file's parent directories if they don't exist",
	callback = function(event)
		-- Remote files (like scp:// or ftp://) can't have local directories created for them
		if event.match:find('^%a[%w+.-]*://') then
			return
		end

		local dir = vim.fs.dirname(vim.fn.fnamemodify(event.match, ':p'))
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, 'p')
		end
	end,
})
vim.api.nvim_create_user_command('SudoWrite', function(opts)
	---@param password string
	---@return boolean ok, string err
	local function sudo(password, ...)
		local result = vim.system({ 'sudo', '-S', '-p', '', ... }, { stdin = password .. '\n', text = true }):wait()
		return result.code == 0, vim.trim(result.stderr)
	end

    local current = vim.api.nvim_buf_get_name(0)
	local target = opts.args ~= '' and opts.args or current
	if target == '' then
		vim.notify('SudoWrite: no file name', vim.log.levels.ERROR)
		return
	end
	target = vim.fn.fnamemodify(vim.fn.expand(target), ':p')

	local password = ''
	if vim.system({ 'sudo', '-n', 'true' }):wait().code ~= 0 then
		password = vim.fn.inputsecret('[sudo] password: ')
		if password == '' then
			return
		end
	end

    -- Create dir
    local ok, err = sudo(password, 'mkdir', '-p', vim.fs.dirname(target))
    if not ok then
        vim.notify('SudoWrite can\'t create directory: ' .. err, vim.log.levels.ERROR)
        return
    end

	-- Write to temp file first to get file format, encoding, etc
	local tmp = vim.fn.tempname()
	vim.cmd.write({ args = { tmp }, bang = true, mods = { silent = true, keepalt = true } })

    -- Copy
    ok, err = sudo(password, 'cp', tmp, target)
	os.remove(tmp)
	if not ok then
		vim.notify('SudoWrite can\'t copy written file: ' .. err, vim.log.levels.ERROR)
		return
	end

    -- Update buffer
	if current == '' then
		vim.api.nvim_buf_set_name(0, target)
        vim.cmd([[silent edit!]])
        return
	end

	if target == current then
		vim.bo.modified = false
		vim.cmd.checktime()
	end
end, {
	nargs = '?',
	complete = 'file',
	desc = 'Write the current buffer with sudo',
})
--#endregion

--#region Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.equalalways = false

shared.keys.buffer:k('s', 'Split horizontally'):bind('n', '<CMD>split<CR>'):set()
shared.keys.buffer:k('v', 'Split vertically'):bind('n', '<CMD>vsplit<CR>'):set()

---@type table<string, ne.shared.plugins.Direction>
local directions = { h = 'left', j = 'down', k = 'up', l = 'right' }
for key, direction in pairs(directions) do
    local handlers = shared.plugins.handlers
    util.map:k('<A-' .. key .. '>', 'Focus window ' .. direction):bind('n', handlers.focus_window:bind(direction)):set()
    util.map:k('<A-' .. key:upper() .. '>', 'Swap window ' .. direction):bind('n', handlers.swap_window:bind(direction)):set()
    util.map:k('<C-A-' .. key .. '>', 'Resize window ' .. direction):bind('n', handlers.resize_window:bind(direction)):set()
end
--#endregion

--#region Buffers
shared.keys.buffer_new:bind('n', '<CMD>enew<CR>'):set()
shared.keys.buffer:k('r', 'Reload from disk'):bind('n', '<CMD>edit<CR>'):set()
--#endregion

--#region Closing
shared.keys.buffer_quit:bind('n', '<CMD>quit<CR>'):set()
shared.keys.buffer:k('d', 'Delete buffer'):bind('n', shared.plugins.handlers.close_buffer:bind()):set()

util.vim.autocmd({ 'FileType' }, {
	group = util.vim.augroup('ne.config.close_shortcuts'),
	desc = 'Close informational windows with q or <ESC>',
	pattern = { 'checkhealth', 'help', 'lspinfo', 'man', 'lazy', 'notify', 'query', 'qf' },
	callback = function(event)
		local function close()
			vim.cmd('close')
			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end
		local map = util.map:buf(event.buf)
		map:k('q', 'Quit'):bind('n', close):set()
	end,
})
--#endregion

--#region Terminal
util.map:k('<ESC><ESC>', 'Leave terminal mode'):bind('t', '<C-\\><C-n>'):set()
--#endregion
