local U = {}

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

---@param array string[]
---@param separator string
---@return string
local function join(array, separator)
    local result = ''
    for i, v in ipairs(array) do
        if i ~= #array then
            result = result .. separator
        end
        result = result .. v
    end
    return result
end

---@generic I, O
---@param array I[]
---@param callback fun(v: I, i: number): O
---@return O[]
local function map(array, callback)
    local result = {}
    for i, v in ipairs(array) do
        table.insert(result, callback(v, i))
    end
    return result
end


---@alias CaseConverterSplit fun(str: string): string[]
---@alias CaseConverterJoin fun(words: string[]): string
---@alias CaseConverter { example: string, split: CaseConverterSplit, join: CaseConverterJoin }

---@type { [string]: CaseConverter }
U.cases = {
    SCREAMING = {
        example = 'SCREAMING_CASE',
        split = function(str)
            return map(
                split(str, '_'),
                function (v) return v:lower() end
            )
        end,
        join = function(words)
            return join(
                map(words, function(v) return v:upper() end),
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
            return join(words, '_')
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
            return join(
                map(
                    words,
                    function(v)
                        local w = v:gsub('^.', string.upper)
                        return w
                    end
                ),
                ''
            )
        end
    },
    PASCAL = {
        example = 'PascalCase',
        split = function(str)
            return map(
                split(str:gsub('([A-Z])', ' $1'), ' '),
                function(v) return v:lower() end
            )
        end,
        join = function (words)
            local w = join(
                map(
                    words,
                    function(v)
                        local w = v:gsub('^.', string.upper)
                        return w
                    end
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
---@return string Converted string.
function U.convert_case(str, from, to)
    return to.join(from.split(str))
end

return U

