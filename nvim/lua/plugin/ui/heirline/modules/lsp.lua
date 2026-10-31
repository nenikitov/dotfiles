---@module 'heirline'

local defs = require('defs')
local basic = require('plugin.ui.heirline.modules.basic')

local M = {}

---@type ne.util.vim.AutocmdEvent[]
M.events = {
    'DiagnosticChanged',
    'LspAttach',
    'LspDetach',
    'LspProgress',
}

--#region Progress spinner

local SPINNER_INTERVAL_MS = 100

---@class ne.plugin.heirline.modules.lsp.ProgressEntry
---@field title? string
---@field message? string
---@field percentage? integer

---@type table<integer, table<integer | string, ne.plugin.heirline.modules.lsp.ProgressEntry>>
local client_to_token_to_progress = {}

---@type uv.uv_timer_t?
local timer

local function update_timer()
    local any_busy = false
    for _, token_to_progress in pairs(client_to_token_to_progress) do
        if next(token_to_progress) then
            any_busy = true
            break
        end
    end

    if any_busy then
        if timer then
            return
        end
        timer = assert(vim.uv.new_timer())
        timer:start(0, SPINNER_INTERVAL_MS, vim.schedule_wrap(function()
            vim.cmd.redrawstatus({ bang = true })
        end))
    elseif timer then
        timer:stop()
        timer:close()
        timer = nil
    end
end

local group = vim.api.nvim_create_augroup('ne.heirline.lsp', { clear = true })

vim.api.nvim_create_autocmd('LspProgress', {
    group = group,
    callback = function(args)
        local id, params = args.data.client_id, args.data.params
        local value = params.value
        if type(value) ~= 'table' then
            return
        end

        client_to_token_to_progress[id] = client_to_token_to_progress[id] or {}
        if value.kind == 'end' then
            client_to_token_to_progress[id][params.token] = nil
        else
            local progress = client_to_token_to_progress[id][params.token] or {}
            progress.title = value.title or progress.title
            progress.message = value.message
            progress.percentage = value.percentage
            client_to_token_to_progress[id][params.token] = progress
        end

        update_timer()
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = group,
    callback = function(args)
        client_to_token_to_progress[args.data.client_id] = nil
        update_timer()
    end,
})

--#endregion

---@param self ne.plugin.heirline.modules.basic.Component
---@return boolean
local function has_clients(self)
    return #vim.lsp.get_clients({ bufnr = basic.bufnr(self) }) > 0
end

---@class ne.plugin.heirline.modules.lsp.Context : ne.plugin.heirline.modules.basic.Component
---@field counts table<vim.diagnostic.Severity, integer>
---@field clients vim.lsp.Client[]

M.context = basic.context(
    ---@param self ne.plugin.heirline.modules.lsp.Context
    function(self)
        local buf = basic.bufnr(self)
        self.counts = vim.diagnostic.count(buf)
        self.clients = vim.lsp.get_clients({ bufnr = buf })
    end
)

---@class ne.plugin.heirline.modules.lsp.DiagnosticsProps
---@field icon? boolean
---@field show_when_zero? boolean | 'with_nonzero'

---@param props? ne.plugin.heirline.modules.lsp.DiagnosticsProps
---@return ne.plugin.heirline.modules.basic.Component
function M.diagnostics(props)
    props = vim.tbl_extend('force', { icon = true, show_when_zero = true }, props or {})

    local severity = vim.diagnostic.severity

    ---@type { severity: vim.diagnostic.Severity, icon: string, hl_group: string }[]
    local parts = {
        { severity = severity.ERROR, icon = defs.icons.severity.error, hl_group = 'DiagnosticError' },
        { severity = severity.WARN, icon = defs.icons.severity.warning, hl_group = 'DiagnosticWarn' },
        { severity = severity.INFO, icon = defs.icons.severity.info, hl_group = 'DiagnosticInfo' },
        { severity = severity.HINT, icon = defs.icons.severity.hint, hl_group = 'DiagnosticHint' },
    }

    ---@type ne.plugin.heirline.modules.basic.Component[]
    local counts = vim.tbl_map(function(part)
        return {
            hl = part.hl_group,
            ---@param self ne.plugin.heirline.modules.lsp.Diagnostics
            condition = function(self)
                local buf = basic.bufnr(self)
                if not vim.diagnostic.is_enabled({ bufnr = buf }) then
                    return false
                end

                -- `vim.diagnostic.count` only includes severities above zero
                local counts = vim.diagnostic.count(buf)
                local any_nonzero = next(counts) ~= nil

                return (counts[part.severity] or 0) > 0
                    or (props.show_when_zero == true and (any_nonzero or has_clients(self)))
                    or (props.show_when_zero == 'with_nonzero' and any_nonzero)
            end,
            ---@param self ne.plugin.heirline.modules.lsp.Diagnostics
            provider = function(self)
                return (props.icon and part.icon or '') .. (self.counts[part.severity] or 0)
            end,
        }
    end, parts)

    ---@class ne.plugin.heirline.modules.lsp.Diagnostics : ne.plugin.heirline.modules.lsp.Context

    return M.context(basic.joined(' ', unpack(counts)))
end

---@class ne.plugin.heirline.modules.lsp.ClientsProps
---@field icon? boolean

---@param props? ne.plugin.heirline.modules.lsp.ClientsProps
---@return ne.plugin.heirline.modules.basic.Component
function M.clients(props)
    props = vim.tbl_extend('force', { icon = true }, props or {})

    ---@class ne.plugin.heirline.modules.lsp.Clients : ne.plugin.heirline.modules.lsp.Context

    return M.context(basic.joined(' ', {
        --- Icon or label
        ---@param self ne.plugin.heirline.modules.lsp.Clients
        condition = function(self)
            return has_clients(self) and props.icon
        end,
        provider = basic.icon(defs.icons.plugin.lsp),
    }, {
        --- Count
        condition = has_clients,
        ---@param self ne.plugin.heirline.modules.lsp.Clients
        provider = function(self)
            return #self.clients
        end,
    }))
end

---@class ne.plugin.heirline.modules.lsp.ProgressProps
---@field icon? boolean
---@field percentage? boolean

---@param props? ne.plugin.heirline.modules.lsp.ProgressProps
---@return ne.plugin.heirline.modules.basic.Component
function M.progress(props)
    props = vim.tbl_extend('force', { icon = true, percentage = true }, props or {})

    local frames = defs.icons.status.spinner
    local done = basic.icon(defs.icons.plugin.status.done)

    ---@param bufnr integer
    ---@return boolean
    local function busy(bufnr)
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if next(client_to_token_to_progress[client.id] or {}) then
                return true
            end
        end
        return false
    end

    ---@param bufnr integer
    ---@return integer?
    local function percentage(bufnr)
        local total, clients = 0, 0
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            local sum, tasks = 0, 0
            for _, entry in pairs(client_to_token_to_progress[client.id] or {}) do
                if entry.percentage then
                    sum = sum + entry.percentage
                    tasks = tasks + 1
                end
            end
            if tasks > 0 then
                total = total + sum / tasks
                clients = clients + 1
            end
        end
        if clients == 0 then
            return nil
        end
        return math.floor(total / clients)
    end

    return basic.joined(' ', {
        --- Spinner or done icon
        ---@param self ne.plugin.heirline.modules.basic.Component
        condition = function(self)
            return has_clients(self) and props.icon
        end,
        ---@param self ne.plugin.heirline.modules.basic.Component
        provider = function(self)
            if not busy(basic.bufnr(self)) then
                return done
            end
            local frame = math.floor(vim.uv.hrtime() / 1e6 / SPINNER_INTERVAL_MS) % #frames + 1
            return frames[frame]
        end,
    }, {
        --- Percentage
        ---@param self ne.plugin.heirline.modules.basic.Component
        condition = function(self)
            return has_clients(self) and props.percentage
        end,
        ---@param self ne.plugin.heirline.modules.basic.Component
        provider = function(self)
            local buf = basic.bufnr(self)
            if not busy(buf) then
                return 'done'
            end
            local value = percentage(buf)
            if not value then
                return ' ...'
            end
            return ('%3d'):format(value) .. '%%'
        end,
    })
end

return M
