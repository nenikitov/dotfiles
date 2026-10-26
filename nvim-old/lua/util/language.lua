---@module 'lazy'

---@class LanguageSpec
---@field tools? LanguageHandlerOptsTools
---@field parsers? LanguageHandlerOptsParsers
---@field servers? LanguageHandlerOptsServers
---@field plugins? LanguageHandlerOptsPlugins

---@alias LanguageHandler<T> fun(opts: T): LazySpec
---@alias LanguageHandlerOptsTools string[]
---@alias LanguageHandlerOptsParsers string[]
---@alias LanguageHandlerOptsServers {[string]: (boolean | vim.lsp.Config | fun(): boolean | fun(): vim.lsp.Config)}
---@alias LanguageHandlerOptsPlugins LazySpec

local M = {}

M._handlers = {
    plugins = function(spec) return spec end
}

---@overload fun(name: 'tools', config: LanguageHandler<LanguageHandlerOptsTools>)
---@overload fun(name: 'parsers', config: LanguageHandler<LanguageHandlerOptsParsers>)
---@overload fun(name: 'servers', config: LanguageHandler<LanguageHandlerOptsServers>)
---@overload fun(name: 'plugins', config: LanguageHandler<LanguageHandlerOptsPlugins>)
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
            vim.notify("Unknown or unregistered language handler " .. name, vim.log.levels.WARN)
        end
    end
    return result
end

M._lsp_plugin = nil

function M.set_lsp_plugin(name)
    M._lsp_plugin = name
end

---@param spec LazySpec
---@return LazySpec
function M.before_lsp(spec)
    if not M._lsp_plugin then
        vim.notify("Unknown or lsp plugin name")
        return {}
    end

    if type(spec) == 'string' then
        return {
            spec,
            { M._lsp_plugin, dependencies = spec }
        }
    elseif not vim.islist(spec) then
        return {
            spec,
            { M._lsp_plugin, dependencies = spec[1] }
        }
    else
        return
            vim.iter(spec)
                :map(M.before_lsp)
                :totable()
    end
end

---@param spec LazySpec
---@return LazySpec
function M.after_lsp(spec)
    if not M._lsp_plugin then
        vim.notify("Unknown or lsp plugin name")
        return {}
    end

    if type(spec) == 'string' then
        return { spec, dependencies = M._lsp_plugin }
    elseif not vim.islist(spec) then
        return {
            spec,
            {spec[1], dependencies = M._lsp_plugin}
        }
    else
        return
            vim.iter(spec)
                :map(M.after_lsp)
                :totable()
    end
end

return M
