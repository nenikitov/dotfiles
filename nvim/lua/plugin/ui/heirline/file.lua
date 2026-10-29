local defs = require('defs')

local M = {}

---@class ne.plugin.heirline.file.Icon : ne.plugin.heirline.file.Block
---@field icon string
---@field hl_group string
M.Icon = {}

function M.Icon:init()
    self.icon, self.hl_group = require('mini.icons').get('file', self.name)
end

function M.Icon:provider()
    return self.icon .. ' '
end

function M.Icon:hl()
    return self.hl_group
end

---@class ne.plugin.heirline.file.Name : ne.plugin.heirline.file.Block
M.Name = {}

function M.Name:provider()
    local short = vim.fn.fnamemodify(self.name, ':.')

    if short == '' then
        return '[No Name]'
    end

    -- TODO: pathshorten

    return short
end

---@class ne.plugin.heirline.file.Flags : ne.plugin.heirline.file.Block
M.Flags = {
    {
        condition = function () return vim.bo.modified end,
        provider = defs.icons.file.modified,
    },
    {
        condition = function () return not vim.bo.modifiable or vim.bo.readonly end,
        provider = defs.icons.file.readonly,
    },
}

---@class ne.plugin.heirline.file.Block : ne.plugin.heirline.Component
---@field name string
M.Block = {
    M.Icon,
    M.Name,
    M.Flags,
}

function M.Block:init()
    self.name = vim.api.nvim_buf_get_name(0)
end

return M
