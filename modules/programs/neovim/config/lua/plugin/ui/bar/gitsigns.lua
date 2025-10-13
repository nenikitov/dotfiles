local icon = require("util.icon")
local map = require("util.map")

return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = { text = icon.diff_bar.added },
            change = { text = icon.diff_bar.modified },
            delete = { text = icon.diff_bar.deleted },
            topdelete = { text = icon.diff_bar.deleted },
            changedelete = { text = icon.diff_bar.deleted },
            untracked = { text = icon.diff_bar.untracked },
        },
        signs_staged = {
            add = { text = icon.diff_bar.added },
            change = { text = icon.diff_bar.modified },
            delete = { text = icon.diff_bar.deleted },
            topdelete = { text = icon.diff_bar.deleted },
            changedelete = { text = icon.diff_bar.deleted },
            untracked = { text = icon.diff_bar.untracked },
        },
        attach_to_untracked = true,
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")
            local opts = { buffer = bufnr }

            map.map("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, "Next hunk", opts)

            map.map("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, "Previous hunk", opts)

            map.map("", "<LEADER>g", "<NOP>", "git", opts)

            map.map({ "n", "v" }, "<LEADER>gs", gitsigns.stage_hunk, "Stage current hunk", opts)
            map.map({ "n", "v" }, "<LEADER>gr", gitsigns.reset_hunk, "Reset current hunk", opts)
            map.map("", "<LEADER>gS", gitsigns.stage_buffer, "Stage current buffer", opts)
            map.map("", "<LEADER>gR", gitsigns.reset_buffer, "Reset current buffer", opts)

            map.map(
                "n",
                "<LEADER>gb",
                map.bind(gitsigns.blame_line, { full = true }),
                "Get author and revision of the current line",
                opts
            )
        end,
    },
    event = "VeryLazy",
}
