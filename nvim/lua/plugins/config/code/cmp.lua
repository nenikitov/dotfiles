---@diagnostic disable: missing-fields

local keymaps = require('user.keymaps')
local icons = require('user.icons')
local tty = require('utils.tty')

return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        -- Sources
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-calc',
        -- Icons
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup {
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'calc' },
                { name = 'buffer' },
                {
                    name = 'path',
                    option = { trailing_slash = true },
                },
            },
            mapping = keymaps.completion(),
            formatting = {
                fields = { 'kind', 'abbr', 'menu' },
                format = function(entry, item)
                    if tty.is_gui() then
                        item.kind = icons.completion[item.kind]
                        if vim.tbl_contains({ 'path' }, entry.source.name) then
                            local icon, hl_group = require('nvim-web-devicons').get_icon(
                                entry:get_completion_item().label
                            )
                            if icon then
                                item.kind = icon
                                item.kind_hl_group = hl_group
                            end
                        end
                    end

                    item.kind = item.kind .. ' '

                    item.menu = '[' .. entry.source.name .. ']'
                    return item
                end,
            },
            window = {
                completion = {
                    border = icons.border,
                    winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
                },
                documentation = { border = icons.border },
            },
        }

        cmp.setup.cmdline(':', {
            sources = {
                { name = 'path' },
                { name = 'cmdline' },
            },
        })

        cmp.setup.cmdline({ '/', '?' }, {
            sources = {
                { name = 'buffer' },
            },
        })
    end,
}
