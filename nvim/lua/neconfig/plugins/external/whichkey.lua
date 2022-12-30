--#region Helpers

-- Whichkey
local whichkey_status, whichkey = pcall(require, "which-key")
if not whichkey_status then
	vim.notify("Whichkey not available", vim.log.levels.ERROR)
	return
end

--#endregion


--#region Whichkey

whichkey.setup {
    window = {
        border = 'rounded'
    }
}

--#endregion

