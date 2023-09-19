local languages = {
    'awk', 'passwd', 'ini',
    'diff', 'regex',
    'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore',

    'vimdoc',
    'markdown', 'markdown_inline', 'org',

    'comment',

    'html', 'css', 'scss',
    'javascript', 'jsdoc',
    'tsx', 'typescript', 'json', 'json5', 'jsonc', 'jsonnet',

    'bash',
    'lua', 'luadoc', 'luap',
    'vim',
    'python',

    'c', 'cpp',
    'cmake', 'make',
    'rust',

    'sql', 'commonlisp',

    'toml', 'yaml',
}

return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-refactor',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'JoosepAlviste/nvim-ts-context-commentstring',
        'windwp/nvim-ts-autotag',
        'nvim-treesitter/playground',
        'theRealCarneiro/hyprland-vim-syntax',
        'elkowar/yuck.vim'
    },
    build = function()
        require('nvim-treesitter.install').update {
            with_sync = true
        }
    end,
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = languages,
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true
            },
            refactor = {
                highlight_definitions = {
                    enable = true,
                    clear_on_cursor_move = true
                }
            },
            autotag = {
                enable = true
            },
            context_commentstring = {
                enable = true,
                enable_autocmd = false
            },
            textobjects = {
                enable = true,
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = require('neconfig.user.keymaps').treesitter_textobjects_select()
                },
                move = vim.tbl_deep_extend(
                    'force',
                    {
                        enable = true
                    },
                    require('neconfig.user.keymaps').treesitter_textobjects_move()
                )
            },
            playground = {
                enable = true
            }
        }

        require('neconfig.user.keymaps').treesitter()
    end
}
