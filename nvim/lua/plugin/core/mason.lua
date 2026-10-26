---@module 'lazy'
---@module 'mason'

local util = require('util')
local defs = require('defs')

---@class ne.plugin.mason.Lock
---@field version string

---@type ne.util.lockfile
local lock = util.lockfile.new(vim.fs.joinpath(vim.fn.stdpath('config'), 'mason-lock.json'))


---@type LazySpec
return {
    defs.plugins.mason,
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUpdate', 'MasonLog' },
    keys = {
        defs.keys.plugin:k('m', 'Mason'):bind('n', '<CMD>Mason<CR>'):spec(),
    },
    ---@type MasonSettings
    opts = {
        PATH = 'append',
        ui = {
            backdrop = 100,
            width = 0.8,
            height = 0.8,
            icons = {
                package_installed = defs.icons.plugin.status.loaded,
                package_pending = vim.trim(defs.icons.plugin.status.working),
                package_uninstalled = defs.icons.plugin.status.not_loaded,
            },
            keymaps = {
                apply_language_filter = 'f',
                uninstall_package = 'x',
                toggle_help = '?',
            }
        },
    },
    config = function(_, opts)
        require('mason').setup(opts)
        local registry = require('mason-registry')

        -- Lockfile
		registry:on('package:install:success', vim.schedule_wrap(function(package)
			lock:set(package.name, { version = package:get_installed_version() })
		end))
		registry:on('package:install:failed', vim.schedule_wrap(function(package)
			vim.notify(('Failed to install %s, see :MasonLog'):format(package.name), vim.log.levels.ERROR)
		end))
		registry:on('package:uninstall:success', vim.schedule_wrap(function(package)
			lock:set(package.name, nil)
		end))

        -- Retrigger filetypes
		registry:on('package:install:success', vim.schedule_wrap(function(_)
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local filetype = vim.bo[buf].filetype
                if vim.api.nvim_buf_is_loaded(buf) and filetype ~= '' then
                    vim.api.nvim_buf_call(buf, function()
                        vim.cmd.doautocmd({ args = { 'FileType', filetype } })
                    end)
                end
            end
		end))

        -- Install packages

        ---@param tool ne.defs.lang.MasonTool
        ---@return string name
        ---@return string? version
        local function parse(tool)
            if type(tool) == 'string' then
                return tool, nil
            else
                return tool[1], tool.version
            end
        end
        registry.refresh(function()
            for _, tool in ipairs(defs.lang.collect('tools').mason or {}) do
                local name, pinned = parse(tool)
                local found, package = pcall(registry.get_package, name)

                if not found then
                    vim.notify('Unknown mason package ' .. name .. ', skipping installation', vim.log.levels.WARN)
                elseif pinned and pinned ~= package:get_installed_version() then
                    package:install({ version = pinned })
                elseif not pinned and not package:is_installed() then
                    local entry = lock:get(name)
                    package:install({ version = entry and entry.version })
                end
            end
        end)
    end
}
