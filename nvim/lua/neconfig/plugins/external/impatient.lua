--#region Helpers

-- Impatient
local impatient_status, impatient = pcall(require, 'impatient')

--#endregion


--#region Impatient

if impatient_status then
    impatient.enable_profile()
end

--#endregion

