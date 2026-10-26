---@module 'lazy'

---@type LazySpec
return {
	'luukvbaal/statuscol.nvim',
	lazy = false,
	dependencies = {
		{
            'dimtion/guttermarks.nvim',
            opts = {}
        },
	},
	opts = function()
		local builtin = require('statuscol.builtin')

		return {
			relculright = true,
			bt_ignore = { 'terminal', 'nofile' },
            segments = {
                -- Breakpoints, only while there are any
                {
                    sign = { name = { 'Dap' }, colwidth = 2, auto = true },
                    click = 'v:lua.ScSa',
                },
                -- Any other sign, only while there are any
                {
                    sign = { name = { '.*' }, namespace = { '.*' }, colwidth = 2, auto = true },
                    click = 'v:lua.ScSa',
                },
                -- Marks
                {
                    sign = { namespace = { 'gutter_marks' }, colwidth = 1 },
                    click = 'v:lua.ScSa',
                },
                -- Line numbers, colored by diagnostics
                {
                    text = { builtin.lnumfunc },
                    condition = { true, builtin.not_empty },
                    click = 'v:lua.ScLa',
                },
                -- Folds
                {
                    text = { builtin.foldfunc, ' ' },
                    click = 'v:lua.ScFa',
                },
                -- Git changes, always reserved
                {
                    sign = { namespace = { 'gitsigns' }, colwidth = 1 },
                    click = 'v:lua.ScSa',
                },
            },
		}
	end,
}
