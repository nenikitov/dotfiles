-- TODO: look into [this configuration](https://cmp.saghen.dev/recipes.html#for-writers)

---@module 'lazy'
---@module 'blink.cmp'

local defs = require('defs')

---@type LazySpec
return {
	'saghen/blink.cmp',
	version = '1.*',
	lazy = false,
	dependencies = {
        'rafamadriz/friendly-snippets',
        { 'xzbdmw/colorful-menu.nvim', opts = {} },
    },
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = 'none',
            ['<C-y>'] = { function(cmp) cmp.scroll_documentation_up(1) end },
            ['<C-e>'] = { function(cmp) cmp.scroll_documentation_down(1) end },
			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
			['<C-h>'] = { 'hide', 'snippet_backward', 'fallback' },
			['<C-l>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
			['<C-Space>'] = {
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.hide()
					end
					return cmp.show()
				end,
			},
		},
		appearance = {
			nerd_font_variant = 'mono',
		},
		completion = {
			list = {
				selection = { auto_insert = false },
			},
			menu = {
				border = vim.o.winborder,
				draw = {
					columns = {
						{ 'kind_icon', },
						{ 'label', gap = 1 },
						{ 'source_name' },
					},
					components = {
						kind_icon = {
							text = function(ctx)
                                local icon, _ = require('mini.icons').get('lsp', ctx.kind)
								return icon
							end,
							highlight = function(ctx)
                                local _, hl = require('mini.icons').get('lsp', ctx.kind)
								return hl
							end,
						},
                        kind = {
							highlight = function(ctx)
                                local _, hl = require('mini.icons').get('lsp', ctx.kind)
								return hl
							end,
                        },
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 0,
			},
			ghost_text = { enabled = true },
		},
		signature = {
			enabled = true,
		},
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
			providers = {
				lsp = { name = '[lsp]' },
				path = { name = '[pth]' },
				snippets = { name = '[snp]' },
				buffer = { name = '[buf]' },
				cmdline = { name = '[cmd]' },
			},
		},
		cmdline = {
			keymap = { preset = 'inherit' },
			completion = {
                menu = { auto_show = true },
                list = {
                    selection = { auto_insert = false },
                },
            },
		},
	},
    config = function(_, opts)
        vim.opt.wildchar = 0

        local completion = defs.lang.collect('completion')

        opts.sources.providers = vim.tbl_extend('force', opts.sources.providers, completion.providers or {})
        opts.sources.per_filetype = opts.sources.sources_by_filetype or {}
        for filetype, sources in pairs(completion.per_filetype or {}) do
            opts.sources.per_filetype[filetype] = vim.list_extend({ inherit_defaults = true }, sources)
        end

        require('blink.cmp').setup(opts)
    end,
}
