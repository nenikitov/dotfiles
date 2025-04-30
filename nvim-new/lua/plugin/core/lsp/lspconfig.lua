return {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = { 'mason-tool-installer.nvim' },
    opts = {
        -- Is extended by specs in `language`
        servers = {},
    },
    config = function(_, opts)
        for server, config in pairs(opts.servers) do
            if type(config) == 'function' then
                config = config()
            end
            if config == true then
                config = {}
            end
            if config == false then
                goto continue
            end

            vim.lsp.enable(server)
            vim.lsp.config(server, config)

            ::continue::
        end
    end,
}
