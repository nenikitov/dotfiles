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

---@generic T
---@param predicates (fun(value: T): any)[]
---@return fun(value: T): boolean
function M.any_pass(predicates)
    return function(value)
        for _, predicate in ipairs(predicates) do
            if predicate(value) then
                return true
            end
        end
        return false
    end
end

---@generic T
---@param predicates (fun(value: T): any)[]
---@return fun(value: T): boolean
function M.all_pass(predicates)
    return function(value)
        for _, predicate in ipairs(predicates) do
            if not predicate(value) then
                return false
            end
        end
        return true
    end
end

return M
