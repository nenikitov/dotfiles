---@module 'heirline'

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

---@param hl string | table | fun(self: StatusLine): (string | table)
---@param ... ne.plugin.heirline.basic.Component
---@return ne.plugin.heirline.basic.Component
function M.background(hl, ...)
	return { hl = hl, ... }
end

---@param sep nil | '' | string | ne.plugin.heirline.basic.Component `''` and `nil` get optimized
---@param ... ne.plugin.heirline.basic.Component
---@return ne.plugin.heirline.basic.Component
function M.joined(sep, ...)
	local children = { ... }

	---@param child ne.plugin.heirline.basic.Component
	---@param self StatusLine
	local function shown(self, child)
		return not child.condition or child.condition(self)
	end

	---@param self StatusLine
	---@param from integer
	---@param to integer
	local function any_shown(self, from, to)
		for i = from, to do
			if shown(self, children[i]) then
				return true
			end
		end
		return false
	end

	---@type ne.plugin.heirline.basic.Component
	local component = {
		condition = function(self)
			return any_shown(self, 1, #children)
		end,
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
			condition = function(self)
				return shown(self, children[i]) and any_shown(self, 1, i - 1)
			end,
			sep,
		})
		table.insert(component, children[i])
	end

	return component
end

return M
