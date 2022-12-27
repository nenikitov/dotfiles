--#region Helpers

-- Load cmp
local cmp_status, cmp = pcall(require, 'cmp')
if not cmp_status then
    vim.notify('Completion engine not available', vim.log.levels.ERROR)
    return
end

-- Load snip
local luasnip_status, luasnip = pcall(require, 'luasnip')
if not luasnip_status then
    vim.notify('Snippet engine not available')
    return
end
require("luasnip.loaders.from_vscode").lazy_load()

--#endregion


--#region Completion

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert(
        require('neconfig.user.keymaps').completion(cmp, luasnip)
    ),
    sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
    formatting = {
        fields = { 'kind', 'abbr', 'menu' }
    },
    window = {
        documentation = cmp.config.window.bordered()
    }
}

--#endregion

