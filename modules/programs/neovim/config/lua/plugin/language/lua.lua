local shared_plugin = require("util.shared_plugin")

return {
    shared_plugin.template("tools", { "lua_ls" }),
    shared_plugin.template("servers", {
        lua_ls = {
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = "Literal",
                        semicolon = "Disable",
                        arrayIndex = "Auto",
                    },
                    codeLens = { enable = true },
                    doc = { privateName = { "^_" } },
                    completion = { callSnippet = "Replace" },
                    type = { checkTableShape = true },
                },
            },
        },
    }),
    {
        "folke/lazydev.nvim",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
        ft = "lua",
    },
}
