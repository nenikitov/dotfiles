local icon = require('util.icon')

return {
    {
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
                    apply_language_filter = 'f',
                    toggle_help = '?',
                }
            },
        },
        cmd = {'Mason', 'MasonInstall', 'MasonUpdate'},
        keys = {
            -- Prefix
            { '<LEADER>p', '<NOP>', desc = 'plugin' },
            -- Maps
            { '<LEADER>pt', '<CMD>Mason<CR>', desc = 'Tool (LSP, linter, formatter) manager' },
        },
        config = function(_, opts)
            require('mason').setup(opts)

            -- Possibly load newly installed packages
            require('mason-registry'):on('package:install:success', function ()
                vim.defer_fn(function ()
                    require('lazy.core.handler.event').trigger({
                        event = 'FileType',
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
        end
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
            'mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        opts = {
            -- Is extended by specs in `language`
            ensure_installed = {}
        },
        config = function(spec, opts)
            require('mason-tool-installer').setup(opts)
            -- HACK: to `run_on_start`, the plugin sets up an auto command on `VimEnter`
            -- That won't work if we are lazy loading it
            if spec.lazy and opts.run_on_start ~= false then
                require('mason-tool-installer').run_on_start()
            end
        end,
        opts_extend = { 'ensure_installed' },
    },
}
