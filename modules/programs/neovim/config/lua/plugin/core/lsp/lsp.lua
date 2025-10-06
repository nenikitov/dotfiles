-- HACK: Make sure `tool_installer` is defined
require("plugin.core.lsp.mason")

local shared_plugin = require("util.shared_plugin")

shared_plugin.set_name("lsp", "nvim-lspconfig")
shared_plugin.set_template("servers", function(spec)
    return {
        shared_plugin.name("lsp"),
        opts = { servers = spec },
    }
end)

return {
    "neovim/nvim-lspconfig",
    dependencies = { shared_plugin.name("tool_installer") },
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
    keys = {},
    event = "LazyFile",
}
