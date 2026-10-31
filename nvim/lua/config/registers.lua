local util = require('util')

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

vim.api.nvim_create_autocmd('TextYankPost', {
    group = util.vim.augroup('yank highlight'),
    desc = 'Highlight text right after yanking',
    callback = function()
        vim.hl.on_yank({ higroup = 'Visual', on_visual = true })
    end
})
--#endregion
