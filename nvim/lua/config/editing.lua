local util = require('util')

--#region Indent
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.shiftround = true
vim.opt.softtabstop = -1

util.map:k('<', 'Unindent without exiting visual'):bind('x', '<gv'):set()
util.map:k('>', 'Indent without exiting visual'):bind('x', '>gv'):set()
--#endregion

--#region Folding
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldmethod = 'indent'
--#endregion

--#region Motion
-- Move across wrapped lines
local function g_move(motion)
    return function() return vim.v.count == 0 and 'g' .. motion or motion end
end
util.map:k('j', 'Down'):bind({'n', 'x'}, g_move('j'), {expr = true }):set()
util.map:k('<DOWN>', 'Down'):bind({'n', 'x'}, g_move('j'), {expr = true }):set()
util.map:k('k', 'Up'):bind({'n', 'x'}, g_move('k'), {expr = true }):set()
util.map:k('<UP>', 'Up'):bind({'n', 'x'}, g_move('k'), {expr = true }):set()
-- Move faster
util.map:k('H', 'Start of line (non ws)'):bind('', '^'):set()
util.map:k('L', 'End of line'):bind('', '$'):set()
-- Selection
vim.opt.virtualedit = 'block'
-- Jumps
vim.opt.jumpoptions:append('view')
--#endregion

--#region Scrolling
-- Keep a percentage of the window visible around the cursor, instead of a fixed number of lines
local scrolloff = 0.2
util.vim.autocmd({ 'WinEnter', 'WinResized', 'VimEnter' }, {
	group = util.vim.augroup('ne.config.percent_scrolloff'),
	desc = 'Update scrolloff to a percentage of each window',
	callback = function()
		vim.opt_local.scrolloff = math.floor(vim.api.nvim_win_get_height(0) * scrolloff)
		vim.opt_local.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) * scrolloff)
	end,
})
--#endregion

--#region Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

---@param forward boolean
---@return function
local function search_next(forward)
    return function()
        local key = (vim.v.searchforward == 1) == forward and 'n' or 'N'
        if vim.fn.mode(1):sub(1, 2) == 'no' then
            return key
        end
        return key .. 'zvzz'
    end
end
util.map:k('n', 'Next search result (always down), centered'):bind({ 'n', 'x', 'o' }, search_next(true), { expr = true }):set()
util.map:k('N', 'Previous search result (always up), centered'):bind({ 'n', 'x', 'o' }, search_next(false), { expr = true }):set()

util.map:k('<ESC>', 'Clear search'):bind('n', '<CMD>nohlsearch<CR>'):set()
--#endregion

--#region Automatic formatting
vim.opt.formatoptions = 'qj'
--#endregion

--#region Clipboard
-- HACK: Schedule to keep it out of startup time
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)
--#endregion

--#region Yank / paste
util.map:k('y', 'Yank without moving'):bind('x', 'ygv<ESC>'):set()
util.map:k('p', 'Paste without yanking replaced text'):bind('x', 'P'):set()
util.map:k('dd', 'Delete line without yanking blank lines'):bind('n', function()
	return vim.api.nvim_get_current_line():match('^%s*$') and '"_dd' or 'dd'
end, { expr = true }):set()

util.vim.autocmd({ 'TextYankPost' }, {
    group = util.vim.augroup('ne.config.yank_highlight'),
    desc = 'Highlight text right after yanking',
    callback = function()
        vim.hl.on_yank({ higroup = 'Visual', on_visual = true })
    end
})
--#endregion

--#region Undo
util.map:k('U', 'Redo'):bind('n', '<C-r>'):set()
--#endregion

--#region Remove some filetype overwrites
util.vim.autocmd({ 'FileType' }, {
    group = util.vim.augroup('ne.config.remove_filetype_overrides'),
    desc = 'Reset options changed by filetype plugins to their global values',
    callback = function(args)
        local restore_global = {
            'formatoptions',
            'textwidth',
            'wrap',
            'breakindent',
            'linebreak',
        }
        local keep_indent = {
            make = true,
        }

        if not keep_indent[args.match] then
            vim.list_extend(restore_global, { 'expandtab', 'tabstop', 'shiftwidth', 'softtabstop' })
        end

		for _, name in ipairs(restore_global) do
            vim.opt_local[name] = vim.opt_global[name]:get()
        end
    end
})
--#endregion
