local map = require("util.map")

--#region Leader

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--#endregion

--#region Buffer/Window/Split

-- Prefix
map.map("n", "<LEADER>b", "<NOP>", "buffer/window/split")
-- Split
map.map("n", "<LEADER>bs", "<CMD>split<RETURN>", "Split horizontally")
map.map("n", "<LEADER>bv", "<CMD>vsplit<RETURN>", "Split vertically")
-- Manipulation
map.map("n", "<LEADER>bn", "<CMD>enew<RETURN>", "Create new empty buffer")
map.map("n", "<LEADER>br", "<CMD>edit<RETURN>", "Refresh")
map.map("n", "<LEADER>bq", "<CMD>quit<RETURN>", "Quit")
map.map("n", "<A-c>", "<CMD>quit<RETURN>", "Quit")
map.map("n", "<LEADER>bd", "<CMD>bdelete<RETURN>", "Delete")
-- Focus
map.map("n", "<A-l>", "<CMD>wincmd l<RETURN>", "Focus right")
map.map("n", "<A-h>", "<CMD>wincmd h<RETURN>", "Focus left")
map.map("n", "<A-j>", "<CMD>wincmd j<RETURN>", "Focus down")
map.map("n", "<A-k>", "<CMD>wincmd k<RETURN>", "Focus up")
-- Resize
local resize_horizontal = 2
local resize_vertical = 1
local function resize(dir)
    local is_horizontal = dir == "h" or dir == "l"
    local is_positive = dir == "l" or dir == "j"

    local curr = vim.fn.winnr()
    local next = vim.fn.winnr(is_horizontal and "l" or "j")
    local prev = vim.fn.winnr(is_horizontal and "h" or "k")

    local target = nil
    if next ~= curr then
        target = curr
    elseif prev ~= curr then
        target = prev
    end

    if target then
        local resize_fn = is_horizontal and vim.fn.win_move_separator or vim.fn.win_move_statusline
        resize_fn(target, (is_positive and 1 or -1) * (is_horizontal and resize_horizontal or resize_vertical))
    end
end
map.map("n", "<A-S-l>", map.bind(resize, "l"), "Resize right")
map.map("n", "<A-S-h>", map.bind(resize, "h"), "Resize left")
map.map("n", "<A-S-j>", map.bind(resize, "j"), "Resize down")
map.map("n", "<A-S-k>", map.bind(resize, "k"), "Resize up")

--#endregion

--#region Editing

-- Move across wrapped lines
map.map("", "j", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true })
map.map("", "<DOWN>", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true })
map.map("", "k", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true })
map.map("", "<UP>", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true })
-- Move faster
map.map("", "H", "^", "Start of line (non ws)")
map.map("", "L", "$", "End of line")
-- Copy / Paste
map.map("v", "p", '"_dP', "Paste and keep the clipboard")
map.map("x", "y", "ygv<ESC>", "Yank without moving")
-- Indent
map.map("x", "<", "<gv", "Unindent without exiting visual")
map.map("x", ">", ">gv", "Indent without exiting visual")
-- Search
map.map("n", "n", "nzzzv", "Go to next search and center view")
map.map("n", "N", "Nzzzv", "Go to previous search and center view")
-- Other
map.map("n", "U", "<C-r>", "Redo")
map.map("n", "<ESC>", "<CMD>nohlsearch<RETURN>", "Clear last search")
map.map("t", "<ESC><ESC>", "<C-\\><C-n>", "Normal mode")

--#endregion
