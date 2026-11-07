---@module 'lazy'
---@module 'snacks'

local shared = require('shared')

local function picker(name)
    return function() require('snacks').picker[name]() end
end

---@param defaults table<string, any>
---@param keys table<string, any>
---@return table<string, any>
local function overwrite_defaults(defaults, keys)
    local ret = {}
    for key in pairs(defaults) do
        ret[key] = false
    end
    return vim.tbl_extend('force', ret, keys)
end

---@type LazySpec
return {
    shared.plugins.names.snacks,
    keys = {
        shared.keys.find:k('f', 'Files'):bind('n', picker('files')):spec(),
        shared.keys.find:k('g', 'Grep'):bind('n', picker('grep')):spec(),
        shared.keys.find:k(':', 'Command history'):bind('n', picker('command_history')):spec(),
        shared.keys.find:k('/', 'Search history'):bind('n', picker('search_history')):spec(),
        shared.keys.find:k('m', 'Help'):bind('n', picker('help')):spec(),
        shared.keys.find:k('M', 'Man'):bind('n', picker('man')):spec(),
        shared.keys.find:k('P', 'Pickers'):bind('n', picker('pickers')):spec(),
        shared.keys.find:k('C', 'Colorschemes'):bind('n', picker('colorschemes')):spec(),
        shared.keys.find:k('H', 'Highlight groups'):bind('n', picker('highlights')):spec(),
        shared.keys.find:k('I', 'Icons'):bind('n', picker('icons')):spec(),
        shared.keys.find:k('L', 'Plugin specs'):bind('n', picker('lazy')):spec(),
        shared.keys.find:k('N', 'Notifications'):bind('n', picker('notifications')):spec(),
    },
    ---@param opts snacks.Config
    ---@return snacks.Config
    opts = function(_, opts)
        local defaults = require('snacks.picker.config.defaults').defaults

        return vim.tbl_deep_extend('force', opts, {
            picker = {
                enabled = true,
                prompt = shared.icons.ui.prompt .. ' ',
                sources = {
                    files = { hidden = true },
                    grep = { hidden = true },
                },
                matcher = {
                    sort_empty = true,
                    cwd_bonus = true,
                },
                formatters = { severity = { pos = 'right' } },
                layouts = {
                    default = { layout = { backdrop = false } },
                },
                icons = {
                    files = {
                        dir = shared.icons.folder.regular,
                        dir_open = shared.icons.folder.regular_open,
                        file = shared.icons.kind.container.file,
                    },
                    tree = {
                        vertical = shared.icons.ui.tree.vertical,
                        middle = shared.icons.ui.tree.middle,
                        last = shared.icons.ui.tree.last,
                    },
                    keymaps = {
                        nowait = shared.icons.key.nowait,
                    },
                    undo = {
                        saved = shared.icons.file.states.saved,
                    },
                    ui = {
                        live = shared.icons.ui.live,
                        selected = shared.icons.ui.filled .. ' ',
                        unselected = shared.icons.ui.empty .. ' ',
                    },
                    git = {
                        commit = shared.icons.git.repo.commit,
                        staged = shared.icons.git.status.staged,
                        added = shared.icons.git.status.added,
                        deleted = shared.icons.git.status.deleted,
                        ignored = shared.icons.git.status.ignored,
                        modified = shared.icons.git.status.changed,
                        renamed = shared.icons.git.status.renamed,
                        unmerged = shared.icons.git.status.unmerged,
                        untracked = shared.icons.git.status.untracked,
                    },
                    lsp = {
                        unavailable = shared.icons.plugin.lsp.unavailable,
                        enabled = shared.icons.plugin.lsp.enabled,
                        disabled = shared.icons.plugin.lsp.disabled,
                        attached = shared.icons.plugin.lsp.attached,
                    },
                    diagnostics = {
                        Error = shared.icons.severity.error,
                        Warn = shared.icons.severity.warning,
                        Hint = shared.icons.severity.hint,
                        Info = shared.icons.severity.info,
                    },
                    kinds = {
                        Array         = shared.icons.kind.data.array,
                        Boolean       = shared.icons.kind.data.boolean,
                        Class         = shared.icons.kind.type.class,
                        Color         = shared.icons.kind.data.color,
                        Control       = shared.icons.kind.control.statement,
                        Collapsed     = shared.icons.ui.closed,
                        Constant      = shared.icons.kind.data.constant,
                        Constructor   = shared.icons.kind.callable.constructor,
                        Copilot       = shared.icons.plugin.kind.copilot,
                        Enum          = shared.icons.kind.type.enum,
                        EnumMember    = shared.icons.kind.type.enum_member,
                        Event         = shared.icons.kind.member.event,
                        Field         = shared.icons.kind.member.field,
                        File          = shared.icons.kind.container.file,
                        Folder        = shared.icons.kind.container.folder,
                        Function      = shared.icons.kind.callable['function'],
                        Interface     = shared.icons.kind.type.interface,
                        Key           = shared.icons.kind.member.key,
                        Keyword       = shared.icons.kind.name.keyword,
                        Method        = shared.icons.kind.callable.method,
                        Module        = shared.icons.kind.container.module,
                        Namespace     = shared.icons.kind.container.namespace,
                        Null          = shared.icons.kind.data.null,
                        Number        = shared.icons.kind.data.number,
                        Object        = shared.icons.kind.data.object,
                        Operator      = shared.icons.kind.callable.operator,
                        Package       = shared.icons.kind.container.package,
                        Property      = shared.icons.kind.member.property,
                        Reference     = shared.icons.kind.name.reference,
                        Snippet       = shared.icons.kind.markup.snippet,
                        String        = shared.icons.kind.data.string,
                        Struct        = shared.icons.kind.type.struct,
                        Text          = shared.icons.kind.markup.text,
                        TypeParameter = shared.icons.kind.type.type_parameter,
                        Unit          = shared.icons.kind.data.unit,
                        Unknown       = shared.icons.kind.misc,
                        Value         = shared.icons.kind.data.value,
                        Variable      = shared.icons.kind.data.variable,
                    },
                },
                win = {
                    input = {
                        keys = overwrite_defaults(defaults.win.input.keys, {
                            -- Focus
                            ['q'] = { 'cancel' },
                            ['<Esc>'] = { 'cancel' },
                            ['/'] = { 'toggle_focus' },
                            ['<a-w>'] = { 'toggle_focus', mode = { 'i', 'n' } },
                            ['<a-f>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
                            -- Input
                            ['<C-w>'] = { '<c-s-w>', desc = 'delete word', expr = true, mode = { 'i' } },
                            -- Navigation
                            ['j'] = { 'list_down' },
                            ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
                            ['k'] = { 'list_up' },
                            ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
                            ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
                            ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
                            ['G'] = { 'list_bottom' },
                            ['gg'] = { 'list_top' },
                            -- Flags
                            ['<c-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
                            ['<c-d>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
                            ['<c-x>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
                            ['<c-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
                            ['<c-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
                            ['<c-r>'] = { 'toggle_regex', mode = { 'i', 'n' } },
                            -- Accept
                            ['<c-l>'] = { 'confirm', mode = { 'i', 'n' } },
                            ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
                            ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
                            ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
                            ['<c-t>'] = { 'tab', mode = { 'n', 'i' } },
                            -- Other
                            ['<c-y>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
                            ['<c-e>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
                            ['?'] = { 'toggle_help_input' },
                        }),
                    },
                    list = {
                        keys = overwrite_defaults(defaults.win.list.keys, {
                            -- Focus
                            ['q'] = { 'cancel' },
                            ['<Esc>'] = { 'cancel' },
                            ['/'] = { 'toggle_focus' },
                            ['<a-w>'] = { 'toggle_focus' },
                            ['<a-f>'] = { 'toggle_maximize' },
                            -- Navigation
                            ['j'] = { 'list_down' },
                            ['k'] = { 'list_up' },
                            ['<Up>'] = { 'list_up' },
                            ['<Down>'] = { 'list_down' },
                            ['G'] = { 'list_bottom' },
                            ['gg'] = { 'list_top' },
                            -- Flags
                            ['<c-f>'] = { 'toggle_follow' },
                            ['<c-d>'] = { 'toggle_hidden' },
                            ['<c-x>'] = { 'toggle_ignored' },
                            ['<c-p>'] = { 'toggle_preview' },
                            -- Accept
                            ['l'] = { 'confirm' },
                            ['<CR>'] = { 'confirm' },
                            ['<2-LeftMouse>'] = { 'confirm' },
                            ['<c-s>'] = { 'edit_split' },
                            ['<c-v>'] = { 'edit_vsplit' },
                            ['<c-t>'] = { 'tab' },
                            -- Other
                            ['<c-y>'] = { 'preview_scroll_up' },
                            ['<c-e>'] = { 'preview_scroll_down' },
                            ['?'] = { 'toggle_help_list' },
                        }),
                    },
                    preview = {
                        keys = overwrite_defaults(defaults.win.preview.keys, {
                            -- Focus
                            ['q'] = { 'cancel' },
                            ['<Esc>'] = { 'cancel' },
                            ['/'] = { 'focus_input' },
                            ['<a-w>'] = { 'focus_input' },
                            ['a'] = { 'focus_input' },
                            ['A'] = { 'focus_input' },
                            ['<a-f>'] = { 'toggle_maximize' },
                            -- Other
                            ['?'] = { 'toggle_help_preview' },
                        }),
                    },
                },
            },
        })
    end,
}
