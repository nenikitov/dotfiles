--#region Helpers

-- Gitsigns
local gitsigns_status, gitsigns = pcall(require, 'gitsigns')
if not gitsigns_status then
    vim.notify('Gitsigns not available', vim.log.levels.ERROR)
    return
end

local icons = require('neconfig.user.icons').gitsigns
local giticons = {}
for k, v in pairs(icons) do
    giticons[k] = {
        text = v
    }
end

--#endregion


--#region Gitsigns

gitsigns.setup {
    signs = giticons
}

require('neconfig.user.keymaps').gitsigns(gitsigns)

--#endregion

