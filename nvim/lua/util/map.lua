local opts_default = {
	noremap = true,
	silent = true,
}

---@alias ne.util.map.Mode
---| '' Normal, Visual, Select, Operator-pending
---| 'n' Normal
---| 'v' Visual and Select
---| 's' Select
---| 'x' Visual
---| 'o' Operator-pending
---| '!' Insert, Command-line
---| 'i' Insert
---| 'l' Insert, Command-line, Lang
---| 'c' Command-line
---| 't' Terminal

---@alias ne.util.map.Rhs
---| string
---| function

---@class ne.util.map.Binding
---@field private _modes ne.util.map.Mode | ne.util.map.Mode[]
---@field private _rhs ne.util.map.Rhs
---@field private _opts vim.keymap.set.Opts
---@field private _node ne.util.map.Node
local Binding = {}
Binding.__index = Binding

---@package
---@param modes ne.util.map.Mode | ne.util.map.Mode[]
---@param rhs ne.util.map.Rhs
---@param opts vim.keymap.set.Opts
---@param node ne.util.map.Node
---@return ne.util.map.Binding
function Binding.new(modes, rhs, opts, node)
	return setmetatable({ _modes = modes, _rhs = rhs, _opts = opts, _node = node}, Binding)
end

---@package
function Binding:label_groups()
	local parent = self._node._parent
	while parent and parent._parent do
		vim.keymap.set(self._modes, parent._lhs, '<NOP>', { buffer = self._opts.buf, desc = parent._desc })
		parent = parent._parent
	end
end

function Binding:set()
	self:label_groups()

    ---@type vim.keymap.set.Opts
    local opts = vim.tbl_extend('force', self._opts, { buffer = self._node._buffer, desc = self._node._desc })

	vim.keymap.set(self._modes, self._node._lhs, self._rhs, opts)
end

---@return LazyKeysSpec
function Binding:spec()
	self:label_groups()

    ---@type vim.keymap.set.Opts
    local opts = vim.tbl_extend('force', self._opts, { desc = self._node._desc })
    opts.buf = nil

	---@type LazyKeysSpec
	local spec = vim.tbl_extend('force', opts, { self._node._lhs, self._rhs, mode = self._modes })

	return spec
end

---@class ne.util.map.Node
---@field package _lhs string
---@field package _desc string
---@field package _parent? ne.util.map.Node
---@field package _buffer? integer
local Node = {}
Node.__index = Node

---@package
---@param lhs string
---@param desc string
---@param parent? ne.util.map.Node
---@param buffer? integer
---@return ne.util.map.Node
function Node.new(lhs, desc, parent, buffer)
	return setmetatable({ _lhs = lhs, _desc = desc, _parent = parent, _buffer = buffer }, Node)
end

---@param keys string
---@param desc string
---@return ne.util.map.Node
function Node:k(keys, desc)
	return Node.new(self._lhs .. keys, desc, self, self._buffer)
end

---@param buf? integer
---@return ne.util.map.Node
function Node:buf(buf)
	return Node.new(self._lhs, self._desc, self._parent, buf or 0)
end

---@param modes ne.util.map.Mode | ne.util.map.Mode[]
---@param rhs ne.util.map.Rhs
---@param opts? vim.keymap.set.Opts
---@return ne.util.map.Binding
function Node:bind(modes, rhs, opts)
    ---@type vim.keymap.set.Opts
	local merged = vim.tbl_extend('force', opts_default, opts or {})
    return Binding.new(modes, rhs, merged, self)
end

---@type ne.util.map.Node
local M = Node.new('', '')
return M
