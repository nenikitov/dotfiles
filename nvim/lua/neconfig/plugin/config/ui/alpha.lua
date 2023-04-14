return {
    'nenikitov/alpha-nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    event = 'VimEnter',
    config = function()
        local utils_logo = require('neconfig.utils.logo')

        ---@param left string
        ---@param middle string
        ---@param right string
        ---@param width integer
        ---@return string
        local function align_strings(left, middle, right, width)
            local s = width - #left - #middle - #right
            local l = math.floor(s / 2)
            local r = s - l

            return (
                left .. (' '):rep(l)
                .. middle
                .. (' '):rep(r) .. right
            )
        end

        local width = 50
        local separator = '====='

        ---@param keys string
        ---@param icon string
        ---@param description string
        ---@param command string?
        ---@return table
        local function button(keys, icon, description, command)
            return {
                type = 'button',
                val = icon .. '  ' .. description,
                on_press = function()
                    local keys = vim.api.nvim_replace_termcodes(command or keys, true, false, true)
                    vim.api.nvim_feedkeys(keys, 't', false)
                end,
                opts = {
                    position = 'center',
                    shortcut = keys,
                    keymap =
                        command
                        and {
                            'n',
                            keys,
                            command,
                            { noremap = true, silent = true, nowait = true }
                        }
                        or nil,
                    cursor = #icon + 2,
                    width = width,
                    align_shortcut = 'right',
                    hl = { {'Function', 0, #icon} },
                    hl_shortcut = 'Keyword'
                }
            }
        end

        ---@param text string
        ---@param highlight string?
        ---@return table
        local function span(text, highlight)
            return {
                type = 'text',
                val = text,
                opts = {
                    position = 'center',
                    hl = highlight or 'Normal'
                }
            }
        end

        local b = utils_logo.span_generator('DevIconLua')
        local c = utils_logo.span_generator('DevIconMint')
        local g = utils_logo.span_generator('DevIconBash')
        local gd = utils_logo.span_generator('DevIconXls')
        local gdd = utils_logo.span_generator('DevIconVim')
        local logo = utils_logo.new_logo {
            { c[[     .]]          ,g[[          ]],   gd[[.     ]]              },
            { c[[   ';;]]          ,g[[,.        ]],   gd[[::'   ]]              },
            { b[[ ,:]],   c[[::;]] ,g[[,,        ]],   gd[[:ccc, ]]              },
            { b[[,::c]],  c[[::]]  ,g[[,,,,.     ]],   gd[[:cccc,]]              },
            { b[[,cccc]], c[[:]]   ,g[[;;;;;.    ]],   gd[[cllll,]]              },
            { b[[,cccc;]]          ,g[[.;;;;;,   ]],   gd[[cllll;]]              },
            { b[[:cccc;]]          ,g[[ .;;;;;;. ]],   gd[[coooo;]]              },
            { b[[;llll;]]          ,g[[   ,:::::']],   gd[[loooo;]]              },
            { b[[;llll:]]          ,g[[    ':::::]],   gdd[[l]],     gd[[oooo:]] },
            { b[[:oooo:]]          ,g[[     .::::]],   gdd[[ll]],    gd[[odd:]]  },
            { b[[.;ooo:]]          ,g[[       ;cc]],   gdd[[loo]],   gd[[o:.]]   },
            { b[[  .;oc]]          ,g[[        'c]],   gdd[[oo;.  ]]             },
            { b[[    .']]          ,g[[         .]],   gdd[[,.    ]]             },
        }
        logo = {
            type = 'text',
            val = logo.text,
            opts = {
                position= 'center',
                hl = logo.highlights
            }
        }

        local header = span('An editor that you don\'t want to exit', 'Number')


        local buttons = {
            type = 'group',
            val = {
                span(align_strings(separator, ' New ', separator, width), 'Title'),
                button('<LEADER>bn', '', 'New file'),
                span(align_strings(separator, ' Open ', separator, width), 'Title'),
                button('<LEADER>tf', '','Go to file'),
                button('<LEADER>tg', '', 'Search string'),
                button('<LEADER>f',  '', 'Show file browser'),
                span(align_strings(separator, ' Other ', separator, width), 'Title'),
                -- TODO
                button('<A-CR>',     '', 'Toggle terminal'),
                button('<LEADER>pp', '', 'Open plugin manager'),
                button(':q', '󰩈', 'Quit', '<CMD>q<CR>'),
            }
        }

        local lazy = require('lazy')

        ---@param total integer
        ---@param loaded integer?
        ---@param time number?
        ---@return string
        local function lazy_text(total, loaded, time)
            return (
                ' ' .. (loaded and loaded .. '/' .. total or total)
                .. '  󱦟 ' .. (time and math.floor(time + 0.5) or '___') .. ' ms'
            )
        end
        local lazy_span = span(lazy_text(lazy.stats().count), 'Number')

        local footer = {
            type = 'group',
            val = {
                span(tostring(os.date(' %Y-%m-%d   %H:%M:%S')), 'Number'),
                lazy_span,
                (function()
                    local user = os.getenv('USER') or os.getenv('USERNAME')
                    if user then
                        return span(' ' .. user, 'Number')
                    end
                end)()
            }
        }

        vim.api.nvim_create_autocmd(
            'User',
            {
                pattern = 'LazyVimStarted',
                callback = function()
                    local stats = lazy.stats()
                    lazy_span.val = lazy_text(stats.loaded, stats.loaded, stats.startuptime)
                    vim.cmd('AlphaRedraw')
                end
            }
        )


        require('alpha').setup {
            layout = {
                { type = 'padding', val = 2 },
                logo,
                { type = 'padding', val = 1 },
                header,

                { type = 'padding', val = 2 },
                buttons,

                { type = 'padding', val = 2 },
                footer
            },
            opts = {
                margin = 5,
                keymap = {
                    press = { '<CR>', 'l' },
                    queue_press = nil
                }
            }
        }
    end,
}
