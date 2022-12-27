--#region Helpers

-- Telescope
local telescope_status, telescope = pcall(require, 'telescope')
if not telescope_status then
    vim.notify('Telescope not available', vim.log.levels.ERROR)
    return
end

-- Telescope builtin
local telescope_builtin = require('telescope.builtin')
-- Telescope actions
local telescope_actions = require('telescope.actions')

--#endregion


--#region Telescope

telescope.setup {
    defaults = {
        mappings = require('neconfig.user.keymaps').telescope(telescope_actions)
    }
}

require('neconfig.user.keymaps').telescope_pickers(telescope_builtin)

--#endregion

