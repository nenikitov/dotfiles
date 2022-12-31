--#region Helpers

-- Comment
local comment_status, comment = pcall(require, 'Comment')
if not comment_status then
    vim.notify('Comment not available', vim.log.levels.ERROR)
    return
end

-- Context commentstring
local context_commentstring_status, context_commentstring = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
local pre_hook = nil
if context_commentstring_status then
    pre_hook = context_commentstring.create_pre_hook()
else
    vim.notify('Context commentstring not available', vim.log.levels.WARN)
end

--#endregion


--#region Comment

comment.setup {
    toggler = require('neconfig.user.keymaps').comment_toggler(),
    opleader = require('neconfig.user.keymaps').comment_opleader(),
    mappings = {
        basic = true,
        extra = false
    },
    pre_hook = pre_hook
}

--#endregion

