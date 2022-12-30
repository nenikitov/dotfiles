--#region Helpers

-- CMP
local cmp_status, cmp = pcall(require, 'cmp')
if not cmp_status then
    vim.notify('CMP not available', vim.log.levels.ERROR)
    return
end

-- LuaSnip
local luasnip_status, luasnip = pcall(require, 'luasnip')
if not luasnip_status then
    vim.notify('Snippet engine not available')
    return
end
require('luasnip.loaders.from_vscode').lazy_load()

local icons = require('neconfig.user.icons').completion

--#endregion


--#region Completion

-- General
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert(
        require('neconfig.user.keymaps').completion(cmp)
    ),
    sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
    formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
            vim_item.kind = icons[vim_item.kind] .. ' '
            vim_item.menu = '[' .. entry.source.name .. ']'
            return vim_item
        end
    },
    window = {
        documentation = cmp.config.window.bordered()
    }
}

--#endregion

