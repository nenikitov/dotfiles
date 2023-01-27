--#region Helpers

-- Shade
local shade_status, shade = pcall(require, 'shade')
if not shade_status then
    vim.notify('Shade not available', vim.log.levels.ERROR)
    return
end

--#endregion

--#region Range highlight

-- shade.setup {
--     overlay_opacity = 90
-- }

--#endregion

