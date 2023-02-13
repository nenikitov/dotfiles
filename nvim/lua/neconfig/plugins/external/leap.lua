--#region Helpers

-- Leap
local leap_status, leap = pcall(require, 'leap')
if not leap_status then
    vim.notify('Leap not available', vim.log.levels.ERROR)
    return
end

--#endregion


--#region Leap

leap.add_default_mappings()

--#endregion

