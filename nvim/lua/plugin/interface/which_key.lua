---@module 'lazy'
---@module 'which-key'

local util = require('util')
local shared = require('shared')

---@type LazySpec
return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	keys = {
		shared.keys.custom:k('?', 'Buffer-local keymaps'):bind('n', function()
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
			breadcrumb = shared.icons.ui.next,
			separator = shared.icons.key.right,
			group = shared.icons.ui.filled .. ' ',
			ellipsis = shared.icons.ui.ellipsis,
			keys = {
				Up = shared.icons.key.up,
				Down = shared.icons.key.down,
				Left = shared.icons.key.left,
				Right = shared.icons.key.right,
				C = shared.icons.key.control,
				M = shared.icons.key.alt,
				D = shared.icons.key.super,
				S = shared.icons.key.shift,
				CR = shared.icons.key.enter,
				NL = shared.icons.key.enter,
				Esc = shared.icons.key.escape,
				ScrollWheelDown = shared.icons.key.mouse_wheel_down,
				ScrollWheelUp = shared.icons.key.mouse_wheel_up,
				BS = shared.icons.key.backspace,
				Space = shared.icons.key.space,
				Tab = shared.icons.key.tab,
				F1 = shared.icons.key.f1,
				F2 = shared.icons.key.f2,
				F3 = shared.icons.key.f3,
				F4 = shared.icons.key.f4,
				F5 = shared.icons.key.f5,
				F6 = shared.icons.key.f6,
				F7 = shared.icons.key.f7,
				F8 = shared.icons.key.f8,
				F9 = shared.icons.key.f9,
				F10 = shared.icons.key.f10,
				F11 = shared.icons.key.f11,
				F12 = shared.icons.key.f12,
			},
		},
	},
    config = function(_, opts)
        require('which-key').setup(opts)

        vim.api.nvim_create_autocmd('VimResized', {
            group = util.vim.augroup('ne.plugin.which_key_refresh'),
            desc = 'Redraw which-key popup when the terminal is resized',
            callback = function()
                require('which-key.view').update()
            end,
        })
    end,
}
