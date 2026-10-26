---@module 'lazy'
---@module 'which-key'

local util = require('util')
local defs = require('defs')

---@type LazySpec
return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	keys = {
		defs.keys.custom:k('?', 'Buffer-local keymaps'):bind('n', function()
			require('which-key').show({ global = false })
		end):spec(),
	},
	---@type wk.Opts
	opts = {
        preset = 'classic',
		win = {
			border = vim.o.winborder,
			padding = { 0, 0 },
		},
		icons = {
			mappings = false,
			breadcrumb = defs.icons.ui.next,
			separator = defs.icons.key.right,
			group = defs.icons.ui.filled .. ' ',
			ellipsis = defs.icons.ui.ellipsis,
			keys = {
				Up = defs.icons.key.up,
				Down = defs.icons.key.down,
				Left = defs.icons.key.left,
				Right = defs.icons.key.right,
				C = defs.icons.key.ctrl,
				M = defs.icons.key.alt,
				D = defs.icons.key.super,
				S = defs.icons.key.shift,
				CR = defs.icons.key.enter,
				NL = defs.icons.key.enter,
				Esc = defs.icons.key.escape,
				ScrollWheelDown = defs.icons.key.mouse_wheel_down,
				ScrollWheelUp = defs.icons.key.mouse_wheel_up,
				BS = defs.icons.key.backspace,
				Space = defs.icons.key.space,
				Tab = defs.icons.key.tab,
				F1 = defs.icons.key.f1,
				F2 = defs.icons.key.f2,
				F3 = defs.icons.key.f3,
				F4 = defs.icons.key.f4,
				F5 = defs.icons.key.f5,
				F6 = defs.icons.key.f6,
				F7 = defs.icons.key.f7,
				F8 = defs.icons.key.f8,
				F9 = defs.icons.key.f9,
				F10 = defs.icons.key.f10,
				F11 = defs.icons.key.f11,
				F12 = defs.icons.key.f12,
			},
		},
	},
    config = function(_, opts)
        require('which-key').setup(opts)

        vim.api.nvim_create_autocmd('VimResized', {
            group = util.vim.augroup('which-key resize'),
            desc = 'Redraw the which-key popup when the terminal is resized',
            callback = function()
                require('which-key.view').update()
            end,
        })
    end,
}
