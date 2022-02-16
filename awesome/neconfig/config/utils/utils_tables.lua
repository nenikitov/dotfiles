-- Container for widgets
local utils_tables = {}

--#region Helper functions
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
            or
                (type(v) == 'string')
                and '\'' .. v .. '\''
                or tostring(v)

        result = result .. indent_to(level + 1) .. k_string .. v_string .. ',\n'
    end

    return result:sub(1, -3) .. '\n' .. indent_to(level) .. '}'
end
--#endregion


function utils_tables.to_string(table)
    return table_to_string(table, 0)
end

function utils_tables.save_table(table, table_name, path, comment)
    local file = io.open(path, 'w')

    file:write(
        -- Comment
        comment and '-- ' .. comment or '',
        -- Table
        '\nlocal ' .. table_name .. ' = ' .. utils_tables.to_string(table),
        -- Return
        '\n\nreturn ' .. table_name .. '\n'
    )

    file:close()
end

return utils_tables
