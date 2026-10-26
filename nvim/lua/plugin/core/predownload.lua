-- TODO: Remove this, move to separate files
---@module 'lazy'

---@type LazySpec
return {
	-- core
	'stevearc/conform.nvim',
	'nvimtools/none-ls.nvim',
	'nvimtools/none-ls-extras.nvim',
	'jmbuhr/otter.nvim',
	'nvim-treesitter/nvim-treesitter-context',

	-- editing
	'numToStr/Comment.nvim',
	'JoosepAlviste/nvim-ts-context-commentstring',
	'danymat/neogen',
	{ 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
	'nvim-mini/mini.splitjoin',
	'nvim-mini/mini.surround',
	'windwp/nvim-ts-autotag',
	'brianhuster/treesitter-endwise.nvim',
	'windwp/nvim-autopairs',
	'monaqa/dial.nvim',
	'smjonas/inc-rename.nvim',
	'HakonHarnes/img-clip.nvim',
	'RRethy/vim-illuminate',
	'tpope/vim-sleuth',
	'NMAC427/guess-indent.nvim',
	'VidocqH/auto-indent.nvim',
	'kevinhwang91/nvim-ufo',
	'kevinhwang91/promise-async',
	'ribru17/blink-cmp-spell',

	-- ui
	'folke/snacks.nvim',
	'folke/noice.nvim',
	'MunifTanjim/nui.nvim',
	'nvim-lualine/lualine.nvim',
	'Bekaboo/dropbar.nvim',
	'folke/todo-comments.nvim',
	'dstein64/nvim-scrollview',
	'mihovilrak/scroll.nvim',

	-- colorschemes
	'folke/tokyonight.nvim',
	'olimorris/onedarkpro.nvim',
	'catppuccin/nvim',
	'rebelot/kanagawa.nvim',
	'Mofiqul/vscode.nvim',

	-- workspace
	'nvim-mini/mini.files',
	'mrjones2014/smart-splits.nvim',
	'kwkarlwang/bufresize.nvim',
	'MagicDuck/grug-far.nvim',
	'akinsho/toggleterm.nvim',

	-- languages
	'b0o/SchemaStore.nvim',
	'iamcco/markdown-preview.nvim',
	'chomosuke/typst-preview.nvim',
	'frabjous/knap',
	'aklt/plantuml-syntax',

	-- debugging
	'mfussenegger/nvim-dap',
	'rcarriga/nvim-dap-ui',
	'nvim-neotest/nvim-nio',

	-- misc
	't-troebst/perfanno.nvim',
}
