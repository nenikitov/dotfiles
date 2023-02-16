--#region Helpers

-- Scrollbar
local satellite_status, satellite = pcall(require, 'satellite')
if not satellite_status then
    vim.notify('Satellite not available', vim.log.levels.ERROR)
    return
end

--#endregion


--#region Satellite

satellite.setup {
    winblend = 0
}

--#endregion

