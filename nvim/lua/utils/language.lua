local M = {}

---@param tools string[]
---@return LazySpec
function M.mason(tools)
    return {
        'williamboman/mason.nvim',
        ---@param opts {ensure_installed: string[]}
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, tools)
        end,
    }
end

---@param languages string[]
---@return LazySpec
function M.treesitter(languages)
    return {
        'nvim-treesitter/nvim-treesitter',
        ---@param opts {ensure_installed: string[]}
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, languages)
        end,
    }
end

---@param servers { [string]:table | fun(): table }
---@return LazySpec
function M.servers(servers)
    return {
        'neovim/nvim-lspconfig',
        opts = {
            servers = servers,
        },
    }
end

---@param linters { [string]: string[] }
---@return LazySpec
function M.linters(linters)
    return {
        dir = '~/SharedFiles/Projects/nvim/nvim-lint/',
        opts = {
            linters_by_ft = linters,
        },
    }
end

---@param formatters { [string]: (string | string[])[] }
---@return LazySpec
function M.formatters(formatters)
    return {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = formatters,
        },
    }
end

return M
