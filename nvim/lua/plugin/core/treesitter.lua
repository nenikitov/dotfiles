---@module 'lazy'

local util = require('util')
local defs = require('defs')

---@type LazySpec
return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    opts = {
        parsers = {
            -- Recommended to be always installed
            'vim',
            'vimdoc',
            'query',
            'markdown',
            'markdown_inline',
            -- Injected into many other languages
            'comment',
            'diff',
            'regex',
        },
    },
    config = function(_, opts)
        local treesitter = require('nvim-treesitter')

        local parsers = vim.list_extend(vim.deepcopy(opts.parsers), defs.lang.collect('parsers'))
        local disable_highlight = defs.lang.collect('treesitter').disable_highlight or {}

        -- Install packages
        local installed = treesitter.get_installed()
        local missing = vim.tbl_filter(
            function(parser) return not vim.list_contains(installed, parser) end,
            vim.list.unique(parsers)
        )
        if #missing > 0 then
            treesitter.install(missing)
        end

        vim.api.nvim_create_autocmd('FileType', {
            group = util.vim.augroup('treesitter'),
            desc = 'Start treesitter highlighting when a parser is available',
            callback = function(event)
                local buf = event.buf

                local language = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
                if not language or vim.list_contains(disable_highlight, language) then
                    return
                end

                local ok, parser = pcall(vim.treesitter.get_parser, buf, language)
                if not ok or not parser then
                    return
                end

                vim.treesitter.start(buf, language)

                -- TODO: Indent
            end,
        })
    end,
}
