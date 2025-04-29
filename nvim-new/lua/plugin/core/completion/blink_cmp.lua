return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    event = 'VeryLazy',
    version = '1.*',
    opts = {
        keymap = {
            preset = 'none',
            ['<C-y>'] = { function(cmp) cmp.scroll_documentation_up(1) end },
            ['<C-e>'] = { function(cmp) cmp.scroll_documentation_down(1) end },
            ['<C-j>'] = { 'select_next', 'fallback' },
            ['<C-k>'] = { 'select_prev', 'fallback' },
            ['<C-h>'] = { 'hide', 'snippet_backward', 'fallback' },
            ['<C-l>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
            ['<C- >'] = { function(cmp) if cmp.is_menu_visible() then cmp.hide() else cmp.show() end end },
        },
        completion = {
            list = {
                selection = { auto_insert = false, }
            },
            menu = {
                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label", 'label_description' },
                        { "source_name" },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
            },
            ghost_text = {
                enabled = true,
            },
        },
        signature = {
            enabled = true,
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                lsp = { name = '[lsp]' },
                path = { name = '[pth]' },
                snippets = { name = '[snp]' },
                buffer = { name = '[buf]' },
                cmdline = { name = '[cmd]' },
            },
        },
        cmdline = {
            keymap = { preset = 'inherit' },
        },
    },
}
