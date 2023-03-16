--#region Helpers

-- Imports
local log = require('neconfig.utils.log')

--- Shortcut to `vim.cmd`.
local cmd = vim.cmd

--- Name of the colorscheme.
local colorscheme = 'termcolors'
--- Name of the colorscheme to fall back if the color scheme was not found.
local colorscheme_fallback = 'slate'

--#endregion



--#region Color scheme

local colorscheme_status, _ = pcall(cmd, 'colorscheme ' .. colorscheme)
if not colorscheme_status then
    log.warning('Color scheme ' .. colorscheme .. ' not available')
    cmd('colorscheme ' .. colorscheme_fallback)
    return
end

--#endregion
