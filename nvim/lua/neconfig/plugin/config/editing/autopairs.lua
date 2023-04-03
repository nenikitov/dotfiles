return {
    'windwp/nvim-autopairs',
    dependencies = {
        'hrsh7th/nvim-cmp'
    },
    config = function()
        local brackets = {
            { '(', ')' },
            { '{', '}' },
            { '[', ']' }
        }

        local autopairs = require('nvim-autopairs')
        autopairs.setup {
            check_ts = true,
            enable_check_bracket_line = false
        }

        -- CMP integration
        require('cmp').event:on(
            'confirm_done',
            require('nvim-autopairs.completion.cmp').on_confirm_done()
        )

        local Rule = require('nvim-autopairs.rule')

        -- Add spaces between parentheses

        autopairs.add_rules {
            Rule(' ', ' ')
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
            Rule(bracket[1] .. ' ', ' ' .. bracket[2])
                :with_pair(function()
                    return false
                end)
                :with_move(function(opts)
                    return opts.prev_char:match('.%' .. bracket[2]) ~= nil
                end)
                :use_key(bracket[2])
            }
        end
    end
}
