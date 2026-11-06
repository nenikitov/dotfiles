-- TODO: Remove this, move to separate files
---@module 'lazy'

--[[
TODO
- Lsp go to defintion in hover
- Continue comment only in block and doc comments
]]

---@type LazySpec
return {
    -- target
    'OXY2DEV/tree-sitter-comment',

    -- code
    'jmbuhr/otter.nvim',
    'nvimtools/none-ls.nvim',
    'stevearc/conform.nvim',
    'joelazar/blink-calc',
    'smjonas/inc-rename.nvim',
    'aznhe21/actions-preview.nvim',
    'rachartier/tiny-inline-diagnostic.nvim', -- not sure
    'folke/snacks.nvim', -- for debug
    -- debugging
    'mfussenegger/nvim-dap',
    'nvim-neotest/neotest',
    'igorlfs/nvim-dap-view',

    -- workspace
    'FylerOrg/fyler.nvim',
    'MagicDuck/grug-far.nvim',
    'stevearc/quicker.nvim',
    'folke/snacks.nvim', -- for picker, bigfile, rename
    -- terminal
    'akinsho/toggleterm.nvim',
    'brianhuster/unnest.nvim',
    -- git
    'akinsho/git-conflict.nvim',
    'noamsto/resolved.nvim',

    -- editing
    'HakonHarnes/img-clip.nvim',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'brianhuster/treesitter-endwise.nvim',
    'danymat/neogen',
    'monaqa/dial.nvim',
    'numToStr/Comment.nvim',
    'nvim-mini/mini.ai',
    'nvim-mini/mini.align',
    'nvim-mini/mini.splitjoin',
    'nvim-mini/mini.surround',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'tpope/vim-sleuth',
    'windwp/nvim-autopairs', -- Or `blink.pairs'
    'windwp/nvim-ts-autotag',
    'nemanjamalesija/smart-paste.nvim',
    'chrisgrieser/nvim-rip-substitute', -- not sure
    -- navigation
    'chrisgrieser/nvim-spider',
    'nvim-mini/mini.jump',
    'abecodes/tabout.nvim',
    'yorickpeterse/nvim-tree-pairs', -- alternatives?
    'kevinhwang91/nvim-ufo', -- needs a lot of boilerplate to replicate `chrisgrieser/origami`, hl^$ mappings, pause folds for search, pretty fold line, but has best fallback mechanism and custom providers

    -- interface
    'folke/noice.nvim', -- for message forwarding, centered command line, search virtual text
    'folke/snacks.nvim', -- for notifier, dashboard
    'catgoose/nvim-colorizer.lua',
    -- colorschemes
    'Mofiqul/vscode.nvim',
    'catppuccin/nvim',
    'olimorris/onedarkpro.nvim',
    'Ferouk/bearded-nvim',
}
