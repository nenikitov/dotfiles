---@class ne.util.vim
local M = {}

---@param name string
---@return integer group_id
function M.augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

---@alias ne.util.vim.AutocmdEvent
---| string
---| { [1]: string, pattern: string | string[] }

---@param events ne.util.vim.AutocmdEvent[]
---@param opts vim.api.keyset.create_autocmd
---@return integer[] ids
function M.autocmd_multiple_events(events, opts)
    local ids = {}
    for _, event in ipairs(events) do
        local name, pattern
        if type(event) == 'string' then
            name = event
        else
            name, pattern = event[1], event.pattern
        end

        local event_opts = vim.tbl_extend('force', opts, { pattern = pattern })
        table.insert(ids, vim.api.nvim_create_autocmd(name, event_opts))
    end
    return ids
end

return M
