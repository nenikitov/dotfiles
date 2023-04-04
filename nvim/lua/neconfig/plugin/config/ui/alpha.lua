---@param str string
---@param length integer
---@return string centered
local function center(str, length)
    local str_length = str:len()

    if str_length >= length then
        return str
    else
        local left = math.floor((length - str_length) / 2)
        local right = length - (str_length + left)

        return (
            (' '):rep(left)
            .. str
            .. (' '):rep(right)
        )
    end
end

---@param section string[]
---@return string[] centered
local function center_section(section)
    local max_length = 0
    for _, s in ipairs(section) do
        local str_length = s:len()
        if str_length > max_length then
            max_length = str_length
        end
    end

    return vim.tbl_map(
        function(s) return center(s, max_length) end,
        section
    )
end

return {
    'goolord/alpha-nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    event = 'VimEnter',
    config = function()
        local theme = require('alpha.themes.dashboard')

        theme.section.header.val = center_section {
            [[     .          .     ]],
            [[   ';;,.        ::'   ]],
            [[ ,:::;,,        :ccc, ]],
            [[,::c::,,,,.     :cccc,]],
            [[,cccc:;;;;;.    cllll,]],
            [[,cccc;.;;;;;,   cllll;]],
            [[:cccc; .;;;;;;. coooo;]],
            [[;llll;   ,:::::'loooo;]],
            [[;llll:    ':::::loooo:]],
            [[:oooo:     .::::llodd:]],
            [[.;ooo:       ;cclooo:.]],
            [[  .;oc        'coo;.  ]],
            [[    .'         .,.    ]],
            [[]],
            [[An editor that you don't want to exit]],
        }
        local blue = 'DevIconLua'
        local cyan = 'DevIconMint'
        local green = 'DevIconBash'
        local green_darker = 'DevIconXls'
        local green_darkest = 'DevIconVim'
        -- TODO Create a logo coloring utility
        theme.section.header.opts.hl = {
            { { cyan, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { cyan, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { cyan, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { blue, 0, 999 }, { cyan, 11, 999 },  { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darkest, 23, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darker, 23, 999 }, { green_darkest, 25, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darker, 23, 999 }, { green_darkest, 26, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darker, 23, 999 } },
            { { blue, 0, 999 }, { green, 13, 999 }, { green_darker, 23, 999 } },
            { {'String', 0, 999 } },
            { {'String', 0, 999 } },
        }

        theme.section.buttons.val = {
            theme.button('<LEADER>bn', '  New file')
        }

        local lazy_stats = require('lazy').stats()
        theme.section.footer.val = center_section {
            tostring(os.date(' %Y-%m-%d   %H:%M:%S')),
            ' ' .. lazy_stats.count .. '  󱦟 ' .. math.floor(lazy_stats.times['LazyDone'] + 0.5) .. ' ms',
            ' ' .. os.getenv('USER'),
        }

        require('alpha').setup(theme.config)
    end,
}
