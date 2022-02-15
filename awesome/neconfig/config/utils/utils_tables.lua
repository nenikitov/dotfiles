-- Container for widgets
local utils_tables = {}

local function table_to_string(table, level)
    level = level or 0
    local function indent_to(l)
        return string.rep('    ', l)
    end

    local result = '{\n'

    for k, v in pairs(table) do
        local k_string =
            (type(k) == 'number')
            and ''
            or tostring(k) .. ' = '
        local v_string =
            (type(v) == 'table')
            and table_to_string(v, level + 1)
            or tostring(v)

        result = result .. indent_to(level + 1) .. k_string .. v_string .. ',\n'
    end

    return result:sub(1, -3) .. '\n' .. indent_to(level) .. '}'
end

function utils_tables.to_string(table)
    return table_to_string(table, 0)
end

function utils_tables.save_table(table, path)
    
end

return utils_tables
