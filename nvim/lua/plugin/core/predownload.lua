-- TODO: Remove this, move to separate files
---@module 'lazy'

--[[
TODO
- Lsp go to defintion in hover
- # and indent
    vim.opt_local.cinoptions:append('#1')  -- '#' lines can be shifted with >>
    vim.opt_local.cinkeys:remove('0#')     -- typing '#' doesn't remove the indent
- Continue comment only in block and doc comments
]]

---@type LazySpec
return {
    -- core
	'jmbuhr/otter.nvim',
	'kevinhwang91/nvim-ufo', -- needs a lot of boilerplate to replicate `chrisgrieser/origami`, hl^$ mappings, pause folds for search, pretty fold line, but has best fallback mechanism and custom providers
	'nvimtools/none-ls.nvim',
	'stevearc/conform.nvim',
    'OXY2DEV/tree-sitter-comment',
    'catgoose/nvim-colorizer.lua',
    'folke/snacks.nvim', -- for bigfile, rename
    'joelazar/blink-calc',
    'smjonas/inc-rename.nvim',
	-- debugging
	'mfussenegger/nvim-dap',
	'nvim-neotest/neotest',
	'igorlfs/nvim-dap-view',

    -- editing
	'HakonHarnes/img-clip.nvim',
	'JoosepAlviste/nvim-ts-context-commentstring',
	'brianhuster/treesitter-endwise.nvim',
	'chrisgrieser/nvim-spider',
	'danymat/neogen',
	'monaqa/dial.nvim',
	'numToStr/Comment.nvim',
	'nvim-mini/mini.ai',
	'nvim-mini/mini.align',
	'nvim-mini/mini.jump',
	'nvim-mini/mini.splitjoin',
	'nvim-mini/mini.surround',
	'nvim-treesitter/nvim-treesitter-textobjects',
	'tpope/vim-sleuth',
	'windwp/nvim-autopairs', -- Or `blink.pairs'
	'windwp/nvim-ts-autotag',
    'abecodes/tabout.nvim',
    'nemanjamalesija/smart-paste.nvim',
    'noamsto/resolved.nvim',
    'yorickpeterse/nvim-tree-pairs', -- alternatives?

    -- ui
	'Bekaboo/dropbar.nvim',
	'RRethy/vim-illuminate',
	'folke/noice.nvim', -- for message forwarding, centered command line, search virtual text
	'folke/snacks.nvim', -- for notifier, dashboard, debug
	'mihovilrak/scroll.nvim',
	'nvim-treesitter/nvim-treesitter-context',
	'rebelot/heirline.nvim', -- for statusline and tabline
    'rachartier/tiny-inline-diagnostic.nvim', -- not sure
    'stevearc/quicker.nvim',

	-- colorschemes
	'Mofiqul/vscode.nvim',
	'catppuccin/nvim',
	'olimorris/onedarkpro.nvim',
    'Ferouk/bearded-nvim',
    'idr4n/andromeda.nvim',

    -- layout
	'kwkarlwang/bufresize.nvim',
	'mrjones2014/smart-splits.nvim',

	-- workspace
	'MagicDuck/grug-far.nvim',
	'akinsho/toggleterm.nvim',
    'FylerOrg/fyler.nvim',
    'akinsho/git-conflict.nvim',
    'aznhe21/actions-preview.nvim',
    'brianhuster/unnest.nvim',
    'chrisgrieser/nvim-rip-substitute', -- not sure
    'folke/snacks.nvim', -- for picker
}
