local util = require('util')

--#region Case
vim.opt.ignorecase = true
vim.opt.smartcase = true
--#endregion

--#region Navigation
util.map:k('n', 'Next search result, centered'):bind('n', 'nzzzv'):set()
util.map:k('N', 'Previous search result, centered'):bind('n', 'Nzzzv'):set()
util.map:k('<ESC>', 'Clear search highlight'):bind('n', '<CMD>nohlsearch<CR>'):set()
--#endregion

--#region Substitution
vim.opt.inccommand = 'split'
--#endregion
