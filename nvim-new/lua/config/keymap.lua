vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts_default = {
    noremap = true,
    silent = true,
}
local function m(modes, keys, func, desc, opts)
    opts = vim.tbl_deep_extend('force', opts_default, opts or {})
    opts.desc = desc
    vim.keymap.set(modes, keys, func, opts)
end

m('n', [[<ESC>]], [[<CMD>nohlsearch<CR>]], 'clear last search')

m('t', [[<ESC><ESC>]], [[<C-\><C-n>]], 'exit terminal')

--#region Resize

local resize_horizontal = 2
local resize_vertical = 1
m('n', [[<A-L>]], function()
    local curr, right, left = vim.fn.winnr(), vim.fn.winnr('l'), vim.fn.winnr('h')
    local target = nil
    if right ~= curr then target = curr
    elseif left ~= curr then target = left
    end
    if target then vim.fn.win_move_separator(target, resize_horizontal) end
end, 'resize right')
m('n', [[<A-H>]], function()
    local curr, right, left = vim.fn.winnr(), vim.fn.winnr('l'), vim.fn.winnr('h')
    local target = nil
    if right ~= curr then target = curr
    elseif left ~= curr then target = left
    end
    if target then vim.fn.win_move_separator(target, -resize_horizontal) end
end, 'resize left')
m('n', [[<A-J>]], function()
    local curr, down, up = vim.fn.winnr(), vim.fn.winnr('j'), vim.fn.winnr('k')
    local target = nil
    if down ~= curr then target = curr
    elseif up ~= curr then target = up
    end
    if target then vim.fn.win_move_statusline(target, resize_vertical) end
end, 'resize down')
m('n', [[<A-K>]], function()
    local curr, down, up = vim.fn.winnr(), vim.fn.winnr('j'), vim.fn.winnr('k')
    local target = nil
    if down ~= curr then target = curr
    elseif up ~= curr then target = up
    end
    if target then vim.fn.win_move_statusline(target, -resize_vertical) end
end, 'resize up')

--#endregion

m('v', [[p]], [["_dP]], 'paste and keep the clipboard')
