---@class ne.util.collection
local M = {}

--- Lists are appended, tables are merged key by key, and anything else replaces the target
---@param target any
---@param value any
---@return any
function M.merge(target, value)
    if vim.islist(target) and vim.islist(value) then
        local result = vim.list_extend({}, target)
        return vim.list_extend(result, value)
    end

    if type(target) == 'table' and type(value) == 'table' then
        local result = {}
        for k, v in pairs(target) do
            result[k] = v
        end
        for k, v in pairs(value) do
            result[k] = M.merge(result[k], v)
        end
        return result
    end

	return value
end

return M
