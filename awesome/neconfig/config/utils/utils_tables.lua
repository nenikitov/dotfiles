-- Container for widgets
local utils_tables = {}

--#region Helper functions
local function table_to_string(t, level)
    local function indent_to(l)
        return string.rep('    ', l)
    end

    local result = '{\n'

    local keys = {}
    for k in pairs(t) do table.insert(keys, k) end
    table.sort(keys)

    for _, k in ipairs(keys) do
        local v = t[k]
        local k_string =
            (type(k) == 'number')
            and ''
            or '[\'' .. k .. '\']' .. ' = '
        local v_string =
            (type(v) == 'table')
            and table_to_string(v, level + 1)
            or
                (type(v) == 'string')
                and '\'' .. v .. '\''
                or tostring(v)

        result = result .. indent_to(level + 1) .. k_string .. v_string .. ',\n'
    end


    if result:sub(-2) == ',\n' then
        result = result:sub(1, -3)
    end

    return result .. '\n' .. indent_to(level) .. '}'
end
--#endregion


function utils_tables.to_string(table)
    return table_to_string(table, 0)
end

function utils_tables.save_table(table, path, table_name, ...)
    local file = io.open(path, 'w')

    -- Comments
    local comments = ''
    for _, c in ipairs({...}) do
        comments = comments .. '-- ' .. c .. '\n'
    end

    file:write(
        -- Comment
        comments ..
        -- Table
        'local ' .. table_name .. ' = ' .. utils_tables.to_string(table),
        -- Return
        '\n\nreturn ' .. table_name .. '\n'
    )

    file:close()
end

return utils_tables
