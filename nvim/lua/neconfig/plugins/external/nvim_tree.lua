--#region Helpers

-- NvimTree
local nvim_tree_status, nvim_tree = pcall(require, 'nvim-tree')
if not nvim_tree_status then
    vim.notify('Nvim Tree not available', vim.log.levels.ERROR)
    return
end

local nvim_tree_api = require('nvim-tree.api')

local icons = require('neconfig.user.icons').diagnostics

--#endregion


--#region Nvim Tree

-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Nvim Tree
nvim_tree.setup {
    disable_netrw = true,
    hijack_cursor = true,
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = icons
    },
    actions = {
        open_file = {
            resize_window = false
        }
    },
    view = {
        side = 'right',
        width = 30,
        mappings = {
            custom_only = true,
            list = require('neconfig.user.keymaps').nvim_tree_navigation()
        }
    },
    renderer = {
        highlight_git = true,
        indent_markers = {
            enable = true,
            inline_arrows = false
        },
        icons = {
            git_placement = 'after',
            show = {
                folder_arrow = false,
                git = false
            },
            glyphs = require('neconfig.user.icons').nvim_tree
        }
    },
    git = {
        ignore = false
    }
}

-- Mappings
require('neconfig.user.keymaps').nvim_tree_menus(nvim_tree_api)

--#endregion

