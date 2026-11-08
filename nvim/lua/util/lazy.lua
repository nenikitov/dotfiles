local util = require('util')

---@class ne.util.lazy
local M = {}

M.patches_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'patches')
M.plugins_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
M.fingerprint_dir = vim.fs.joinpath(vim.fn.stdpath('state'), 'lazy_patches')

---@class ne.util.lazy.Plugin
---@field name string
---@field dir string
---@field patches string[]

---@param dir string
---@param ... string
---@return boolean ok
---@return string stderr
local function git(dir, ...)
    local result = vim.system({ 'git', '-C', dir, ... }, { text = true }):wait()
    return result.code == 0, vim.trim(result.stderr or '')
end

---@param dir string
---@return string?
local function get_head(dir)
    local content = util.fs.read(vim.fs.joinpath(dir, '.git', 'HEAD'))
    return content and vim.trim(content)
end

---@param name string
---@return string
local function get_plugin_path(name)
    return vim.fs.joinpath(M.plugins_dir, name)
end

---@return table<string, ne.util.lazy.Plugin>
local function get_patches()
    local plugins = {}
    for path, kind in vim.fs.dir(M.patches_dir, { depth = 2 }) do
        local name = kind == 'file' and path:match('^([^/]+)/[^/]+%.patch$')
        if name then
            plugins[name] = plugins[name] or { name = name, dir = get_plugin_path(name), patches = {} }
            table.insert(plugins[name].patches, vim.fs.joinpath(M.patches_dir, path))
        end
    end
    for _, plugin in pairs(plugins) do
        table.sort(plugin.patches)
    end
    return plugins
end

---@param name string
---@return string
local function get_fingerprint_path(name)
    return vim.fs.joinpath(M.fingerprint_dir, name .. '.fingerprint')
end

---@return string[]
local function get_patched_plugins()
    local names = {}
    for file, kind in vim.fs.dir(M.fingerprint_dir) do
        local name = kind == 'file' and file:match('^(.+)%.fingerprint$')
        if name then
            table.insert(names, name)
        end
    end
    return names
end

---@param plugin ne.util.lazy.Plugin
---@return string?
local function generate_fingerprint(plugin)
    local commit = get_head(plugin.dir)
    if not commit then
        return nil
    end
    local parts = { commit }
    for _, patch in ipairs(plugin.patches) do
        table.insert(parts, vim.fs.basename(patch))
        table.insert(parts, util.fs.read(patch) or '')
    end
    return table.concat(parts, '\0')
end

---@param name string
local function revert_plugin(name)
    local dir = get_plugin_path(name)
    if get_head(dir) then
        local ok, err = git(dir, 'reset', '-q', '--hard')
        if not ok then
            util.vim.delayed_notify(
                ('Could not reset %s\n%s'):format(name, err),
                vim.log.levels.WARN
            )
        end
    end
    if vim.uv.fs_stat(get_fingerprint_path(name)) and vim.fn.delete(get_fingerprint_path(name)) ~= 0 then
        util.vim.delayed_notify(
            ('Could not delete the patch state of %s in %s'):format(name, get_fingerprint_path(name)),
            vim.log.levels.WARN
        )
    end
end

---@param plugin ne.util.lazy.Plugin
local function apply_plugin(plugin)
    local current = generate_fingerprint(plugin)
    if not current or util.fs.read(get_fingerprint_path(plugin.name)) == current then
        return
    end

    revert_plugin(plugin.name)
    for _, patch in ipairs(plugin.patches) do
        local ok, err = git(plugin.dir, 'apply', '--index', patch)
        if not ok then
            util.vim.delayed_notify(
                ('Patch %s does not apply to %s, leaving it unpatched\n%s'):format(vim.fs.basename(patch), plugin.name, err),
                vim.log.levels.WARN
            )
            revert_plugin(plugin.name)
            return
        end
    end

    vim.fn.mkdir(M.fingerprint_dir, 'p')
    local file = assert(io.open(get_fingerprint_path(plugin.name), 'w'))
    file:write(current)
    file:close()
end

function M.revert_all()
    for _, name in ipairs(get_patched_plugins()) do
        revert_plugin(name)
    end
end

function M.apply_all()
    local plugins = get_patches()
    for _, name in ipairs(get_patched_plugins()) do
        if not plugins[name] then
            revert_plugin(name)
        end
    end
    for _, plugin in pairs(plugins) do
        apply_plugin(plugin)
    end
end

function M.setup_patches()
    M.apply_all()

    local group = util.vim.augroup('ne.plugin.lazy_nvim.apply_patches')

    local enter, leave = util.async.refcount(M.revert_all, M.apply_all)
    util.vim.autocmd(
        { { 'User', pattern = { 'LazyInstallPre', 'LazyUpdatePre', 'LazySyncPre', 'LazyRestorePre' } } },
        { group = group, callback = enter }
    )
    util.vim.autocmd(
        { { 'User', pattern = { 'LazyInstall', 'LazyUpdate', 'LazySync', 'LazyRestore' } } },
        { group = group, callback = leave }
    )
end

return M
