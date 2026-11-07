---@module 'lazy'
---@module 'dropbar'

local shared = require('shared')
local util = require('util')

---@type LazySpec
return {
    'Bekaboo/dropbar.nvim',
    event = {'LazyFile', 'TermOpen'},
    keys = {
        util.map
            :k('[;', 'Go to start of current context')
            :bind({'n', 'x', 'o'}, function() require('dropbar.api').goto_context_start() end)
            :spec(),
        util.map
            :k('];', 'Go to context sibling')
            :bind({'n', 'x', 'o'}, function() require('dropbar.api').select_next_context() end)
            :spec(),
        shared.keys.find
            :k(';', 'context')
            :bind('n', function() require('dropbar.api').pick() end)
            :spec(),
    },
    ---@return dropbar_configs_t
    opts = function()
        return {
            icons = {
                kinds = {
                    dir_icon = function(path)
                        local icon, hl = require('mini.icons').get('directory', path)
                        return icon .. ' ', hl
                    end,
                    symbols = vim.tbl_map(shared.icons.pad, {
                        Array             = shared.icons.kind.data.array,
                        BlockMappingPair  = shared.icons.kind.member.pair,
                        Boolean           = shared.icons.kind.data.boolean,
                        BreakStatement    = shared.icons.kind.control['break'],
                        Call              = shared.icons.kind.callable.call,
                        CaseStatement     = shared.icons.kind.control.case,
                        Class             = shared.icons.kind.type.class,
                        Color             = shared.icons.kind.data.color,
                        Constant          = shared.icons.kind.data.constant,
                        Constructor       = shared.icons.kind.callable.constructor,
                        ContinueStatement = shared.icons.kind.control.continue,
                        Copilot           = shared.icons.plugin.kind.copilot,
                        Declaration       = shared.icons.kind.name.declaration,
                        Delete            = shared.icons.kind.callable.delete,
                        DoStatement       = shared.icons.kind.control['do'],
                        Element           = shared.icons.kind.markup.element,
                        Enum              = shared.icons.kind.type.enum,
                        EnumMember        = shared.icons.kind.type.enum_member,
                        Event             = shared.icons.kind.member.event,
                        Field             = shared.icons.kind.member.field,
                        File              = shared.icons.kind.container.file,
                        Folder            = shared.icons.kind.container.folder,
                        ForStatement      = shared.icons.kind.control['for'],
                        Function          = shared.icons.kind.callable['function'],
                        GotoStatement     = shared.icons.kind.control['goto'],
                        Identifier        = shared.icons.kind.name.identifier,
                        IfStatement       = shared.icons.kind.control['if'],
                        Interface         = shared.icons.kind.type.interface,
                        Keyword           = shared.icons.kind.name.keyword,
                        List              = shared.icons.kind.data.list,
                        Log               = shared.icons.plugin.kind.log,
                        Lsp               = shared.icons.plugin.kind.lsp,
                        Macro             = shared.icons.kind.callable.macro,
                        MarkdownH1        = shared.icons.kind.markup.heading.h1,
                        MarkdownH2        = shared.icons.kind.markup.heading.h2,
                        MarkdownH3        = shared.icons.kind.markup.heading.h3,
                        MarkdownH4        = shared.icons.kind.markup.heading.h4,
                        MarkdownH5        = shared.icons.kind.markup.heading.h5,
                        MarkdownH6        = shared.icons.kind.markup.heading.h6,
                        Method            = shared.icons.kind.callable.method,
                        Module            = shared.icons.kind.container.module,
                        Namespace         = shared.icons.kind.container.namespace,
                        Null              = shared.icons.kind.data.null,
                        Number            = shared.icons.kind.data.number,
                        Object            = shared.icons.kind.data.object,
                        Operator          = shared.icons.kind.callable.operator,
                        Package           = shared.icons.kind.container.package,
                        Pair              = shared.icons.kind.member.pair,
                        Property          = shared.icons.kind.member.property,
                        Reference         = shared.icons.kind.name.reference,
                        Regex             = shared.icons.kind.data.regex,
                        Repeat            = shared.icons.kind.control['repeat'],
                        Return            = shared.icons.kind.control['return'],
                        ReturnStatement   = shared.icons.kind.control['return'],
                        Rule              = shared.icons.kind.markup.rule,
                        RuleSet           = shared.icons.kind.markup.rule_set,
                        Scope             = shared.icons.kind.container.scope,
                        Section           = shared.icons.kind.container.section,
                        Snippet           = shared.icons.kind.markup.snippet,
                        Specifier         = shared.icons.kind.name.specifier,
                        Statement         = shared.icons.kind.control.statement,
                        String            = shared.icons.kind.data.string,
                        Struct            = shared.icons.kind.type.struct,
                        SwitchStatement   = shared.icons.kind.control.switch,
                        Table             = shared.icons.kind.data.table,
                        Terminal          = shared.icons.mode.icon.terminal,
                        Text              = shared.icons.kind.markup.text,
                        Type              = shared.icons.kind.type.definition,
                        TypeParameter     = shared.icons.kind.type.type_parameter,
                        Unit              = shared.icons.kind.data.unit,
                        Value             = shared.icons.kind.data.value,
                        Variable          = shared.icons.kind.data.variable,
                        WhileStatement    = shared.icons.kind.control['while'],
                    }),
                },
                ui = {
                    bar = {
                        separator = ' ' .. shared.icons.ui.next .. ' ',
                        extends = shared.icons.ui.ellipsis,
                    },
                    menu = {
                        separator = ' ',
                        indicator = shared.icons.ui.closed,
                    },
                },
            }
        }
    end,
}
