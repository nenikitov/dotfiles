--#region Helpers

-- Shortcut to access vim command
local cmd = vim.cmd

-- Name of the colorscheme
local COLORSCHEME = 'vscode'
-- Name of the colorscheme to fall back if the color scheme was not found
local COLORSCHEME_FALLBACK = 'default'

--#endregion

cmd('colorscheme ' .. COLORSCHEME_FALLBACK)
local colorscheme_status, _ = pcall(cmd, 'colorscheme ' .. COLORSCHEME)
if not colorscheme_status then
    vim.notify('Color scheme ' .. COLORSCHEME .. ' not found', vim.log.levels.WARN)
    return
end

