--#region Helpers

-- Telescope
local telescope_status, telescope = pcall(require, 'telescope')
if not telescope_status then
    vim.notify('Telescope not available', vim.log.levels.ERROR)
    return
end

-- Telescope actions
local telescope_builtin = require('telescope.builtin')
-- Telescope actions
local telescope_actions = require('telescope.actions')
-- Telescope themes
local telescope_themes = require('telescope.themes')

--#endregion


--#region Telescope

-- Telescope
telescope.setup {
    defaults = {
        mappings = require('neconfig.user.keymaps').telescope_navigation(telescope_actions)
    },
    extensions = {
        project = {
            detection_methods = { 'pattern' }
        },
        ['ui-select'] = {
            telescope_themes.get_dropdown()
        },
        aerial = {
            show_nesting = {
                ['_'] = true
            }
        }
    }
}

-- Extensions
telescope.load_extension('projects')
telescope.load_extension('ui-select')
telescope.load_extension('aerial')

-- Keymaps
require('neconfig.user.keymaps').telescope_menus(telescope, telescope_builtin)

--#endregion

