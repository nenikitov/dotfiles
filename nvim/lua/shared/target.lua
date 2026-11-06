---@module 'lazy'
---@module 'blink.cmp'

local util = require('util')

---@alias ne.shared.target.Server boolean | vim.lsp.Config | fun(): (boolean | vim.lsp.Config)

---@alias ne.shared.target.MasonTool string | { [1]: string, version?: string }

---@class ne.shared.target.Tools
---@field mason? ne.shared.target.MasonTool[]
---@field nix? string[]

---@class ne.shared.target.Treesitter
---@field disable_highlight? string[]
---@field disable_indent? string[]

---@class ne.shared.target.Completion
---@field sources_by_filetype? table<string, string[]>
---@field providers? table<string, blink.cmp.SourceProviderConfig>

---@class ne.shared.target.Spec
---@field enabled? boolean
---@field tools? ne.shared.target.Tools
---@field parsers? string[]
---@field servers? table<string, ne.shared.target.Server>
---@field treesitter? ne.shared.target.Treesitter
---@field completion? ne.shared.target.Completion
---@field plugins? LazySpec

---@class ne.shared.target
---@overload fun(spec: ne.shared.target.Spec): LazySpec
local M = {}

---@type table<string, ne.shared.target.Spec>
local targets = {}

---@param key string
---@param spec ne.shared.target.Spec
---@return LazySpec
local function define(key, spec)
	targets[key] = spec.enabled ~= false and spec or nil
	return targets[key] and targets[key].plugins or {}
end

---@overload fun(field: 'tools'): ne.shared.target.Tools
---@overload fun(field: 'parsers'): string[]
---@overload fun(field: 'servers'): table<string, ne.shared.target.Server>
---@overload fun(field: 'treesitter'): ne.shared.target.Treesitter
---@overload fun(field: 'completion'): ne.shared.target.Completion
---@param field string
---@return table
function M.collect(field)
	local result = {}
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

setmetatable(M --[[ @as table ]], {
	---@param spec ne.shared.target.Spec
	---@return LazySpec
	__call = function(_, spec)
        local key, _ = debug.getinfo(2, 'S').source:gsub('^@', '')
		return define(key, spec)
	end,
})

return M
