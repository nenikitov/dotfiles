--#region Helpers

local fn = vim.fn
local clone_path = 'https://github.com/wbthomason/packer.nvim'
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim/'
local reload_on_plugin_update = true

--#endregion


--#region Installation

-- Install packer if not already installed
local packer_bootstrapped = false if fn.empty(fn.glob(install_path)) ~= 0 then
    fn.system {
        'git', 'clone',
        '--depth', '1',
        clone_path, install_path
    }
    vim.notify('Installed packer, reopen Neovim', vim.log.levels.WARN)
    vim.cmd('packadd packer.nvim')
    packer_bootstrapped = true
end

-- Reload Neovim if the plugins file was modified
if reload_on_plugin_update then
    vim.cmd([[
        augroup packer_use_config
            autocmd!
            autocmd BufWritePost packer.lua source <afile> | PackerSync
        augroup end
    ]])
end

--#endregion


--#region Configuration

-- Try to load
local packer_status, packer = pcall(require, 'packer')
if not packer_status then
    vim.notify('Error while loading packer', vim.log.levels.ERROR)
    return
end

-- Initialize
packer.init {
    display = {
        open_fn = function()
            return require('packer.util').float { border = 'rounded' }
        end
    }
}

--#endregion


--#region Configuration

return packer.startup(function(use)
    -- Plugins

    -- Essentials
    use 'wbthomason/packer.nvim'                        -- Packer itself
    use 'nvim-lua/popup.nvim'                           -- Popup API
    use 'nvim-lua/plenary.nvim'                         -- Utility library
    use 'nvim-tree/nvim-web-devicons'                   -- Icons for plugins

    -- Color scheme
    use 'Mofiqul/vscode.nvim'                           -- VSCode colorscheme

    -- Completion
    use 'hrsh7th/nvim-cmp'                              -- Completion engine
    use 'hrsh7th/cmp-buffer'                                -- From buffer
    use 'hrsh7th/cmp-cmdline'                               -- From commandline
    use 'hrsh7th/cmp-path'                                  -- From file paths
    use 'hrsh7th/cmp-nvim-lsp'                              -- From LSP
    use 'hrsh7th/cmp-nvim-lua'                              -- Additional Neovim lua features
    use 'saadparwaiz1/cmp_luasnip'                          -- From snippets

    -- Snippets
    use 'L3MON4D3/LuaSnip'                              -- Snippet engine
    use 'rafamadriz/friendly-snippets'                  -- Collection of snippets

    -- LSP
    use 'williamboman/mason.nvim'                       -- Manager for LSPs, DAPs, linters, and formatters
    use 'williamboman/mason-lspconfig.nvim'             -- Bridge lspconfig and mason
    use 'neovim/nvim-lspconfig'                         -- Main LSP config
    use 'ray-x/lsp_signature.nvim'                      -- Automatically show signature when typing a function
    use 'jose-elias-alvarez/null-ls.nvim'               -- Hook non-LSP sources into LSP system

    -- Telescope
    use 'nvim-telescope/telescope.nvim'                 -- Fuzzy finder
    use 'nvim-telescope/telescope-ui-select.nvim'           -- UI Selection through telescope
    use 'ahmedkhalf/project.nvim'                           -- Project browser

    -- Treesitter
    use {                                               -- Better syntax hightlighting
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'nvim-treesitter/playground'                        -- Preview of the highlight tree
    use 'nvim-treesitter/nvim-treesitter-refactor'          -- Refactoring
    use 'p00f/nvim-ts-rainbow'                              -- Rainbow paranthesis
    use 'windwp/nvim-ts-autotag'                            -- Autoclose and rename HTML tags

    -- Comments
    use 'numToStr/Comment.nvim'                         -- Easy commenting
    use 'JoosepAlviste/nvim-ts-context-commentstring'   -- Smarter commentstring with embedded languages

    -- File explorer
    use {                                               -- Tree file explorer with icons
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons'
        }
    }

    -- Tabs
    use {                                               -- Better looking tabs
        'akinsho/bufferline.nvim',
        requires = {
            'nvim-tree/nvim-web-devicons'
        }
    }
    use 'famiu/bufdelete.nvim'                          -- More buffer close commands

    -- Other
    use 'lukas-reineke/indent-blankline.nvim'           -- Indent lines and scopes
    use 'windwp/nvim-autopairs'                         -- Automatically insert pair characters
    use 'lewis6991/gitsigns.nvim'                       -- Git integration
    use 'akinsho/toggleterm.nvim'                       -- Pop up terminal
    use 'folke/which-key.nvim'                          -- Pop up with shortcuts
    use 'lewis6991/impatient.nvim'                      -- Faster loading times

    -- Set up the configuration if packer was just installed
    if packer_bootstrapped then
        packer.sync()
    end
end)

--#endregion

