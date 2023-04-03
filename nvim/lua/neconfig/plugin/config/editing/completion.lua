return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        -- Sources
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        -- Snippets
        'L3MON4D3/LuaSnip',
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup {
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end
            },
            sources = cmp.config.sources {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            },
            mapping = require('neconfig.user.keymaps').cmp(),
            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = function(entry, vim_item)
                    vim_item.kind = require('neconfig.user.icons').completion[vim_item.kind] .. ' '
                    vim_item.menu = '[' .. entry.source.name .. ']'
                    return vim_item
                end
            }
        }

        cmp.setup.cmdline(':', {
            sources = {
                { name = 'path' },
                { name = 'cmdline' },
            }
        })

        cmp.setup.cmdline({ '/', '?' }, {
            sources = {
                { name = 'buffer' }
            }
        })
    end
}
