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
    print('Installed packer, reopen Neovim')
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
    print('Error while loading packer')
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
    use 'wbthomason/packer.nvim'    -- Packer itself
    use 'nvim-lua/popup.nvim'       -- Popup API
    use 'nvim-lua/plenary.nvim'     -- Utility library


    -- Set up the configuration if packer was just installed
    if packer_bootstrapped then
        packer.sync()
    end
end)

--#endregion

