local M = {}

---@type string[]
local mason = {}

---@param tools string[]
function M.mason(tools)
    vim.list_extend(mason, tools)
end

function M.get_mason()
    return mason
end

---@type string[]
local treesitter_parsers = {}

---@param parsers string[]
function M.treesitter(parsers)
    vim.list_extend(treesitter_parsers, parsers)
end

function M.get_treesitter()
    return treesitter_parsers
end

---@alias ServerConfig { [string]: (table | fun(): table) }
---@type ServerConfig
local servers = {}

---@param config ServerConfig
function M.servers(config)
    local s = vim.tbl_deep_extend('force', servers, config)
    ---@cast s -nil
    servers = s
end

function M.get_servers()
    return servers
end

---@alias Linters {[string]: string[]}
---@type Linters
local linters = {}

---@param config Linters
function M.linters(config)
    local l = vim.tbl_deep_extend('force', linters, config)
    ---@cast l -nil
    linters = l
end

function M.get_linters()
    return linters
end

---@alias Formatters {[string]: (string | string[])[]}
---@type Formatters
local formatters = {}

---@param config Linters
function M.formatters(config)
    local f = vim.tbl_deep_extend('force', formatters, config)
    ---@cast f -nil
    formatters = f
end

function M.get_formatters()
    return formatters
end

local before_lsp = {}

---@param spec LazySpec
function M.before_lsp(spec)
    table.insert(before_lsp, spec)
end

function M.get_before_lsp()
    return before_lsp
end

return M
