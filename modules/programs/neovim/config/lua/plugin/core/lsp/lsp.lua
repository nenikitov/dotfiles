local shared_plugin = require("util.shared_plugin")

shared_plugin.set_template("servers", function(spec)
    return {
        "nvim-lspconfig",
        opts = { servers = spec },
    }
end)

return {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-tool-installer.nvim" },
    opts = {
        -- Extended by specs in `language`
        servers = {},
    },
    config = function(_, opts)
        for server, config in pairs(opts.servers) do
            if type(config) == "function" then
                config = config()
            end
            if config == false then
                goto continue
            end
            if config == true then
                config = {}
            end

            vim.lsp.enable(server)
            vim.lsp.config(server, config)

            ::continue::
        end
    end,
    -- TODO: Set up LSP keybinds
    keys = {},
    event = "LazyFile",
}
