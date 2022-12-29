--#region Helpers

-- NvimTree
local nvim_tree_status, nvim_tree = pcall(require, 'nvim-tree')
if not nvim_tree_status then
    vim.notify('Nvim Tree not available', vim.log.levels.ERROR)
    return
end

local nvim_tree_api = require('nvim-tree.api')

--#endregion


--#region Nvim Tree

-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Nvim Tree
nvim_tree.setup {
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            error   = '',
            warning = '',
            hint    = '',
            info    = ''
        }
    }
}

-- Mappings
require('neconfig.user.keymaps').nvim_tree(nvim_tree_api)

--#endregion

