---@class ne.util.vim
local M = {}

---@param name string
---@return integer group_id
function M.augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

return M
