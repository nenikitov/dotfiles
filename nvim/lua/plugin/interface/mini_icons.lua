---@module 'lazy'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.mini_icons,
	opts = {
        style = shared.settings.enable_tty_mode and 'ascii' or 'glyph',
        lsp = {
            array         = { glyph = shared.icons.kind.data.array },
            boolean       = { glyph = shared.icons.kind.data.boolean },
            class         = { glyph = shared.icons.kind.type.class },
            color         = { glyph = shared.icons.kind.data.color },
            constant      = { glyph = shared.icons.kind.data.constant },
            constructor   = { glyph = shared.icons.kind.callable.constructor },
            enum          = { glyph = shared.icons.kind.type.enum },
            enummember    = { glyph = shared.icons.kind.type.enum_member },
            event         = { glyph = shared.icons.kind.member.event },
            field         = { glyph = shared.icons.kind.member.field },
            file          = { glyph = shared.icons.kind.container.file },
            folder        = { glyph = shared.icons.kind.container.folder },
            ['function']  = { glyph = shared.icons.kind.callable['function'] },
            interface     = { glyph = shared.icons.kind.type.interface },
            key           = { glyph = shared.icons.kind.member.key },
            keyword       = { glyph = shared.icons.kind.name.keyword },
            misc          = { glyph = shared.icons.kind.misc },
            method        = { glyph = shared.icons.kind.callable.method },
            module        = { glyph = shared.icons.kind.container.module },
            namespace     = { glyph = shared.icons.kind.container.namespace },
            null          = { glyph = shared.icons.kind.data.null },
            number        = { glyph = shared.icons.kind.data.number },
            object        = { glyph = shared.icons.kind.data.object },
            operator      = { glyph = shared.icons.kind.callable.operator },
            package       = { glyph = shared.icons.kind.container.package },
            property      = { glyph = shared.icons.kind.member.property },
            reference     = { glyph = shared.icons.kind.name.reference },
            snippet       = { glyph = shared.icons.kind.markup.snippet },
            string        = { glyph = shared.icons.kind.data.string },
            struct        = { glyph = shared.icons.kind.type.struct },
            text          = { glyph = shared.icons.kind.markup.text },
            typeparameter = { glyph = shared.icons.kind.type.type_parameter },
            unit          = { glyph = shared.icons.kind.data.unit },
            value         = { glyph = shared.icons.kind.data.value },
            variable      = { glyph = shared.icons.kind.data.variable },
        },
	},
	init = function()
		-- Plugins asking for nvim-web-devicons get mini.icons instead, loaded on first use
		package.preload['nvim-web-devicons'] = function()
			require('mini.icons').mock_nvim_web_devicons()
			return package.loaded['nvim-web-devicons']
		end
	end,
}
