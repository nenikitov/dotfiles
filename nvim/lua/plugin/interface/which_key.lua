---@module 'lazy'
---@module 'which-key'

local shared = require('shared')
local util = require('util')

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
			keys = shared.icons.key_names,
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

        -- HACK: Force-refresh which-key UI on events upstream missed
        util.vim.autocmd({
            -- The popup keeps its old size when the terminal is resized
            'VimResized',
        }, {
            group = util.vim.augroup('ne.plugin.which_key.refresh'),
            desc = 'Force-refresh which-key UI on events upstream missed',
            callback = function()
                require('which-key.view').update()
            end,
        })
    end,
}
