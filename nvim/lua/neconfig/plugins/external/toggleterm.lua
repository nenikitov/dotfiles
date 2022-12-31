--#region Helpers

-- Toggle term
local toggleterm_status, toggleterm = pcall(require, "toggleterm")
if not toggleterm_status then
	vim.notify("Toggleterm not available", vim.log.levels.ERROR)
	return
end

--#endregion


--#region Toggle term

-- Configuration
toggleterm.setup {
    open_mapping = require('neconfig.user.keymaps').toggleterm_open(),
    hide_numbers = true,
    persist_size = false,
    size = 20
}

-- Keymaps
require('neconfig.user.keymaps').toggleterm()
vim.cmd([[
    autocmd! TermOpen term://* lua require("neconfig.user.keymaps").toggleterm_hook()
]])

-- Open 1 terminal on enter
vim.cmd([[
    augroup open_term
        autocmd!
        autocmd VimEnter * lua vim.cmd('ToggleTerm') vim.cmd('ToggleTermToggleAll')
    augroup end
]])

--#endregion

