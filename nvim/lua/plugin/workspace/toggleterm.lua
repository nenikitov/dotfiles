---@module 'lazy'
---@module 'toggleterm'

---@type LazySpec
return {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    -- TODO: Figure out Partial<T>
    ---@diagnostic disable: missing-fields
    ---@type ToggleTermConfig
    opts = {
        open_mapping = '<A-CR>',
        autochdir = true,
        shade_terminals = false,
        persist_size = false,
        persist_mode = false,
        direction = 'float',
        highlights = {
            FloatBorder = { link = 'WinSeparator' },
        },
        float_opts = {
            border = vim.o.winborder,
        },
    },
    ---@diagnostic enable: missing-fields
}
