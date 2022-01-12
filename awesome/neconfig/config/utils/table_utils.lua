local table_utils = {}

function table_utils.get_with_default(custom_table, default_table, ...)
    if table_utils.table_walk(custom_table, ...) ~= nil then
        return table_utils.table_walk(custom_table, ...)
    else
        return table_utils.table_walk(default_table, ...)
    end
end

function table_utils.table_walk(table, ...)
    local current_table = table

    for i = 1, select('#', ...) do
        local key = select(i, ...)
        local value  = current_table[key]
        if value ~= nil then
            current_table = value
        else
            return nil
        end
    end

    return current_table
end

return table_utils
