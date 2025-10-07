local shared_plugin = require("util.shared_plugin")
local icon = require("util.icon")

shared_plugin.set_template("tools", function(spec)
    return {
        "mason-tool-installer.nvim",
        opts = { ensure_installed = spec },
    }
end)

return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        opts = {
            -- Extended by specs in `language`
            ensure_installed = {},
        },
        opts_extend = { "ensure_installed" },
        config = function(spec, opts)
            require("mason-tool-installer").setup(opts)

            -- HACK: to `run_on_start`, the plugin sets up an auto command on `VimEnter`
            -- Which won't work if plugin is lazy loaded
            -- [Issue](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39)
            if spec.lazy and opts.run_on_start ~= false then
                require("mason-tool-installer").run_on_start()
            end
        end,
        event = "VeryLazy",
    },
    {
        "mason-org/mason.nvim",
        opts = {
            PATH = "append",
            backdrop = 100,
            width = 0.8,
            height = 0.8,
            ui = {
                icons = {
                    package_installed = icon.plugin.loaded,
                    package_pending = icon.plugin.task,
                    package_uninstalled = icon.plugin.not_loaded,
                },
                keymaps = {
                    toggle_help = "?",
                    toggle_package_expand = "<CR>",
                    oggle_package_install_log = "<CR>",
                    install_package = "i",
                    check_package_version = "c",
                    check_outdated_packages = "C",
                    update_package = "u",
                    update_all_packages = "U",
                    uninstall_package = "d",
                    cancel_installation = "<C-c>",
                    apply_language_filter = "f",
                },
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)

            -- NOTE: `LazyVim` does this to possibly load newly installed packages after install
            require("mason-registry"):on("package:install:success", function()
                vim.defer_fn(function()
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
        end,
        keys = {
            { "<LEADER>p", "<NOP>", desc = "plugin" },
            { "<LEADER>pt", "<CMD>Mason<CR>", desc = "Open tool manager (mason)" },
        },
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    },
}
