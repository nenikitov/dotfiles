return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
        keymap = {
            preset = "none",
            ["<C-y>"] = {
                function(cmp)
                    return cmp.scroll_documentation_up(1)
                end,
                "fallback",
            },
            ["<C-e>"] = {
                function(cmp)
                    return cmp.scroll_documentation_down(1)
                end,
                "fallback",
            },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-h>"] = { "hide", "snippet_backward", "fallback" },
            ["<C-l>"] = { "select_and_accept", "snippet_forward", "fallback" },
            ["<C- >"] = {
                function(cmp)
                    if cmp.is_menu_visible() then
                        cmp.hide()
                    else
                        cmp.show()
                    end
                end,
            },
        },
        completion = {
            list = { selection = { auto_insert = false } },
            menu = {
                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description" },
                        { "source_name" },
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                return ({ require("mini.icons").get("lsp", ctx.kind) })[1]
                            end,
                            highlight = function(ctx)
                                return ({ require("mini.icons").get("lsp", ctx.kind) })[2]
                            end,
                        },
                        kind = {
                            highlight = function(ctx)
                                return ({ require("mini.icons").get("lsp", ctx.kind) })[2]
                            end,
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
            },
        },
        signature = { enabled = true },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            providers = {
                lsp = { name = "[lsp]" },
                path = { name = "[pth]" },
                snippets = { name = "[snp]" },
                buffer = { name = "[buf]" },
                cmdline = { name = "[cmd]" },
            },
        },
        cmdline = {
            keymap = { preset = "inherit" },
            completion = { menu = { auto_show = true } },
        },
    },
    opts_extend = { "sources.default" },
    event = "VeryLazy",
}
