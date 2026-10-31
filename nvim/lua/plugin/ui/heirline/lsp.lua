---@module 'heirline'

local defs = require('defs')
local basic = require('plugin.ui.heirline.basic')

local M = {}

---@type ne.util.vim.AutocmdEvent[]
M.events = {
    'DiagnosticChanged',
    'LspAttach',
    'LspDetach',
    'LspProgress',
}

--#region Progress

local SPINNER_INTERVAL_MS = 100

---@class ne.plugin.heirline.lsp.ProgressEntry
---@field title? string
---@field message? string
---@field percentage? integer

---@type table<integer, table<integer | string, ne.plugin.heirline.lsp.ProgressEntry>>
local client_to_token_to_progress = {}

---@type uv.uv_timer_t?
local timer

--- Run the spinner timer while any server reports progress
local function update_timer()
    local any_busy = false
    for _, tokens in pairs(client_to_token_to_progress) do
        if next(tokens) then
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

---@class ne.plugin.heirline.lsp.Context : ne.plugin.heirline.basic.Component
---@field counts table<vim.diagnostic.Severity, integer>
---@field clients vim.lsp.Client[]

M.context = basic.context(
    ---@param self ne.plugin.heirline.lsp.Context
    function(self)
        local buf = basic.buffer(self)
        self.counts = vim.diagnostic.count(buf)
        self.clients = vim.lsp.get_clients({ bufnr = buf })
    end
)

---@class ne.plugin.heirline.lsp.DiagnosticsProps
---@field icon? boolean
---@field show_when_zero? boolean | 'with_nonzero'

---@param props? ne.plugin.heirline.lsp.DiagnosticsProps
---@return ne.plugin.heirline.basic.Component
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

    ---@type ne.plugin.heirline.basic.Component[]
    local counts = vim.tbl_map(function(part)
        return {
            hl = part.hl_group,
            ---@param self ne.plugin.heirline.lsp.Diagnostics
            condition = function(self)
                if props.show_when_zero == true or (self.counts[part.severity] or 0) > 0 then
                    return true
                end
                -- `vim.diagnostic.count` only includes severities above zero
                return props.show_when_zero == 'with_nonzero' and next(self.counts) ~= nil
            end,
            ---@param self ne.plugin.heirline.lsp.Diagnostics
            provider = function(self)
                return (props.icon and part.icon or '') .. (self.counts[part.severity] or 0)
            end,
        }
    end, parts)

    ---@class ne.plugin.heirline.lsp.Diagnostics : ne.plugin.heirline.lsp.Context
    local component = {
        basic.joined(' ', unpack(counts)),
    }

    function component:condition()
        local buf = basic.buffer(self)
        if not vim.diagnostic.is_enabled({ bufnr = buf }) then
            return false
        end
        if next(vim.diagnostic.count(buf)) ~= nil then
            return true
        end
        return props.show_when_zero == true and #vim.lsp.get_clients({ bufnr = buf }) > 0
    end

    return M.context(component)
end

---@class ne.plugin.heirline.lsp.ClientsProps
---@field icon? boolean

---@param props? ne.plugin.heirline.lsp.ClientsProps
---@return ne.plugin.heirline.basic.Component
function M.clients(props)
    props = vim.tbl_extend('force', { icon = true }, props or {})

    ---@class ne.plugin.heirline.lsp.Clients : ne.plugin.heirline.lsp.Context
    local component = {
        basic.joined(' ', {
            --- Icon or label
            provider = props.icon and basic.icon(defs.icons.plugin.lsp) or 'lsp',
        }, {
            --- Count
            ---@param self ne.plugin.heirline.lsp.Clients
            provider = function(self)
                return #self.clients
            end,
        }),
    }

    function component:condition()
        return #vim.lsp.get_clients({ bufnr = basic.buffer(self) }) > 0
    end

    return M.context(component)
end

---@class ne.plugin.heirline.lsp.ProgressProps
---@field spinner? boolean
---@field percentage? boolean

---@param props? ne.plugin.heirline.lsp.ProgressProps
---@return ne.plugin.heirline.basic.Component
function M.progress(props)
    props = vim.tbl_extend('force', { spinner = true, percentage = true }, props or {})

    local frames = defs.icons.status.spinner
    local done = basic.icon(defs.icons.plugin.status.done)

    ---@param buf integer
    ---@return boolean
    local function busy(buf)
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
            if next(client_to_token_to_progress[client.id] or {}) then
                return true
            end
        end
        return false
    end

    ---@param buf integer
    ---@return integer?
    local function percentage(buf)
        local total, clients = 0, 0
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
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

    local component = basic.joined(' ', {
        --- Spinner or done icon
        ---@param self ne.plugin.heirline.basic.Component
        condition = function(self)
            return props.spinner or not busy(basic.buffer(self))
        end,
        ---@param self ne.plugin.heirline.basic.Component
        provider = function(self)
            if not busy(basic.buffer(self)) then
                return done
            end
            local frame = math.floor(vim.uv.hrtime() / 1e6 / SPINNER_INTERVAL_MS) % #frames + 1
            return frames[frame]
        end,
    }, {
        --- Percentage
        ---@param self ne.plugin.heirline.basic.Component
        condition = function(self)
            return props.percentage
        end,
        ---@param self ne.plugin.heirline.basic.Component
        provider = function(self)
            local buf = basic.buffer(self)
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

    local any_part_shown = component.condition --[[@as fun(self: StatusLine): boolean]]

    ---@param self ne.plugin.heirline.basic.Component
    component.condition = function(self)
        return #vim.lsp.get_clients({ bufnr = basic.buffer(self) }) > 0 and any_part_shown(self)
    end

    return component
end

return M
