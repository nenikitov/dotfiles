--#region Helpers

local fn = vim.fn
local CLONE_PATH = 'https://github.com/wbthomason/packer.nvim'
local INSTALL_PATH = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim/'
local RELOAD_ON_PLUGINS_UPDATE = true

--#endregion


--#region Installation

-- Install packer if not already installed
local packer_bootstrapped = false
if fn.empty(fn.glob(INSTALL_PATH)) ~= 0 then
    fn.system({
        'git', 'clone',
        '--depth', '1',
        CLONE_PATH, INSTALL_PATH
    })
    vim.notify('Installed packer, reopen Neovim', vim.log.levels.WARN)
    vim.cmd('packadd packer.nvim')
    packer_bootstrapped = true
end

-- Reload Neovim if the plugins file was modified
if RELOAD_ON_PLUGINS_UPDATE then
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
    use 'wbthomason/packer.nvim'                -- Packer itself
    use 'nvim-lua/popup.nvim'                   -- Popup API
    use 'nvim-lua/plenary.nvim'                 -- Utility library
    use 'nvim-tree/nvim-web-devicons'           -- Icons for plugins

    -- Color scheme
    use 'Mofiqul/vscode.nvim'                   -- VSCode colorscheme

    -- Completion
    use 'hrsh7th/nvim-cmp'                      -- Completion engine
    use 'hrsh7th/cmp-buffer'                        -- From buffer
    use 'hrsh7th/cmp-path'                          -- From file paths
    use 'hrsh7th/cmp-cmdline'                       -- In command line
    use 'hrsh7th/cmp-nvim-lsp'                      -- From LSP
    use 'saadparwaiz1/cmp_luasnip'                  -- From snippets

    -- Snippets
    use 'L3MON4D3/LuaSnip'                      -- Snippet engine
    use 'rafamadriz/friendly-snippets'          -- Collection of snippets

    -- LSP
    use 'williamboman/mason.nvim'               -- Manager for LSPs, DAPs, linters, and formatters
    use 'williamboman/mason-lspconfig.nvim'     -- Bridge lspconfig and mason
    use 'neovim/nvim-lspconfig'                 -- Main LSP config

    -- Telescope
    use 'nvim-telescope/telescope.nvim'         -- Fuzzy finder

    -- Set up the configuration if packer was just installed
    if packer_bootstrapped then
        packer.sync()
    end
end)

--#endregion

