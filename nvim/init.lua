local util = require('util')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'x' }, '<SPACE>', '<NOP>')

-- HACK: Load it now so my own defined FileType autocommands take priority
vim.cmd([[filetype plugin indent on]])

for _, file in ipairs(util.fs.discover_dir('config', { recursive = true }).files) do
	require(file)
end

require('plugin')
