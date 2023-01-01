--#region Helpers

-- Symbols outline
local aerial_status, aerial = pcall(require, 'aerial')
if not aerial_status then
    vim.notify('Aerial not available', vim.log.levels.ERROR)
    return
end

local function link_highlight(group_1, group_2)
    vim.api.nvim_set_hl(0, group_1, { link = group_2, default = true })
end

local icons = require('neconfig.user.icons').completion
for k, v in pairs(icons) do
    icons[k] = v .. ' '
end

local default_keys = {
    '?',
    'g?',
    '<CR>',
    '<2-LeftMouse>',
    '<C-v>',
    '<C-s>',
    'p',
    '<C-j>',
    '<C-k>',
    '{',
    '}',
    '[[',
    ']]',
    'q',
    'o',
    'za',
    'O',
    'zA',
    'l',
    'zo',
    'L',
    'zO',
    'h',
    'zc',
    'H',
    'zC',
    'zr',
    'zR',
    'zm',
    'zM',
    'zx',
    'zX',
}
local keys = {}
for _, k in ipairs(default_keys) do
    keys[k] = false
end

for k, v in pairs(require('neconfig.user.keymaps').aerial_navigation(require('aerial.actions'))) do
    keys[k] = v
end

--#endregion

--#region Symbols outline

-- General
aerial.setup {
    layout = {
        width = 30,
        max_width = { 0.9 },
        default_direction = 'right',
        win_opts = {
            winhl = table.concat({
                "EndOfBuffer:NvimTreeEndOfBuffer",
                "Normal:NvimTreeNormal",
                "CursorLine:NvimTreeCursorLine",
                "CursorLineNr:NvimTreeCursorLineNr",
                "LineNr:NvimTreeLineNr",
                "WinSeparator:NvimTreeWinSeparator",
                "NormalNC:NvimTreeNormalNC",
            }, ",")
        }
    },
    keymaps = keys,
    filter_kind = false,
    highlight_on_hover = true,
    icons = icons,
    show_guides = true,
    guides = {
        mid_item   = '│ ',
        last_item  = '└ ',
        nested_top = '│ ',
        whitespace = '  ',
    }
}

-- Colors
local groups = {
    { 'Array',         { 'Identifier' } },
    { 'Boolean',       { 'Boolean', 'Identifier' } },
    { 'Class',         { '@type', 'Type' } },
    { 'Constant',      { 'Constant' } },
    { 'Constructor',   { '@constructor', 'Special' } },
    { 'Enum',          { '@type', 'Type' } },
    { 'EnumMember',    { 'Identifier' } },
    { 'Event',         { 'Identifier' } },
    { 'Field',         { 'Identifier' } },
    { 'File',          { 'Identifier' } },
    { 'Function',      { 'Function' } },
    { 'Interface',     { '@type', 'Type' } },
    { 'Key',           { 'Identifier' } },
    { 'Method',        { '@method', 'Function' } },
    { 'Module',        { 'Include' } },
    { 'Namespace',     { '@namespace', 'Include' } },
    { 'Null',          { 'Constant', 'Indentifier' } },
    { 'Number',        { 'Number', 'Identifier'} },
    { 'Object',        { 'Identifier' } },
    { 'Operator',      { 'Identifier' } },
    { 'Package',       { 'Include' } },
    { 'Property',      { 'Identifier' } },
    { 'String',        { 'String', 'Identifier' } },
    { 'Struct',        { '@type', 'Type' } },
    { 'TypeParameter', { '@type', 'Identifier' } },
    { 'Variable',      { 'Identifier' } },
}
for _, g in ipairs(groups) do
    local aerial_name_text = 'Aerial' .. g[1]
    local aerial_name_icon = aerial_name_text .. 'Icon'

    -- Text
    for _, i in pairs(g[2]) do
        local highlight_status, _ = pcall(link_highlight, aerial_name_text, i)
        if highlight_status then
            break
        end
    end

    -- Icon
    table.insert(g[2], 1, 'CmpItemKind' .. g[1])
    for _, i in pairs(g[2]) do
        local highlight_status, _ = pcall(link_highlight, aerial_name_icon, i)
        if highlight_status then
            break
        end
    end
end
vim.cmd('hi link AerialLine NvimTreeCursorLine')
vim.cmd('hi link AerialGuide LineNr')

-- Keymaps
require('neconfig.user.keymaps').aerial_menus()

--#endregion

