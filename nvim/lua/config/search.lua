local util = require('util')

--#region Case
vim.opt.ignorecase = true
vim.opt.smartcase = true
--#endregion

--#region Navigation
---@param forward boolean
---@return function
local function search_next(forward)
    return function()
        local key = (vim.v.searchforward == 1) == forward and 'n' or 'N'
        if vim.fn.mode(1):sub(1, 2) == 'no' then
            return key
        end
        return key .. 'zvzz'
    end
end
util.map:k('n', 'Next search result (always down), centered'):bind({ 'n', 'x', 'o' }, search_next(true), { expr = true }):set()
util.map:k('N', 'Previous search result (always up), centered'):bind({ 'n', 'x', 'o' }, search_next(false), { expr = true }):set()

util.map:k('<ESC>', 'Clear search'):bind('n', '<CMD>nohlsearch<CR>'):set()
--#endregion

--#region Substitution
vim.opt.inccommand = 'split'
--#endregion
