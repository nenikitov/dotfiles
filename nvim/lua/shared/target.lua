---@module 'lazy'
---@module 'blink.cmp'

local util = require('util')

---@alias ne.shared.target.MasonTool string | { [1]: string, version?: string }

---@class ne.shared.target.Tools
---@field mason? ne.shared.target.MasonTool[]
---@field nix?   string[]

---@class ne.shared.target.Treesitter
---@field disable_highlight? string[]
---@field disable_indent?    string[]

---@alias ne.shared.target.Server boolean | vim.lsp.Config | fun(): (boolean | vim.lsp.Config)

---@class ne.shared.target.Formatters
---@field by_ft?   string[]
---@field configs? table<string, conform.FormatterConfigOverride | fun(): conform.FormatterConfigOverride>

---@class ne.shared.target.Completion
---@field sources_by_filetype? table<string, string[]>
---@field providers?           table<string, blink.cmp.SourceProviderConfig>

---@class ne.shared.target.DefaultSpec
---@field parsers    string[]
---@field tools      ne.shared.target.Tools
---@field treesitter ne.shared.target.Treesitter
---@field servers    table<string, ne.shared.target.Server>
---@field formatters ne.shared.target.Formatters
---@field completion ne.shared.target.Completion
local default = {
    parsers = {},
    tools = {
        mason = {},
        nix = {},
    },
    treesitter = {},
    servers = {},
    formatters = {
        by_ft = {},
        configs = {},
    },
    completion = {},
}

---@class (partial) ne.shared.target.Spec: ne.shared.target.DefaultSpec
---@field enabled? boolean
---@field plugins? LazySpec

---@class ne.shared.target
---@overload fun(spec: ne.shared.target.Spec): LazySpec
local M = {}

---@type table<string, ne.shared.target.Spec>
local targets = {}

---@param key  string
---@param spec ne.shared.target.Spec
---@return LazySpec
local function define(key, spec)
    targets[key] = spec.enabled ~= false and spec or nil
    return targets[key] and targets[key].plugins or {}
end

---@overload fun(field: 'parsers'): string[]
---@overload fun(field: 'tools'): ne.shared.target.Tools
---@overload fun(field: 'treesitter'): ne.shared.target.Treesitter
---@overload fun(field: 'servers'): table<string, ne.shared.target.Server>
---@overload fun(field: 'formatters'): ne.shared.target.Formatters
---@overload fun(field: 'completion'): ne.shared.target.Completion
---@param field string
---@return table
function M.collect(field)
    local result = default[field]
    local sources = vim.tbl_keys(targets)
    table.sort(sources)
    for _, source in ipairs(sources) do
        local value = targets[source][field]
        if value ~= nil then
            result = util.collection.merge(result, value)
        end
    end
    return result
end

setmetatable(
    M, --[[ @as table ]]
    {
        ---@param spec ne.shared.target.Spec
        ---@return LazySpec
        __call = function(_, spec)
            local key, _ = debug.getinfo(2, 'S')
                .source
                :gsub('^@', '')
            return define(key, spec)
        end,
    }
)

return M
