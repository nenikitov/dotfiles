---@module 'lazy'

local M = {}

---@alias shared_plugin.Template.Tools 'tools'
---@alias shared_plugin.Template.Servers 'servers'

---@alias shared_plugin.TemplateArgs.Tools string[]
---@alias shared_plugin.TemplateArgs.Servers { [string]: (boolean | vim.lsp.Config | fun(): (boolean | vim.lsp.Config)) }

---@alias shared_plugin.Template
---| shared_plugin.Template.Tools
---| shared_plugin.Template.Servers
---@alias shared_plugin.TemplateArgs
---| shared_plugin.TemplateArgs.Tools
---| shared_plugin.TemplateArgs.Servers

---@type table<shared_plugin.Template, fun(spec: shared_plugin.TemplateArgs): LazySpec>
local templates = {}

---@overload fun(kind: shared_plugin.Template.Tools, spec: shared_plugin.TemplateArgs.Tools): LazySpec
---@overload fun(kind: shared_plugin.Template.Servers, spec: shared_plugin.TemplateArgs.Servers): LazySpec
function M.template(kind, spec)
    if not templates[kind] then
        error("Unregistered template " .. kind)
    end
    return templates[kind](spec)
end

---@overload fun(kind: shared_plugin.Template.Tools, handler: fun(spec: shared_plugin.TemplateArgs.Tools): LazySpec)
---@overload fun(kind: shared_plugin.Template.Servers, handler: fun(spec: shared_plugin.TemplateArgs.Servers): LazySpec)
function M.set_template(kind, handler)
    templates[kind] = handler
end

return M
