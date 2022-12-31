--#region Helpers

-- Whichkey
local whichkey_status, whichkey = pcall(require, "which-key")
if not whichkey_status then
	vim.notify("Whichkey not available", vim.log.levels.ERROR)
	return
end

--#endregion


--#region Whichkey

-- Whichkey
whichkey.setup {
    window = {
        border = 'rounded'
    }
}

-- Keymap groups
for mode, group in pairs(require('neconfig.user.keymaps').whichkey_groups()) do
    if mode == '' then
        mode = nil
    end
    whichkey.register(group, { mode = mode, prefix = '' })
end

--#endregion

