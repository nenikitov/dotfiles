---@class ne.shared.plugins
local M = {}

M.names = {
    blink_cmp = 'saghen/blink.cmp',
    mason = 'mason-org/mason.nvim',
    mini_icons = 'nvim-mini/mini.icons',
    snacks = 'folke/snacks.nvim',
}

---@class ne.shared.plugins.Handler<Arg>
---@field private _name string
---@field private _default fun(arg?: Arg)
---@field private _defined? { source: string, handler: fun(arg?: Arg) }
---@field bind fun(self: ne.shared.plugins.Handler<Arg>, arg?: Arg): fun()
---@field set fun(self: ne.shared.plugins.Handler<Arg>, source: string, handler: fun(arg?: Arg))
local Handler = {}
Handler.__index = Handler

function Handler:bind(arg)
    return function()
        local handler = self._defined and self._defined.handler or self._default
        handler(arg)
    end
end

function Handler:set(source, handler)
    if self._defined then
        vim.notify('Handler ' .. self._name .. ' defined from ' .. self._defined.source .. ' is being redefined by ' .. source, vim.log.levels.WARN)
    end
    self._defined = { source = source, handler = handler }
end

---@package
---@generic Arg
---@param name string
---@param default fun(arg?: Arg)
---@return ne.shared.plugins.Handler<Arg>
function Handler.new(name, default)
    return setmetatable({ _name = name, _default = default }, Handler)
end

---@alias ne.shared.plugins.Direction 'left' | 'down' | 'up' | 'right'

---@type table<ne.shared.plugins.Direction, string>
local window_keys = { left = 'h', down = 'j', up = 'k', right = 'l' }
---@type table<ne.shared.plugins.Direction, string>
local resize_keys = { left = '<', down = '-', up = '+', right = '>' }

M.handlers = {
    ---@param _ nil
    close_buffer = Handler.new('close_buffer', function(_) vim.cmd.bdelete() end),
    ---@param _ nil
    format_buffer = Handler.new('format_buffer', function(_) vim.lsp.buf.format({ async = true }) end),
    ---@param _ nil
    rename_symbol = Handler.new('rename_symbol', function(_) vim.lsp.buf.rename() end),
    ---@param _ nil
    show_references = Handler.new('show_references', function(_) vim.lsp.buf.references() end),
    ---@param _ nil
    show_implementations = Handler.new('show_implementations', function(_) vim.lsp.buf.implementation() end),
    ---@param _ nil
    show_definitions = Handler.new('show_definitions', function(_) vim.lsp.buf.definition() end),
    ---@param _ nil
    show_declarations = Handler.new('show_declarations', function(_) vim.lsp.buf.declaration() end),
    ---@param direction ne.shared.plugins.Direction
    focus_window = Handler.new('focus_window', function(direction) vim.cmd.wincmd(window_keys[direction]) end),
    ---@param direction ne.shared.plugins.Direction
    swap_window = Handler.new('swap_window', function(direction) vim.cmd.wincmd(window_keys[direction]:upper()) end),
    ---@param direction ne.shared.plugins.Direction
    resize_window = Handler.new('resize_window', function(direction) vim.cmd('3wincmd ' .. resize_keys[direction]) end),
}

return M
