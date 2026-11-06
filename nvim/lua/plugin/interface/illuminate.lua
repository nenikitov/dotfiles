---@module 'lazy'

---@type LazySpec
return {
    'RRethy/vim-illuminate',
    event = { 'LazyFile' },
    opts = {
        disable_keymaps = true,
    },
    init = function()
        -- HACK: illuminate.vim has a vim plugin that gets sourced automatically before `configure` can be called
        -- This defers the loading
        vim.g.loaded_illuminate = 1
    end,
    config = function(plugin, opts)
        require('illuminate').configure(opts)

        vim.g.loaded_illuminate = nil
        vim.cmd.source(vim.fs.joinpath(plugin.dir, 'plugin', 'illuminate.vim'))
    end,
    -- TODO: Set correct keymaps `[n` and `]n`
    -- TODO: Can it be set to `%`
}
