return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require('nvim-tree').setup {
            disable_netrw = true,
            hijack_cursor = true,
            reload_on_bufenter = true,
            view = {
                width = 35,
                side = 'right'
            },
            on_attach = require('neconfig.user.keymaps').nvim_tree_window,
            renderer = {
                add_trailing = true,
                highlight_git = true,
                indent_markers = {
                    enable = true
                },
                icons = {
                    show = {
                        folder_arrow = false
                    },
                    git_placement = 'after',
                    modified_placement = 'after',
                    glyphs = require('neconfig.user.icons').nvim_tree
                },
                special_files = {
                    'Cargo.toml', 'package.json',
                    'Makefile',
                    'README.md', 'readme.md',
                }
            },
            update_focused_file = {
                enable = true,
            },
            diagnostics = {
                enable = true,
                icons = require('neconfig.user.icons').diagnostics,
                severity = {
                    min = vim.diagnostic.severity.INFO
                }
            },
            git = {
                ignore = false
            },
            actions = {
                open_file = {
                    resize_window = false,
                }
            }
        }

        require('neconfig.user.keymaps').nvim_tree_menu()
    end
}
