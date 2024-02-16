local M = {}

---@class LspTaskStatus
---@field title string
---@field message string?
---@field percent number?
---@field done boolean

function M.progress_handler()
    ---@type LspTaskStatus[][]
    local status = {}

    local function handle_progress(_, result, context)
        local value = result.value

        local client = context.client_id
        status[client] = status[client] or {}

        local task = result.token

        if value.kind == 'begin' then
            status[client][task] = {
                title = value.title,
                message = value.message,
                percent = value.percentage,
                done = false,
            }
        elseif value.kind == 'report' then
            if value.percentage then
                status[client][task].percent = value.percentage
            end
            if value.message then
                status[client][task].message = value.message
            end
            value.done = false
        else
            status[client][task].percent = value.percentage or 100
            status[client][task].message = value.message or 'Complete'
            status[client][task].done = true
            vim.defer_fn(function()
                if status[client] and status[client][task] and status[client][task].done then
                    status[client][task] = nil
                end
                if vim.tbl_count(status[client]) == 0 then
                    status[client] = nil
                end
            end, 500)
        end
    end

    return {
        assign = function()
            local old = vim.lsp.handlers['$/progress']
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.lsp.handlers['$/progress'] = function(...)
                old(...)
                handle_progress(...)
            end
        end,
        status = status,
    }
end

return M
