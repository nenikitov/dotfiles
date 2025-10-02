local shared_plugin = require("util.shared_plugin")

shared_plugin.set_name("tool_installer", "mason-tool-installer.nvim")
shared_plugin.set_template("tools", function(spec)
    return {
        shared_plugin.name("tool_installer"),
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
            { "<LEADER>pt", "<CMD>Mason<CR>", desc = "Tool (LSP, linter, formatter) manager" },
        },
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    },
}
