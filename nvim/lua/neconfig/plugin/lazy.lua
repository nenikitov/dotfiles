--#region Helpers

--- Link to clone lazy.nvim.
local path_clone = 'https://github.com/folke/lazy.nvim.git'
--- Path to install lazy.nvim to.
local path_install = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

--#endregion



--#region Lazy.nvim

-- Bootstrap
if not vim.loop.fs_stat(path_install) then
    -- Lazy not installed - install
    vim.fn.system {
        'git', 'clone',
        '--filter=blob:none',
        path_clone,
        '--branch=stable',
        path_install
    }
end
vim.opt.rtp:prepend(path_install)


-- Setup
require('lazy').setup(
    'neconfig.plugin.config',
    {
        install = {
            colorscheme = { 'slate' }
        },
        ui = {
            border = 'rounded'
        }
    }
)

--#endregion
