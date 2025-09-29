local icon = require('util.icon')

return {
    'echasnovski/mini.nvim',
    config = function(_, opts)
        for k, v in pairs(opts) do
            require('mini.' .. k).setup(v)
        end
    end,
    opts = {
        ai = {
            n_lines = 500,
            silent = true
        },
        jump = {
            delay = {
                highlight = 0,
                idle_stop = 2000,
            },
            silent = true
        },
        icons = {
            style = vim.g.enable_tty_mode and 'ascii' or 'glyph',
            -- TODO: import icons from `config.icons`
            lsp = {
                array         = { glyph = icon.token.array          },
                boolean       = { glyph = icon.token.boolean        },
                class         = { glyph = icon.token.class          },
                color         = { glyph = icon.token.color          },
                constant      = { glyph = icon.token.constant       },
                constructor   = { glyph = icon.token.constructor    },
                enum          = { glyph = icon.token.enum           },
                enummember    = { glyph = icon.token.enum_member    },
                event         = { glyph = icon.token.event          },
                field         = { glyph = icon.token.field          },
                file          = { glyph = icon.token.file           },
                folder        = { glyph = icon.token.folder         },
                ['function']  = { glyph = icon.token['function']    },
                interface     = { glyph = icon.token.interface      },
                key           = { glyph = icon.token.key            },
                keyword       = { glyph = icon.token.keyword        },
                method        = { glyph = icon.token.method         },
                module        = { glyph = icon.token.module         },
                namespace     = { glyph = icon.token.namespace      },
                null          = { glyph = icon.token.null           },
                number        = { glyph = icon.token.number         },
                object        = { glyph = icon.token.object         },
                operator      = { glyph = icon.token.operator       },
                package       = { glyph = icon.token.package        },
                property      = { glyph = icon.token.property       },
                reference     = { glyph = icon.token.reference      },
                snippet       = { glyph = icon.token.snippet        },
                string        = { glyph = icon.token.string         },
                struct        = { glyph = icon.token.struct         },
                text          = { glyph = icon.token.text           },
                typeparameter = { glyph = icon.token.type_parameter },
                unit          = { glyph = icon.token.unit           },
                value         = { glyph = icon.token.value          },
                variable      = { glyph = icon.token.variable       },
            },
        }
    },
    event = 'VeryLazy'
}
