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

---@generic K, V
---@param list V[]
---@param key fun(item: V): K
---@return table<K, V[]>
function M.group_by(list, key)
    local result = {}

    for _, item in ipairs(list) do
        local k = key(item)
        result[k] = result[k] or {}
        table.insert(result[k], item)
    end

    return result
end

---@generic T
---@param list T[]
---@param size integer
---@return T[][]
function M.windows(list, size)
    local result = {}
    for first = 1, #list - size + 1 do
        result[#result + 1] = vim.list_slice(list, first, first + size - 1)
    end
    return result
end

---@generic T
---@param list T[]
---@param predicate fun(item: T): boolean
---@return boolean
function M.any(list, predicate)
    for _, item in ipairs(list) do
        if predicate(item) then
            return true
        end
    end
    return false
end

---@generic T
---@param list T[]
---@param predicate fun(item: T): boolean
---@return boolean
function M.all(list, predicate)
    for _, item in ipairs(list) do
        if not predicate(item) then
            return false
        end
    end
    return true
end

return M
