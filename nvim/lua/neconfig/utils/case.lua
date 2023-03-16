--#region Helpers

--- Module return.
local M = {}

--#endregion



--#region Case

---@param str string
---@param separator string
---@return string[]
local function split(str, separator)
    local result = {}
    for w in str:gmatch('([^'.. separator ..']+)') do
        table.insert(result, w)
    end
    return result
end


---@alias CaseConverterSplit fun(str: string): string[]
---@alias CaseConverterJoin fun(words: string[]): string
---@alias CaseConverter { example: string, split: CaseConverterSplit, join: CaseConverterJoin }

---@type { [string]: CaseConverter }
M.cases = {
    SCREAMING = {
        example = 'SCREAMING_CASE',
        split = function(str)
            return vim.tbl_map(
                function (v) return v:lower() end,
                split(str, '_')
            )
        end,
        join = function(words)
            return table.concat(
                vim.tbl_map(
                    function(v) return v:upper() end,
                    words
                ),
                '_'
            )
        end
    },
    SNAKE = {
        example = 'sname_case',
        split = function(str)
            return split(str, '_')
        end,
        join = function(words)
            return table.concat(words, '_')
        end
    },
    CAMEL = {
        example = 'CamelCase',
        split = function(str)
            return map(
                split(str:gsub('([A-Z])', ' $1'), ' '),
                function(v) return v:lower() end
            )
        end,
        join = function (words)
            return table.concat(
                vim.tbl_map(
                    function(v)
                        local w = v:gsub('^.', string.upper)
                        return w
                    end,
                    words
                ),
                ''
            )
        end
    },
    PASCAL = {
        example = 'PascalCase',
        split = function(str)
            return vim.tbl_map(
                function(v) return v:lower() end,
                split(str:gsub('([A-Z])', ' $1'), ' ')
            )
        end,
        join = function (words)
            local w = table.concat(
                vim.tbl_map(
                    function(v)
                        local w = v:gsub('^.', string.upper)
                        return w
                    end,
                    words
                ),
                ''
            )
            w = w:gsub('^.', string.lower)
            return w
        end
    }
}

--- Convert a string from one case to another.
---@param from CaseConverter Original case.
---@param to CaseConverter Case to convert to.
---@return string converted Converted string.
function M.convert_case(str, from, to)
    return to.join(from.split(str))
end

--#endregion



--#region Exports

return M

--#endregion
