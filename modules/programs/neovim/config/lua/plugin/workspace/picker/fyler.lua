local icon = require("util.icon")

return {
    --"A7Lavinraj/fyler.nvim",
    dir = "~/Documents/fyler.nvim",
    dependencies = { "mini.icons" },
    branch = "stable",
    opts = {
        default_explorer = true,
        git_status = {
            symbols = {
                Untracked = icon.version_control.untracked,
                Added = icon.version_control.added,
                Modified = icon.version_control.modified,
                Deleted = icon.version_control.deleted,
                Renamed = icon.version_control.renamed,
                Copied = icon.version_control.copied,
                Conflict = icon.version_control.conflict,
                Ignored = icon.version_control.ignored,
            },
        },
        indentscope = {
            marker = icon.ui.indent,
        },
        win = {
            kind = "float",
            kind_presets = {
                float = {
                    height = "0.8rel",
                    width = "0.8rel",
                    top = "none",
                    left = "none",
                },
            },
            win_opts = {
                numberwidth = vim.opt.numberwidth:get(),
            },
        },
    },
    keys = {
        {
            "<LEADER>t",
            function()
                return require("fyler").toggle()
            end,
            desc = "Open file explorer",
        },
    },
    cmd = { "Fyler" },
}
