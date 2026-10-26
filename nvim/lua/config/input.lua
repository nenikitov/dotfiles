local util = require('util')

--#region Mouse
vim.opt.mouse = 'a'
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

--#region Terminal
util.map:k('<ESC><ESC>', 'Leave terminal mode'):bind('t', '<C-\\><C-n>'):set()
--#endregion
