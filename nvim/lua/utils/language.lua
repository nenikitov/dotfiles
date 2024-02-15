local M = {}

---@alias LanguageParsers string[]
---@alias LanguageTools string[]
---@alias LanguageServers {[string]: (table | fun(): table)}
---@alias LanguageFormatters {[string]: (string | string[])[]}
---@alias LanguageLinters {[string]: string[]}
---@alias LanguagePlugins LazySpec

---@class LanguageSpec
---@field parsers LanguageParsers | nil Names of TreeSitter parsers (see `TSInstall`) to install.
---@field tools LanguageTools | nil Names of tools (see`:MasonInstall` or `lspconfig`) to install.
---@field servers LanguageServers | nil Configuration for LSP servers, key is server name, value is server config.
---@field linters LanguageLinters | nil Configuration for linters, key is filetype name, value is linters.
---@field formatters LanguageServers | nil Configuration for formatters, key is filetype name, value is formatters.
---@field plugins { before_core: LanguagePlugins | nil, after_core: LanguagePlugins | nil } | nil Configuration for formatters, key is filetype name, value is formatters.

---@type LanguageParsers
local parsers = {}
function M.parsers()
    return parsers
end

---@type LanguageTools
local tools = {}
function M.tools()
    return tools
end

---@type LanguageServers
local servers = {}
function M.servers()
    return servers
end

---@type LanguageFormatters
local formatters = {}
function M.formatters()
    return formatters
end

---@type LanguageLinters
local linters = {}
function M.linters()
    return linters
end

---@type LanguagePlugins[]
local plugins_before_core = {}
function M.plugins_before_core()
    return plugins_before_core
end

local CORE_DEPENDENCIES = {
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
}

---@param spec LanguagePlugins | LanguagePlugins[]
---@return LanguagePlugins
local function add_core_dependency(spec)
    if type(spec) == 'string' then
        -- Just a string
        return {
            spec,
            dependencies = CORE_DEPENDENCIES,
        }
    elseif not vim.tbl_islist(spec) then
        -- Singular plugin spec
        if spec.dependencies == nil then
            -- Without dependencies
            spec.dependencies = CORE_DEPENDENCIES
        else
            -- With dependencies
            if type(spec.dependencies) == 'string' then
                spec.dependencies = {
                    spec.dependencies,
                    unpack(CORE_DEPENDENCIES),
                }
            else
                ---@diagnostic disable-next-line: param-type-mismatch `spec.dependencies` isn't a string, so it's a table
                vim.list_extend(spec.dependencies, CORE_DEPENDENCIES)
            end
        end

        return spec
    else
        -- Multiple specs
        return vim.tbl_map(add_core_dependency, spec)
    end
end

---@param language LanguageSpec
function M.register(language)
    if language.parsers ~= nil then
        vim.list_extend(parsers, language.parsers)
    end
    if language.tools ~= nil then
        vim.list_extend(tools, language.tools)
    end
    if language.servers ~= nil then
        local s = vim.tbl_deep_extend('force', servers, language.servers)
        ---@cast s -nil
        servers = s
    end
    if language.linters ~= nil then
        local l = vim.tbl_deep_extend('force', linters, language.linters)
        ---@cast l -nil
        linters = l
    end
    if language.formatters ~= nil then
        local f = vim.tbl_deep_extend('force', formatters, language.formatters)
        ---@cast f -nil
        formatters = f
    end
    if language.plugins ~= nil and language.plugins.before_core ~= nil then
        table.insert(plugins_before_core, language.plugins.before_core)
    end

    if language.plugins ~= nil and language.plugins.after_core ~= nil then
        return add_core_dependency(language.plugins.after_core)
    else
        return {}
    end
end

return M
