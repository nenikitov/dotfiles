return {
    'snacks.nvim',
    opts = {
        picker = {
            sources = {
                files = { hidden = true },
                grep = { hidden = true },
            },
            layouts = {
                default = {
                    layout = {
                        backdrop = false,
                        box = "horizontal",
                        width = 0.8,
                        height = 0.8,
                        {
                            box = "vertical",
                            border = vim.o.winborder or "rounded",
                            title = "{title} {live} {flags}",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list", border = "none" },
                        },
                        {
                            win = "preview",
                            title = "{preview}",
                            border = vim.o.winborder or "rounded",
                            width = 0.5
                        },
                    }
                },
                vertical = {
                    layout = {
                        backdrop = false,
                        width = 0.8,
                        height = 0.8,
                        box = "vertical",
                        border = vim.o.winborder or "rounded",
                        title = "{title} {live} {flags}",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                    },
                },
                vscode = {
                    preview = false,
                    layout = {
                        backdrop = false,
                        width = 0.8,
                        height = 0.8,
                        box = "vertical",
                        border = vim.o.winborder or "rounded",
                        title = "{title} {live} {flags}",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                    },
                },
            }
        },
    },
    keys = {
        -- Prefix
        { [[<LEADER>f]], [[<NOP>]], desc = 'find' },
        -- Main
        { [[<LEADER>ff]], function() Snacks.picker.files() end, desc = 'Files' },
        { [[<LEADER>fg]], function() Snacks.picker.grep() end, desc = 'Grep' },
        { [[<LEADER>f:]], function() Snacks.picker.command_history() end, desc = 'Command history' },
        { [[<LEADER>f/]], function() Snacks.picker.search_history() end, desc = 'Search history' },
        { [[<LEADER>fm]], function() Snacks.picker.help() end, desc = 'Help' },
        { [[<LEADER>fM]], function() Snacks.picker.man() end, desc = 'Man' },
        -- Secondary
        { [[<LEADER>fP]], function() Snacks.picker.pickers() end, desc = 'Pickers' },
        { [[<LEADER>fC]], function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
        { [[<LEADER>fH]], function() Snacks.picker.highlights() end, desc = 'Highlight groups' },
        { [[<LEADER>fI]], function() Snacks.picker.icons() end, desc = 'Icons' },
        { [[<LEADER>fL]], function() Snacks.picker.lazy() end, desc = 'Plugin specs' },
        { [[<LEADER>fN]], function() Snacks.picker.notifications() end, desc = 'Notifications' },
    },
}
