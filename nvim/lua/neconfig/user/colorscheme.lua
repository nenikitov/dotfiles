--#region Helpers

-- Shortcut to access vim command
local cmd = vim.cmd

-- Name of the colorscheme
local colorscheme = 'termcolors'
-- Name of the colorscheme to fall back if the color scheme was not found
local colorscheme_fallback = 'industry'

--#endregion

cmd('colorscheme ' .. colorscheme_fallback)
local colorscheme_status, _ = pcall(cmd, 'colorscheme ' .. colorscheme)
if not colorscheme_status then
    vim.notify('Color scheme ' .. colorscheme .. ' not found', vim.log.levels.WARN)
    return
end

