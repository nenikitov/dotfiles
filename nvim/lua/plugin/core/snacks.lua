---@module 'lazy'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.snacks,
    lazy = false,
    priority = 1000,
    config = function(_, opts)
        -- HACK: Allow customizing spinner
        -- Relies on overwriting an internal function

        require('snacks.util').spinner = function()
            local uv = vim.uv or vim.loop
            local spinner = shared.icons.ui.progress.spinner
            return spinner[math.floor(uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end

        require('snacks').setup(opts)
    end
}
