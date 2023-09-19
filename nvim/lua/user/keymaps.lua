local M = {}

---@alias KeymapMode
---| '' Normal, Visual, Select, Operator-pending.
---| 'n' Normal.
---| 'v' Visual and Select.
---| 's' Select.
---| 'x' Visual.
---| 'o' Operator-pending.
---| '!' Insert, Command-line.
---| 'i' Insert.
---| 'l' Insert, Command-line, Lang.
---| 'c' Command-line.
---| 't' Terminal.

--- Default keymap options.
local default_options = {
    noremap = true,
    silent = true,
}

--- Add a keymap.
---@param modes KeymapMode | KeymapMode[] Modes in which keymap will exist.
---@param keys string Key combination.
---@param func string | fun() What to do when keymap is triggered.
---@param description string? Description.
---@param options table? Options.
local function map(modes, keys, func, description, options)
    options = vim.tbl_deep_extend('force', default_options, options or {})
    options.desc = description
    vim.keymap.set(modes, keys, func, options)
end

function M.general()
    -- Leader
    vim.g.mapleader = '<SPACE>'
    vim.g.maplocalleader = '<SPACE>'
    map('', '<SPACE>', '<NOP>')
end

return M
