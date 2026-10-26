local util = require('util')

--#region Indent
vim.g.filetype_recommended_style = 0
for _, ft in ipairs(vim.fn.getcompletion('', 'filetype')) do
	vim.g[ft .. '_recommended_style'] = 0
end

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

--#region Automatic formatting
vim.opt.formatoptions = 'qj'
--#endregion

--#region Wrapping
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.smoothscroll = true
--#endregion

--#region Undo
util.map:k('U', 'Redo'):bind('n', '<C-r>'):set()
--#endregion

--#region Remove some filetype overwrites
vim.api.nvim_create_autocmd('FileType', {
    group = util.vim.augroup('keep global options'),
    desc = 'Reset options changed by filetype plugins to their global values',
    callback = function()
        local keep_global = {
            'formatoptions',
            'textwidth',
            'wrap',
            'breakindent',
            'linebreak',
        }

		for _, name in ipairs(keep_global) do
            vim.opt_local[name] = vim.opt_global[name]:get()
        end
    end
})
--#endregion
