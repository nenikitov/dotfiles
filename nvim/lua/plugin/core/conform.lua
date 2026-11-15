---@module 'lazy'
---@module 'conform'

local shared = require('shared')

---@type LazySpec
return {
    'stevearc/conform.nvim',
    dependencies = {
        shared.plugins.names.mason,
    },
    event = 'LazyFile',
    keys = {
        shared.keys.plugin:k('c', 'Conform'):bind('n', '<CMD>ConformInfo<CR>'):spec(),
    },
    ---@return conform.setupOpts
    opts = function()
        shared.plugins.handlers.format_buffer:set(
            'conform',
            function(_)
                require('conform').format({
                    async = true,
                    lsp_format = 'fallback',
                })
            end
        )

        local formatters = shared.target.collect('formatters')

        ---@type conform.setupOpts
        return {
            formatters_by_ft = vim.tbl_deep_extend('force', {
                ['*'] = { 'trim_whitespace', 'trim_newlines', 'injected' },
            }, formatters.by_ft),
            formatters = formatters.configs,
        }
    end,
}
