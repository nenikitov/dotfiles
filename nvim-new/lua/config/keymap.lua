local opts_default = {
    noremap = true,
    silent = true,
}
local function map(modes, keys, func, desc, opts)
    opts = vim.tbl_deep_extend("force", opts_default, opts or {}, { desc = desc })
    vim.keymap.set(modes, keys, func, opts)
end

--#region Leader

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--#endregion

--#region Buffer/Window/Split

-- Prefix
map('n', [[<LEADER>b]], [[<NOP>]], 'buffer/window/split')
-- Split
map('n', [[<LEADER>bs]], [[<CMD>split<RETURN>]], 'Split horizontally')
map('n', [[<LEADER>bv]], [[<CMD>vsplit<RETURN>]], 'Split vertically')
-- Manipulation
map('n', [[<LEADER>bn]], [[<CMD>enew<RETURN>]], 'Create new empty buffer')
map('n', [[<LEADER>br]], [[<CMD>edit<RETURN>]], 'Refresh')
map('n', [[<LEADER>bq]], [[<CMD>quit<RETURN>]], 'Quit')
map('n', [[<A-c>]], [[<CMD>quit<RETURN>]], 'Quit')
map('n', [[<LEADER>bd]], [[<CMD>bdelete<RETURN>]], 'Delete')
-- Focus
map("n", [[<A-l>]], [[<CMD>wincmd l<RETURN>]], "resize right")
map("n", [[<A-h>]], [[<CMD>wincmd h<RETURN>]], "resize left")
map("n", [[<A-j>]], [[<CMD>wincmd j<RETURN>]], "resize down")
map("n", [[<A-k>]], [[<CMD>wincmd k<RETURN>]], "resize up")
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
        resize_fn(
            target,
            (is_positive and 1 or -1) * (is_horizontal and resize_horizontal or resize_vertical)
        )
    end
end
map("n", [[<A-L>]], function() resize("l") end, "resize right")
map("n", [[<A-H>]], function() resize("h") end, "resize left")
map("n", [[<A-J>]], function() resize("j") end, "resize down")
map("n", [[<A-K>]], function() resize("k") end, "resize up")

--#endregion

--#region Editing

-- Move across wrapped lines
map("", [[j]], [[v:count == 0 ? 'gj' : 'j']], "Down", { expr = true })
map("", [[<Down>]], [[v:count == 0 ? 'gj' : 'j']], "Down", { expr = true })
map("", [[k]], [[v:count == 0 ? 'gk' : 'k']], "Up", { expr = true })
map("", [[<Up>]], [[v:count == 0 ? 'gk' : 'k']], "Up", { expr = true })
-- Move faster
map("", [[H]], [[^]], "Start of line (non ws)")
map("", [[L]], [[$]], "End of line")
-- Copy / Paste
map("v", [[p]], [["_dP]], "Paste and keep the clipboard")
map('x', [[y]], [[ygv<ESC>]], 'Yank without moving')
-- Indent
map('x', [[<]], [[<gv]], 'Unindent without exiting visual')
map('x', [[>]], [[>gv]], 'Indent without exiting visual')
-- Search
map('n', [[n]], [[nzzzv]], 'Go to next search and center view')
map('n', [[N]], [[Nzzzv]], 'Go to previous search and center view')
-- Other
map('n', [[U]], [[<C-r>]], "Redo")
map("n", [[<ESC>]], [[<CMD>nohlsearch<RETURN>]], "Clear last search")
map("t", [[<ESC><ESC>]], [[<C-\><C-n>]], "Normal mode")

--#endregion
