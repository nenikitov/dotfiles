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
---@field private _lhs string
---@field private _modes ne.util.map.Mode | ne.util.map.Mode[]
---@field private _rhs ne.util.map.Rhs
---@field private _opts vim.keymap.set.Opts
---@field private _prefix? ne.util.map.Node
local Binding = {}
Binding.__index = Binding

---@package
---@param lhs string
---@param modes ne.util.map.Mode | ne.util.map.Mode[]
---@param rhs ne.util.map.Rhs
---@param opts vim.keymap.set.Opts
---@param prefix? ne.util.map.Node
---@return ne.util.map.Binding
function Binding.new(lhs, modes, rhs, opts, prefix)
	return setmetatable({ _lhs = lhs, _modes = modes, _rhs = rhs, _opts = opts, _prefix = prefix }, Binding)
end

---@package
function Binding:label_groups()
	local node = self._prefix
	while node and node._parent do
		vim.keymap.set(self._modes, node._lhs, '<NOP>', { buffer = self._opts.buffer, desc = node._desc })
		node = node._parent
	end
end

function Binding:set()
	self:label_groups()
	vim.keymap.set(self._modes, self._lhs, self._rhs, self._opts)
end

---@return LazyKeysSpec
function Binding:spec()
	self:label_groups()
	---@type LazyKeysSpec
	local spec = vim.tbl_extend('force', self._opts, { self._lhs, self._rhs, mode = self._modes })
	spec.buffer = nil
	return spec
end

---@class ne.util.map.Node
---@field package _lhs string
---@field package _desc string
---@field package _parent? ne.util.map.Node
---@field private _buffer? integer
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
	local merged = vim.tbl_extend('force', opts_default, { buffer = self._buffer }, opts or {}, { desc = self._desc })
	return Binding.new(self._lhs, modes, rhs, merged, self._parent)
end

---@type ne.util.map.Node
local M = Node.new('', '')
return M
