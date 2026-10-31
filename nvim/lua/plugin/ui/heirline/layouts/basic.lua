---@module 'heirline'

local M = {}

---@class ne.plugin.heirline.layout.basic.Background
---@field gui? string
---@field cterm? integer

--- The background colour of a highlight, as heirline colour fields
---@param hl string | table highlight group name, or a heirline highlight table
---@return ne.plugin.heirline.layout.basic.Background
function M.background(hl)
    if type(hl) == 'string' then
        local group = vim.api.nvim_get_hl(0, { name = hl, link = false })
        return { gui = group.bg and ('#%06x'):format(group.bg), cterm = group.ctermbg }
    end
    return { gui = hl.bg, cterm = hl.ctermbg }
end

---@param from string | table
---@param to string | table
---@return table
function M.blend(from, to)
    local own, other = M.background(from), M.background(to)
    return {
        fg = own.gui,
        ctermfg = own.cterm,
        bg = other.gui,
        ctermbg = other.cterm,
    }
end

return M
