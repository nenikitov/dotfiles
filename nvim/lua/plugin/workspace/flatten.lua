---@module 'lazy'
---@module 'flatten'

---@type LazySpec
return {
    'willothy/flatten.nvim',
    lazy = false,
    priority = 1000,
    -- TODO: Figure out Partial<T>
    ---@diagnostic disable: missing-fields
    ---@type Flatten.Config
    opts = {
        block_for = {
            gitcommit = false,
            gitrebase = false,
        },
        window = {
            open = 'alternate'
        },
    },
    ---@diagnostic enable: missing-fields
}
