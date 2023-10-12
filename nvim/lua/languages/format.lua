return function()
    return {
        install = {
            'stylua',
            'prettierd',
        },
        filetypes = {
            ['*'] = { 'trim_newlines', 'trim_whitespace' },
            lua = { 'stylua' },
            javascript = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescript = { 'prettier' },
            typescriptreact = { 'prettier' },
            css = { 'prettier' },
            scss = { 'prettier' },
            html = { 'prettier' },
            json = { 'prettier' },
            jsonc = { 'prettier' },
            yaml = { 'prettier' },
            markdown = { 'prettier', 'injected' },
        },
    }
end
