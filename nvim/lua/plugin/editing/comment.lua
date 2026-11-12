---@module 'lazy'
---@module 'Comment'
---@module 'ts_context_commentstring'

--[[
---@module 'lazy'

---@type LazySpec
]]

---@type LazySpec
return {
    'numtostr/comment.nvim',
    dependencies = {
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            ---@type ts_context_commentstring.Config
            opts = {},
        }
    },
    event = 'LazyFile',
    -- TODO: Figure out Partial<T>
    ---@diagnostic disable: missing-fields
    ---@type CommentConfig
    opts = {
        toggler = {
            line = 'gcc',
            block = 'gCC',
        },
        opleader = {
            line = 'gc',
            block = 'gC',
        },
        pre_hook = function ()
            return vim.bo.commentstring
        end
    },
    ---@diagnostic enable: missing-fields
}
