---@module 'lazy'

---@class LanguageSpec
---@field tools? LanguageHandlerOptsTools
---@field parsers? LanguageHandlerOptsParsers
---@field servers? LanguageHandlerOptsServers
---@field before_lsp? LanguageHandlerOptsBeforeLsp
---@field after_lsp? LanguageHandlerOptsAfterLsp

---@alias LanguageHandler<T> fun(opts: T): LazySpec
---@alias LanguageHandlerOptsTools string[]
---@alias LanguageHandlerOptsParsers string[]
---@alias LanguageHandlerOptsServers {[string]: (boolean | vim.lsp.Config | fun(): boolean | fun(): vim.lsp.Config)}
---@alias LanguageHandlerOptsBeforeLsp LazySpec[]
---@alias LanguageHandlerOptsAfterLsp LazySpec[]

local M = {}

M._handlers = {}

---@overload fun(name: 'tools', config: LanguageHandler<LanguageHandlerOptsTools>)
---@overload fun(name: 'parsers', config: LanguageHandler<LanguageHandlerOptsParsers>)
---@overload fun(name: 'servers', config: LanguageHandler<LanguageHandlerOptsServers>)
---@overload fun(name: 'before_lsp', config: LanguageHandler<LanguageHandlerOptsBeforeLsp>)
---@overload fun(name: 'after_lsp', config: LanguageHandler<LanguageHandlerOptsAfterLsp>)
function M.handler(name, config)
    M._handlers[name] = config
end

---@param spec LanguageSpec
---@return LazySpec[]
function M.language(spec)
    local result = {}
    for name, opts in pairs(spec) do
        if M._handlers[name] then
            local r = M._handlers[name](opts)
            if vim.islist(r) then
                vim.list_extend(result, r)
            else
                table.insert(result, r)
            end
        else
            vim.notify("Unknown language handler " .. name, vim.log.levels.WARN)
        end
    end
    return result
end

return M
