return {
    'snacks.nvim',
    opts = {
        explorer = {},
        picker = {
            sources = {
                explorer = {
                    auto_close = true,
                    hidden = true,
                    ignored = true,
                    layout = {
                        preview = { enabled = true },
                        layout = {
                            backdrop = false,
                            box = 'horizontal',
                            position = 'float',
                            width = 0.8,
                            height = 0.8,
                            {
                                box = "vertical",
                                width = 0.2,
                                min_width = 40,
                                border = vim.o.winborder or "rounded",
                                title = "{title} {live} {flags}",
                                { win = "input", height = 1, border = "bottom" },
                                { win = "list", border = "none" },
                            },
                            {
                                win = "preview",
                                title = "{preview}",
                                border = vim.o.winborder or "rounded",
                            },
                        }
                    },
                },
            }
        }
    },
    keys = {
        -- Prefix
        { [[<LEADER>e]], [[<NOP>]], desc = 'file explorer' },
        -- Tree
        { [[<LEADER>et]], function() Snacks.explorer() end, desc = 'Tree file explorer' },
    }
}
