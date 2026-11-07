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

        util.map.on_group(function(group)
            if group.buffer and not vim.api.nvim_buf_is_valid(group.buffer) then
                return
            end
            require('which-key').add({
                { group.lhs, group = group.desc, mode = group.mode == '' and 'nxso' or group.mode, buffer = group.buffer },
            })
        end)

        util.vim.autocmd_multiple_events({
            -- The popup keeps its old size when the terminal is resized
            'VimResized',
        }, {
            group = util.vim.augroup('ne.plugin.which_key_refresh'),
            desc = 'Force-refresh which-key UI on events upstream missed',
            callback = function()
                require('which-key.view').update()
            end,
        })
    end,
}
