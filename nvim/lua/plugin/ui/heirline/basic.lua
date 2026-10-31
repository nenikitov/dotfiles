---@module 'heirline'

local util = require('util')

local M = {}

---@class ne.plugin.heirline.basic.Component : StatusLine
---@field id? integer[]
---@field winnr? integer
---@field fallthrough? boolean
---@field flexible? integer
---@field _tree? table
---@field _updatable_components? table
---@field _flexible_components? table
---@field init? fun(self: StatusLine)
---@field condition? fun(self: StatusLine): boolean?
---@field provider? string | number | fun(self: StatusLine): (string | number)?
---@field hl? string | table | fun(self: StatusLine): (string | table)?

---@generic T : ne.plugin.heirline.basic.Component
---@param init fun(self: T)
---@param static? table<string, any>
---@return fun(child: ne.plugin.heirline.basic.Component): T
function M.context(init, static)
	return function(child)
		local component = {
			condition = child.condition,
			init = init,
			static = static,
			child,
		}
		child.condition = nil
		return component
	end
end

---@param icon string
---@return string
function M.icon(icon)
    return vim.trim(icon)
end

---@param self { bufnr?: integer }
---@return integer
function M.buffer(self)
    return self.bufnr or vim.api.nvim_get_current_buf()
end

---@param component ne.plugin.heirline.basic.Component
---@return fun(self: StatusLine): boolean
function M.visibility(component)
	local condition = component.condition
	return function(self)
		return not condition or (not not condition(self))
	end
end

---@param sep nil | '' | string | ne.plugin.heirline.basic.Component `''` and `nil` get optimized
---@param ... ne.plugin.heirline.basic.Component
---@return ne.plugin.heirline.basic.Component
function M.joined(sep, ...)
	local children = { ... }
	local shown = vim.tbl_map(M.visibility, children)

	---@type ne.plugin.heirline.basic.Component
	local component = {
		condition = util.collection.any_pass(shown),
		children[1],
	}

	if sep == nil or sep == '' then
		for i = 2, #children do
			table.insert(component, children[i])
		end
		return component
	end

	if type(sep) == 'string' then
		sep = { provider = sep }
	end

	for i = 2, #children do
		table.insert(component, {
			condition = util.collection.all_pass({
				shown[i],
				util.collection.any_pass(vim.list_slice(shown, 1, i - 1)),
			}),
			sep,
		})
		table.insert(component, children[i])
	end

	return component
end

return M
