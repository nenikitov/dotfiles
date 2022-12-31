--#region Helpers

-- Telescope
local telescope_status, telescope = pcall(require, 'telescope')
if not telescope_status then
    vim.notify('Telescope not available', vim.log.levels.ERROR)
    return
end

-- Project
local project_status, project = pcall(require, 'project_nvim')
if not project_status then
    vim.notify('Project not available', vim.log.levels.ERROR)
    return
end

-- Telescope actions
local telescope_builtin = require('telescope.builtin')
-- Telescope actions
local telescope_actions = require('telescope.actions')

--#endregion


--#region Telescope

-- Telescope
telescope.setup {
    defaults = {
        mappings = require('neconfig.user.keymaps').telescope_navigation(telescope_actions)
    }
}

-- Extensions
project.setup {
    detection_methods = { 'pattern' }
}
telescope.load_extension('projects')

-- Keymaps
require('neconfig.user.keymaps').telescope_menus(telescope, telescope_builtin)

--#endregion

