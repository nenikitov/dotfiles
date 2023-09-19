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
        -- Icons
        'nvim-tree/nvim-web-devicons'
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
                {
                    name = 'path',
                    option = {
                        trailing_slash = true
                    }
                },
            },
            mapping = require('neconfig.user.keymaps').cmp(),
            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = function(entry, vim_item)
                    vim_item.kind = require('neconfig.user.icons').completion[vim_item.kind]
                    if vim.tbl_contains({ 'path' }, entry.source.name) then
                        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                        if icon then
                            vim_item.kind = icon
                            vim_item.kind_hl_group = hl_group
                        end
                    end
                    vim_item.kind = vim_item.kind .. ' '

                    vim_item.menu = '[' .. entry.source.name .. ']'
                    return vim_item
                end
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
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
