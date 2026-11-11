---@module 'lazy'
---@module 'fyler'

local shared = require('shared')

---@type LazySpec
return {
    'FylerOrg/fyler.nvim',
    keys = {
        shared.keys.find_explorer:bind('n', '<CMD>Fyler<CR>'):spec()
    },
    -- TODO: Figure out Partial<T>
    ---@diagnostic disable: missing-fields
    ---@type fyler.Config
    opts = {
        -- TODO: Set indent icons
        integrations = {
            icon = 'mini_icons',
        },
        extensions = {
            git = {
                enabled = true,
                inline = false,
                icons = {
                    ['C '] = { icon = shared.icons.git.status.added },
                    ['AM'] = { icon = shared.icons.git.status.changed },
                    [' M'] = { icon = shared.icons.git.status.changed },
                    ['MM'] = { icon = shared.icons.git.status.changed },
                    ['CM'] = { icon = shared.icons.git.status.changed },
                    [' D'] = { icon = shared.icons.git.status.deleted },
                    ['D '] = { icon = shared.icons.git.status.deleted },
                    ['MD'] = { icon = shared.icons.git.status.deleted },
                    ['RD'] = { icon = shared.icons.git.status.deleted },
                    ['!!'] = { icon = shared.icons.git.status.ignored },
                    ['R '] = { icon = shared.icons.git.status.renamed },
                    ['A '] = { icon = shared.icons.git.status.staged },
                    ['M '] = { icon = shared.icons.git.status.staged },
                    ['??'] = { icon = shared.icons.git.status.untracked },
                    ['UU'] = { icon = shared.icons.git.status.unmerged },
                    ['AA'] = { icon = shared.icons.git.status.unmerged },
                    ['AU'] = { icon = shared.icons.git.status.unmerged },
                    ['UD'] = { icon = shared.icons.git.status.unmerged },
                    ['UA'] = { icon = shared.icons.git.status.unmerged },
                    ['DU'] = { icon = shared.icons.git.status.unmerged },
                    ['DD'] = { icon = shared.icons.git.status.unmerged },
                },
            },
            watcher = { enabled = true },
        },
        kind = 'floating',
        kind_presets = {
            floating = {
                border = vim.o.winborder,
                width = '80%',
                height = '80%',
            },
        },
        ui = {
            hidden_items = {
            },
            indent_guides = true,
        },
    },
    ---@diagnostic enable: missing-fields
}
