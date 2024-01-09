return {
    'windwp/nvim-autopairs',
    dependencies = {
        'hrsh7th/nvim-cmp',
    },
    config = function(_, opts)
        local autopairs = require('nvim-autopairs')
        local Rule = require('nvim-autopairs.rule')
        local cond = require('nvim-autopairs.conds')
        local ts_cond = require('nvim-autopairs.ts-conds')

        autopairs.setup(opts)

        require('cmp').event:on(
            'confirm_done',
            require('nvim-autopairs.completion.cmp').on_confirm_done()
        )

        autopairs.add_rules {
            Rule('$', '$', { 'tex', 'latex', 'markdown' })
                :with_pair(ts_cond.is_not_ts_node({ "inline_formula" }))
                :with_pair(cond.not_before_regex('[^%s%$]')),
            Rule('<', '>')
                :with_pair(cond.before_regex('%a+'))
                :with_move(cond.after_text('>')),
            Rule('|', '|', { 'rust' })
                :with_move(cond.after_text('|')),
        }
    end,
    opts = function()
        return {
            check_ts = true,
        }
    end
}
