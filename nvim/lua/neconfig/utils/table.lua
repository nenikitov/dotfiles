local M = {}

--- Apply a function to all key and values of a table.
---@param t table<any, any>
---@param func fun(key: any, value: any): any, any
---@return table mapped
function M.pairs_map(t, func)
    local result = {}

    for k, v in pairs(t) do
        local new_key, new_value = func(k, v)
        result[new_key] = new_value
    end

    return result
end

return M
