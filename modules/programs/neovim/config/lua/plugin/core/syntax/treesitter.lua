local shared_plugin = require("util.shared_plugin")

shared_plugin.set_template("parsers", function(spec)
    return {
        "nvim-treesitter",
        opts = { ensure_installed = spec },
    }
end)

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        opts = {
            treesitter = {},
            -- Extended by specs in `language`
            ensure_installed = {
                -- Recommended to always be installed
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                -- My own recommendations
                "diff",
                "regex",
                "comment",
            },
            -- TODO: Folds too
            -- TODO: Make exclusions accessible
            highlight = { enable = true, exclude = {} },
            indent = { enable = true, exclude = {} },
        },
        opts_extend = { "ensure_installed", "highlight.exclude", "indent.exclude" },
        config = function(_, opts)
            local treesitter = require("nvim-treesitter")

            treesitter.setup(opts.treesitter)

            local installed = treesitter.get_installed()
            local to_install = vim.iter(opts.ensure_installed)
                :filter(function(p)
                    return not vim.tbl_contains(installed, p)
                end)
                :totable()
            if #to_install > 0 then
                treesitter
                    .install(to_install)
                    -- NOTE: NvChad does this to possibly load newly installed parsers after install
                    :await(
                        function(err)
                            if err then
                                vim.notify("Failed to install TreeSitter parsers " .. err, vim.log.levels.WARN)
                                return
                            end

                            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                pcall(vim.treesitter.start, buf)
                            end
                        end
                    )
            end

            local group = vim.api.nvim_create_augroup("treesitter", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                callback = function(event)
                    -- Highlight (if supports)
                    if
                        opts.highlight.enable
                        and not vim.tbl_contains(opts.highlight.exclude, event.match)
                        and vim.treesitter.query.get(event.match, "highlights")
                    then
                        vim.treesitter.start()
                    end

                    -- Indent (if supports)
                    if
                        opts.indent.enable
                        and not vim.tbl_contains(opts.indent.exclude, event.match)
                        and vim.treesitter.query.get(event.match, "indents")
                    then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
        build = ":TSUpdate",
        event = "VeryLazy",
    },
}
