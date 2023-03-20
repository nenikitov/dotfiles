return {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        's1n7ax/nvim-window-picker'
    },
    config = function()
        require('window-picker').setup {
            filter_rules = {
                bo = {
                    filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                    buftype = { 'terminal', "quickfix" },
                }
            }
        }

        require('neo-tree').setup {
            close_if_last_window = true,
            popup_border_style = 'single',
            default_component_config = {
                name = {
                    trailing_slash = true
                }
            },
            window = {
                position = 'right'
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = {
                        '.git'
                    },
                    follow_current_file = true
                }
            }
        }

        require('neconfig.user.keymaps').neo_tree_menu()
    end
}
