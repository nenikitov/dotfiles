local icon = require("util.icon")

return {
    "luukvbaal/statuscol.nvim",
    opts = function()
        local statuscol = require("statuscol.builtin")

        return {
            segments = {
                -- Git diff
                {
                    sign = {
                        namespace = { "gitsigns" },
                        colwidth = 1,
                        maxwidth = 1,
                        foldclosed = true,
                    },
                    click = "v:lua.ScSa",
                },
                -- Diagnostics
                {
                    sign = {
                        namespace = { "diagnostic", "diagnostic/signs" },
                        maxwidth = 1,
                        foldclosed = true,
                    },
                    click = "v:lua.ScSa",
                },
                -- Other signs
                {
                    sign = { name = { ".*" }, text = { ".*" }, auto = true, foldclosed = true },
                    click = "v:lua.ScSa",
                },
                -- Line numbers
                {
                    text = { statuscol.lnumfunc, " " },
                    condition = { true, statuscol.not_empty },
                    click = "v:lua.ScLa",
                },
                -- Folds
                {
                    text = { statuscol.foldfunc, " " },
                    click = "v:lua.ScFa",
                },
            },
        }
    end,
    event = "VeryLazy",
}
