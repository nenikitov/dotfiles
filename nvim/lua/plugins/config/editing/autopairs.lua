local keymaps = require('user.keymaps')

return {
    'windwp/nvim-autopairs',
    dependencies = {
        'hrsh7th/nvim-cmp',
    },
    config = function(_, opts)
        local autopairs = require('nvim-autopairs')
        local Rule = require('nvim-autopairs.rule')
        local cond = require('nvim-autopairs.conds')

        autopairs.setup(opts)

        require('cmp').event:on(
            'confirm_done',
            require('nvim-autopairs.completion.cmp').on_confirm_done()
        )

        autopairs.add_rule(
            Rule('$', '$', { 'tex', 'latex', 'markdown' })
            :with_pair(cond.not_before_regex('[^%s%$]'))
        )
    end,
    opts = function()
        return {
            check_ts = true,
        }
    end
}
