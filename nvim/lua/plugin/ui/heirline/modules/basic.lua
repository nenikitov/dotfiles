---@module 'heirline'

local util = require('util')

local M = {}

--#region Utils

---@param icon string
---@return string
function M.icon(icon)
    return vim.trim(icon)
end

---@param self { bufnr?: integer }
---@return integer
function M.bufnr(self)
    return self.bufnr or vim.api.nvim_get_current_buf()
end

---@return integer
function M.statusline_width()
    if vim.o.laststatus == 3 then
        return vim.o.columns
    end
    return vim.api.nvim_win_get_width(0)
end

---@param component ne.plugin.heirline.modules.basic.Component
---@return fun(self: ne.plugin.heirline.modules.basic.Component): boolean
function M.visibility(component)
	local condition = component.condition
	return function(self)
		return not condition or (not not condition(self))
	end
end

--#endregion

--#region Components

---@class ne.plugin.heirline.modules.basic.Component : StatusLine
---@field init? fun(self: StatusLine): any
---@field condition? fun(self: ne.plugin.heirline.modules.basic.Component): any
---@field provider? string|number|fun(self: StatusLine):string|number|nil
---@field hl? HeirlineHighlight|string|fun(self: StatusLine): HeirlineHighlight|string|nil
---@field fallthrough? boolean
---@field flexible? integer
---
---@field after? fun(self: StatusLine): any
---@field id? integer[]
---@field on_click? HeirlineOnClickCallback|HeirlineOnClick
---@field pick_child? integer[]
---@field restrict? table<string, boolean>
---@field update? table|string|fun(self: StatusLine): boolean
---@field winnr? integer
---@field _au_id? integer
---@field _flexible_components? table
---@field _tree? table
---@field _updatable_components? table
---@field _win_cache? table

---@generic T : ne.plugin.heirline.modules.basic.Component
---@param init fun(self: T)
---@param static? table<string, any>
---@return fun(child: ne.plugin.heirline.modules.basic.Component): T
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

---@param sep nil | '' | string | ne.plugin.heirline.modules.basic.Component `''` and `nil` get optimized
---@param ... ne.plugin.heirline.modules.basic.Component
---@return ne.plugin.heirline.modules.basic.Component
function M.joined(sep, ...)
	local children = { ... }

    ---@type (fun(self: ne.plugin.heirline.basic.Component): boolean)[]
	local shown = vim.tbl_map(M.visibility, children)

	---@type ne.plugin.heirline.modules.basic.Component
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

---@class ne.plugin.heirline.modules.basic.ByWidthStep
---@field [1] ne.plugin.heirline.modules.basic.Component
---@field min integer

---@param steps (ne.plugin.heirline.modules.basic.Component | ne.plugin.heirline.modules.basic.ByWidthStep)[]
---@param width? fun(self: StatusLine): integer
---@return ne.plugin.heirline.modules.basic.Component
function M.by_width(steps, width)
    width = width or M.statusline_width

    ---@type ne.plugin.heirline.modules.basic.ByWidthStep[]
    local normalized = {}
    for _, step in ipairs(steps) do
        if step.min then
            ---@cast step ne.plugin.heirline.modules.basic.ByWidthStep
            table.insert(normalized, step)
        else
            ---@cast step ne.plugin.heirline.modules.basic.Component
            table.insert(normalized, { min = 0, step })
        end
    end

    ---@param self StatusLine
    ---@param step ne.plugin.heirline.modules.basic.ByWidthStep
    ---@return boolean
    local function fits(self, step)
        return width(self) >= step.min
    end

    ---@type ne.plugin.heirline.modules.basic.Component
    local component = {
        fallthrough = false,
        condition = function(self)
            for _, step in ipairs(normalized) do
                if fits(self, step) then
                    return M.visibility(step[1])(self)
                end
            end
            return false
        end,
    }

    for _, step in ipairs(normalized) do
        table.insert(component, {
            condition = function(self)
                return fits(self, step)
            end,
            step[1],
        })
    end

    return component
end

--#endregion

return M
