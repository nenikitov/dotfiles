---@module 'gitsigns'

local defs = require('defs')
local basic = require('plugin.ui.heirline.modules.basic')

local M = {}

---@type ne.util.vim.AutocmdEvent[]
M.events = {
    { 'User', pattern = 'GitSignsUpdate' },
}

---@param head? string
---@return boolean
local function is_detached(head)
    return head ~= nil and head:match('^%x%x%x%x%x%x%x$') ~= nil
end

---@param self ne.plugin.heirline.modules.basic.Component
---@return Gitsigns.StatusObj?
local function status_of(self)
    return vim.b[basic.bufnr(self)].gitsigns_status_dict
end

---@class ne.plugin.heirline.modules.git.Context : ne.plugin.heirline.modules.basic.Component
---@field status? Gitsigns.StatusObj

M.context = basic.context(
    ---@param self ne.plugin.heirline.modules.git.Context
    function(self)
        self.status = status_of(self)
    end
)

---@class ne.plugin.heirline.modules.git.BranchProps
---@field icon? boolean

---@param props? ne.plugin.heirline.modules.git.BranchProps
---@return ne.plugin.heirline.modules.basic.Component
function M.branch(props)
    props = vim.tbl_extend('force', { icon = true }, props or {})

    ---@class ne.plugin.heirline.modules.git.Branch : ne.plugin.heirline.modules.git.Context
    ---@field status Gitsigns.StatusObj
    local component = {
        basic.joined(' ',
            --- Icon
            ---@class ne.plugin.heirline.modules.git.BranchIcon : ne.plugin.heirline.modules.git.Branch
            {
                ---@param self ne.plugin.heirline.modules.git.BranchIcon
                condition = function(self)
                    return props.icon
                end,
                ---@param self ne.plugin.heirline.modules.git.BranchIcon
                provider = function(self)
                    local head = self.status.head
                    if not head or head == '' then
                        return basic.icon(defs.icons.version_control.other.no_commits)
                    end
                    if is_detached(head) then
                        return basic.icon(defs.icons.version_control.other.commit)
                    end
                    return basic.icon(defs.icons.version_control.other.branch)
                end,
            },
            --- Head
            ---@class ne.plugin.heirline.modules.git.BranchHead : ne.plugin.heirline.modules.git.Branch
            {
                ---@param self ne.plugin.heirline.modules.git.BranchHead
                provider = function(self)
                    local head = self.status.head
                    if not head or head == '' then
                        return '[No Commits]'
                    end
                    local escaped, _ = head:gsub('%%', '%%%%')
                    return escaped
                end,
            }
        ),
    }

    function component:condition()
        return status_of(self) ~= nil
    end

    return M.context(component)
end

---@class ne.plugin.heirline.modules.git.DiffProps
---@field icon? boolean
---@field show_when_zero? boolean | 'with_nonzero'

---@param props? ne.plugin.heirline.modules.git.DiffProps
---@return ne.plugin.heirline.modules.basic.Component
function M.diff(props)
    props = vim.tbl_extend('force', { icon = true, show_when_zero = true }, props or {})

    ---@type { key: 'added' | 'changed' | 'removed', icon: string, hl_group: string }[]
    local parts = {
        { key = 'added', icon = defs.icons.version_control.status.added, hl_group = 'Added' },
        { key = 'changed', icon = defs.icons.version_control.status.changed, hl_group = 'Changed' },
        { key = 'removed', icon = defs.icons.version_control.status.deleted, hl_group = 'Removed' },
    }

    ---@param status Gitsigns.StatusObj
    ---@return boolean
    local function any_nonzero(status)
        return vim.iter(parts):any(function(part)
            return (status[part.key] or 0) > 0
        end)
    end

    ---@type ne.plugin.heirline.modules.basic.Component[]
    local counts = vim.tbl_map(function(part)
        return {
            hl = part.hl_group,
            ---@param self ne.plugin.heirline.modules.git.Diff
            condition = function(self)
                local status = status_of(self)
                if status == nil then
                    return false
                end

                local count = status[part.key] or 0
                return count > 0
                    or props.show_when_zero == true
                    or (props.show_when_zero == 'with_nonzero' and any_nonzero(status))
            end,
            ---@param self ne.plugin.heirline.modules.git.Diff
            provider = function(self)
                return (props.icon and part.icon or '') .. (self.status[part.key] or 0)
            end,
        }
    end, parts)

    ---@class ne.plugin.heirline.modules.git.Diff : ne.plugin.heirline.modules.git.Context
    ---@field status Gitsigns.StatusObj
    local component = basic.joined(' ', unpack(counts))

    return M.context(component)
end

return M
