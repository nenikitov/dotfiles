local util = require('util')
local defs = require('defs')

-- HACK: Needed on Ubuntu
local parser_paths = vim.tbl_map(vim.fs.dirname, vim.api.nvim_get_runtime_file('parser', true))

local path = vim.fs.joinpath(
	vim.fn.stdpath('data'),
	'lazy',
	'lazy.nvim'
)

if not vim.uv.fs_stat(path) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		path
	})
	if vim.v.shell_error ~= 0 then
		vim.notify('Failed to clone lazy.nvim: ' .. out, vim.log.levels.ERROR)
		vim.notify('Press any key to exit...')
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(path)

-- Event to signal that a file was opened
local Event = require('lazy.core.handler.event')
Event.mappings.LazyFile = { id = 'LazyFile', event = { 'BufReadPost', 'BufNewFile', 'BufWritePre', 'FileType' } }

require('lazy').setup({
	spec = vim.tbl_map(
		function(dir) return { import = dir } end,
		util.fs.discover_dir('plugin', { recursive = true }).dirs
	),
	defaults = { lazy = true },
	change_detection = { notify = false },
    ui = {
        border = vim.o.winborder,
        backdrop = 100,
        title = 'lazy.nvim ' .. defs.icons.plugin.manager,
        icons = {
		    cmd = defs.icons.plugin.source.cmd,
		    config = defs.icons.plugin.source.config,
		    debug = defs.icons.plugin.source.debug,
		    event = defs.icons.plugin.source.event,
			favorite = defs.icons.plugin.status.favorite,
			ft = defs.icons.plugin.source.ft,
			init = defs.icons.plugin.source.init,
			import = defs.icons.plugin.source.import,
			keys = defs.icons.plugin.source.keys,
			lazy = defs.icons.plugin.manager,
			loaded = defs.icons.plugin.status.loaded,
			not_loaded = defs.icons.plugin.status.not_loaded,
			plugin = defs.icons.plugin.source.plugin,
			runtime = defs.icons.plugin.source.runtime,
			require = defs.icons.plugin.source.require,
			source = defs.icons.plugin.source.source,
			start = defs.icons.plugin.source.start,
			task = defs.icons.plugin.status.done,
            list = { defs.icons.ui.item }
        },
    },
    checker = {
        enabled = true,
        notify = false,
    },
	performance = {
		rtp = { paths = parser_paths },
	},
})

defs.keys.plugin:k('l', 'lazy.nvim'):bind('n', '<CMD>Lazy<CR>'):set()
defs.keys.plugin:k('r', 'Reload Neovim and the plugins, keeping the session'):bind('n', function()
	local session = vim.fs.joinpath(vim.fn.stdpath('state'), 'reload-session.vim')
	vim.cmd.mksession({ args = { vim.fn.fnameescape(session) }, bang = true })
	vim.cmd(('restart source %s'):format(vim.fn.fnameescape(session)))
end):set()
