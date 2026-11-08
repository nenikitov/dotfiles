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
function M.autocmd(events, opts)
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

---@param hls string[]
---@return string?
function M.find_hl(hls)
    for _, hl in ipairs(hls) do
        if not vim.tbl_isempty(vim.api.nvim_get_hl(0, { create = false, name = hl })) then
            return hl
        end
    end
    return nil
end

---@param msg string
---@param level? integer
---@param opts? table
function M.delayed_notify(msg, level, opts)
    local function notify()
        vim.schedule(function()
            vim.notify(msg, level, opts)
        end)
    end
    if vim.v.vim_did_enter == 1 then
        notify()
    else
        vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = notify })
    end
end

return M
