---@class ne.util.async
local M = {}

---@param delay integer
---@param task fun(done: fun(), ...)
---@return fun(...) trigger
function M.debounce(delay, task)
    ---@class ne.util.async.DebounceState
    local L = {}

    L.timer = assert(vim.uv.new_timer())
    L.running = false
    L.out_of_date = false
    L.args = nil

    function L.done()
        L.running = false

        if L.out_of_date then
            L.out_of_date = false
            L.run()
        end
    end

    function L.run()
        if L.running then
            L.out_of_date = true
            return
        end

        L.running = true
        local ok, err = pcall(task, L.done, vim.F.unpack_len(L.args))
        if not ok then
            L.done()
            error(err)
        end
    end

    return function(...)
        L.args = vim.F.pack_len(...)
        L.timer:stop()
        L.timer:start(delay, 0, vim.schedule_wrap(L.run))
    end
end

return M
