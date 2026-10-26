# TODO

## Plugins

- [x] [colorscheme-loader.nvim](https://github.com/nenikitov/colorscheme-loader.nvim/tree/main)
- [ ] Whatever colorscheme I decide to use
- [x] [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [x] [mason.nvim](https://github.com/williamboman/mason.nvim)
- [x] [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)
- [x] [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [x] [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- [x] [lazydev.nvim](https://github.com/folke/lazydev.nvim)
- [ ] [otter.nvim](https://github.com/jmbuhr/otter.nvim)
- [ ] [conform.nvim](https://github.com/stevearc/conform.nvim)
- [ ] [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)
- [ ] [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [ ] [mini-files](https://github.com/echasnovski/mini.nvim)
- [ ] [snacks-picker](https://github.com/folke/snacks.nvim)
- [ ] [blink.cmp](https://github.com/Saghen/blink.cmp)
- [x] [LuaSnip](L3MON4D3/LuaSnip)
- [x] [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [ ] [blink-cmp-spell](https://github.com/ribru17/blink-cmp-spell)
- [ ] [colorful-menu.nvim](https://github.com/xzbdmw/colorful-menu.nvim)
- [ ] [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)
- [ ] [snacks-notifier](https://github.com/folke/snacks.nvim)
- [ ] [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [ ] [noice.nvim](https://github.com/folke/noice.nvim)
- [ ] [mini.icons](https://github.com/echasnovski/mini.nvim)
- [ ] [Comment.nvim](https://github.com/numToStr/Comment.nvim)
- [ ] [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
- [ ] [neogen](https://github.com/danymat/neogen)
- [ ] [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [ ] [mini-ai](https://github.com/echasnovski/mini.nvim)
- [ ] [mini-splitjoin](https://github.com/echasnovski/mini.nvim)
- [ ] [mini-surround](https://github.com/echasnovski/mini.nvim)
- [ ] [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)
- [ ] [nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise)
- [ ] [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
- [ ] [nvim-autpairs](https://github.com/windwp/nvim-autopairs)
- [ ] [dial.nvim](https://github.com/monaqa/dial.nvim)
- [ ] [inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim)
- [ ] [snacks-dashboard](https://github.com/folke/snacks.nvim)
- [ ] [bufresize.nvim](https://github.com/kwkarlwang/bufresize.nvim)
- [ ] [vim-sleuth](https://github.com/tpope/vim-sleuth)
- [ ] [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- [ ] [auto-indent.nvim](https://github.com/VidocqH/auto-indent.nvim)
- [ ] [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)
- [ ] [vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [ ] [nvim-scrollview](https://github.com/dstein64/nvim-scrollview)

## File structure

```py
core                # Basic IDE features (treesitter, lsp, linting, formatting)
    format-lint     #     `conform.nvim`, `none-ls`
    lsp             #     `lspconfig`, `mason` and others, `otter`, BUT NOT `inc-rename` (that would be in `editing`)
    syntax          #     `treesitter`, BUT NOT `nvim-treesitter-textobjects` (that would be in `editing`)
editing             # Features directly assisting in navigating or writing text (completion, snippets, auto pairs, indents, indent-lines, etc)
    comment         #     `Comment.nvim`, `nvim-ts-context-commentstring`, `neogen`
    completion      #     `blink.cmp`, `friendly-snippets`, `colorful-menu`
    indent          #     `vim-sleuth`, `indent-blankline`, `auto-indent`
    motion-action   #     `mini-ai`, `dial.nvim`, `mini-splitjoin`, `inc-rename`, `img-clip`, `vim-illuminate`, `mini-surround`, etc
ui                  # "Global" UI plugins (colorscheme, dashboard, statusline, statuscolumn, gitsigns)
    bar             #     `gitsigns`, `statusline`, `statuscolumn`, `scrollview`
    colorscheme     #     `colorscheme-loader`, whatever colorscheme
    system          #     `snacks-dashboard`, `noice.nvim`, `snacks-notifier`
workspace           # Standalone utitlies about interacting or navigating large number of files (pickers, explorers, search and replace, session management)
    terminal        #     `toggleterm.nvim`
    session         #     Whatever session management plugins
    picker          #     `snacks-picker`, `mini-files`, `snacks-explorer`?
misc                # Other miscellaneous plugins that don't fit into their categories
    ...             #     Whatever
language            # Language-specific plugins or additional options for `core` plugins (`lspconfig`, `mason-tool-installer`, `conform`, and `none-ls`)
    lua.lua
    markdown.lua
    rust.lua
    ...
```
