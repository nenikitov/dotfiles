--#region Helpers

-- Autopairs
local autopairs_status, autopairs = pcall(require, 'nvim-autopairs')
if not autopairs_status then
    vim.notify('Autopairs not available', vim.log.levels.ERROR)
    return
end
local autopairs_cmp = require('nvim-autopairs.completion.cmp')
local autopairs_rule = require('nvim-autopairs.rule')

-- CMP
local cmp_status, cmp = pcall(require, 'cmp')

-- All bracket types
local brackets = {
    { '(', ')' },
    { '[', ']' },
    { '{', '}' }
}

--#endregion


--#region Autopairs

-- Autopairs
autopairs.setup {
    check_ts = true,
    enable_check_bracket_line = false
}

-- CMP integration
if cmp_status then
    cmp.event:on(
        'confirm_done',
        autopairs_cmp.on_confirm_done()
    )
end

-- Add spaces between parentheses
autopairs.add_rules {
    autopairs_rule(' ', ' ')
    :with_pair(function (opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        local bracket_pairs = {}
        for i, bracket_pair in ipairs(brackets) do
            bracket_pairs[i] = bracket_pair[1] .. bracket_pair[2]
        end
        return vim.tbl_contains(bracket_pairs, pair)
    end)
}
for _,bracket in pairs(brackets) do
    autopairs.add_rules {
    autopairs_rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(function()
            return false
        end)
        :with_move(function(opts)
            return opts.prev_char:match('.%' .. bracket[2]) ~= nil
        end)
        :use_key(bracket[2])
    }
end

--#endregion

