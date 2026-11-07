---@module 'lazy'

local shared = require('shared')

---@type LazySpec
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        shared.plugins.names.mason,
        shared.plugins.names.blink_cmp,
    },
    event = 'LazyFile',
    config = function()
        for name, server in pairs(shared.target.collect('servers')) do
            if type(server) == 'function' then
                server = server()
            end
            if server == false then
                goto continue
            end
            if server == true then
                server = {}
            end

            vim.lsp.config(name, server)
            vim.lsp.enable(name)

            ::continue::
        end
    end,
}
