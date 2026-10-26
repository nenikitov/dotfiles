---@module 'lazy'
---@module 'blink.cmp'

local util = require('util')

---@alias ne.defs.lang.Server boolean | vim.lsp.Config | fun(): (boolean | vim.lsp.Config)

---@alias ne.defs.lang.MasonTool string | { [1]: string, version?: string }

---@class ne.defs.lang.Tools
---@field mason? ne.defs.lang.MasonTool[]
---@field nix? string[]

---@class ne.defs.lang.Treesitter
---@field disable_highlight? string[]
---@field disable_indent? string[]

---@class ne.defs.lang.Completion
---@field sources_by_filetype? table<string, string[]>
---@field providers? table<string, blink.cmp.SourceProviderConfig>

---@class ne.defs.lang.Spec
---@field enabled? boolean
---@field tools? ne.defs.lang.Tools
---@field parsers? string[]
---@field servers? table<string, ne.defs.lang.Server>
---@field tresitter? ne.defs.lang.Treesitter
---@field completion? ne.defs.lang.Completion
---@field plugins? LazySpec

---@class ne.defs.lang
---@overload fun(spec: ne.defs.lang.Spec): LazySpec
local M = {}

---@type table<string, ne.defs.lang.Spec>
local languages = {}

---@param key string
---@param spec ne.defs.lang.Spec
---@return LazySpec
local function define(key, spec)
	languages[key] = spec.enabled ~= false and spec or nil
	return languages[key] and languages[key].plugins or {}
end

---@overload fun(field: 'tools'): ne.defs.lang.Tools
---@overload fun(field: 'parsers'): string[]
---@overload fun(field: 'servers'): table<string, ne.defs.lang.Server>
---@overload fun(field: 'tresitter'): ne.defs.lang.Treesitter
---@overload fun(field: 'completion'): ne.defs.lang.Completion
---@param field string
---@return table
function M.collect(field)
	local result = {}
	local sources = vim.tbl_keys(languages)
	table.sort(sources)
	for _, source in ipairs(sources) do
        local value = languages[source][field]
        if value ~= nil then
            result = util.collection.merge(result, value)
        end
	end
	return result
end

setmetatable(M --[[ @as table ]], {
	---@param spec ne.defs.lang.Spec
	---@return LazySpec
	__call = function(_, spec)
        local key, _ = debug.getinfo(2, 'S').source:gsub('^@', '')
		return define(key, spec)
	end,
})

return M
