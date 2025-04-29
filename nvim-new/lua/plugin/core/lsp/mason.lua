local icon = require('util.icon')

return {
    'williamboman/mason.nvim',
    opts = {
        -- Prioritize system-installed packages
        PATH = 'append',
        ui = {
            border = vim.o.winborder,
            backdrop = 100,
            width = 0.8,
            height = 0.8,
            icons = {
                package_installed = icon.plugin_state.loaded,
                package_pending = icon.plugin_state.start,
                package_uninstalled = icon.plugin_state.not_loaded,
            },
            keymaps = {
                toggle_package_expand = 'l',
                toggle_package_install_log = 'l',
                uninstall_package = 'd',
                apply_language_filter = '/',
                toggle_help = '?',
            }
        },
    },
    build = ':MasonUpdate',
    opts_extend = { 'ensure_installed' },
    cmd = {'Mason', 'MasonInstall', 'MasonUpdate'},
    keys = {
        -- Prefix
        { '<LEADER>p', '<NOP>', desc = 'plugin' },
        -- Maps
        { '<LEADER>pt', '<CMD>Mason<CR>', desc = 'Tool (LSP, linter, formatter) manager' },
    },
    config = function(_, opts)
        require('mason').setup(opts)

        local registry = require('mason-registry')

        -- Possibly load newly installed packages
        registry:on('package:install:success', function ()
            vim.defer_fn(function ()
                require('lazy.core.handler.event').trigger({
                    event = 'FileType',
                    buf = vim.api.nvim_get_current_buf(),
                })
            end, 100)
        end)

        -- Install packages
        registry.refresh(function()
            for _, name in pairs(opts.ensure_installed or {}) do
                local pkg = registry.get_package(name)
                if not pkg:is_installed() then
                    pkg:install()
                end
            end
        end)
    end
}
