return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = function()
        local function spaces()
            local sw = vim.api.nvim_buf_get_option(0, 'shiftwidth')
            local ts = vim.api.nvim_buf_get_option(0, 'tabstop')
            if sw == ts then
                return 'sw ' .. sw
            else
                return 'sw ' .. sw .. ' ts ' .. ts
            end end

        local function progress_graphic()
            local current_line = vim.fn.line(".")
            local total_lines = vim.fn.line("$")
            local chars = { '⠀', '⠁', '⠉', '⠋', '⠛', '⠟', '⠿', '⡿' ,'⣿', '█' }
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
        end

        ---@param min_width number
        ---@return fun(str: string): string
        local function hide(min_width)
            return function(str)
                local win_width = vim.fn.winwidth(0)
                if win_width < min_width then
                    return ''
                else
                    return str
                end
            end
        end

        -- Sections
        -- ╭───┬───┬─────────────────────────────────┬───┬───╮
        -- │ A │ B │ C                             X │ Y │ Z │
        -- ╰───┴───┴─────────────────────────────────┴───┴───╯
        --  ███|░░░| -                             - |░░░|███
        require('lualine').setup {
            options = {
                component_separators = '|',
                section_separators = '▒',
                disabled_filetypes = {
                    'NvimTree'
                }
            },
            sections = {
                lualine_a = {
                    'mode'
                },
                lualine_b = {
                    {
                        'branch',
                        fmt = hide(100)
                    },
                    {
                        'diagnostics',
                        update_in_insert = true
                    },
                    {
                        'diff',
                        fmt = hide(100)
                    }
                },
                lualine_c = {
                    'filename'
                },
                lualine_x = {
                    {
                        'encoding',
                        fmt = hide(100),
                    },
                    {
                        'fileformat',
                        fmt = hide(60),
                        symbols = {
                            unix = '󰌽 lf',
                            dos  = ' crlf',
                            mac  = ' cr',
                        }
                    }
                },
                lualine_y = {
                    {
                        spaces,
                        fmt = hide(100)
                    },
                    {
                        'filetype',
                        colored = false,
                        fmt = hide(60)
                    }
                },
                lualine_z = {
                    {
                        progress_graphic,
                        fmt = hide(100)
                    },
                    {
                        'progress',
                        fmt = hide(60)
                    },
                    'location'
                }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    'filename'
                },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
        }
    end
}
