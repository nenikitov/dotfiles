---@module 'lazy'

local shared = require('shared')

---@type LazySpec
return {
    shared.plugins.names.mini_icons,
	opts = {
        style = shared.settings.enable_tty_mode and 'ascii' or 'glyph',
        lsp = {
            array         = { glyph = shared.icons.kind.array },
            boolean       = { glyph = shared.icons.kind.boolean },
            class         = { glyph = shared.icons.kind.class },
            color         = { glyph = shared.icons.kind.color },
            constant      = { glyph = shared.icons.kind.constant },
            constructor   = { glyph = shared.icons.kind.constructor },
            enum          = { glyph = shared.icons.kind.enum },
            enummember    = { glyph = shared.icons.kind.enum_member },
            event         = { glyph = shared.icons.kind.event },
            field         = { glyph = shared.icons.kind.field },
            file          = { glyph = shared.icons.kind.file },
            folder        = { glyph = shared.icons.kind.folder },
            ['function']  = { glyph = shared.icons.kind['function'] },
            interface     = { glyph = shared.icons.kind.interface },
            key           = { glyph = shared.icons.kind.key },
            keyword       = { glyph = shared.icons.kind.keyword },
            misc          = { glyph = shared.icons.kind.misc },
            method        = { glyph = shared.icons.kind.method },
            module        = { glyph = shared.icons.kind.module },
            namespace     = { glyph = shared.icons.kind.namespace },
            null          = { glyph = shared.icons.kind.null },
            number        = { glyph = shared.icons.kind.number },
            object        = { glyph = shared.icons.kind.object },
            operator      = { glyph = shared.icons.kind.operator },
            package       = { glyph = shared.icons.kind.package },
            property      = { glyph = shared.icons.kind.property },
            reference     = { glyph = shared.icons.kind.reference },
            snippet       = { glyph = shared.icons.kind.snippet },
            string        = { glyph = shared.icons.kind.string },
            struct        = { glyph = shared.icons.kind.struct },
            text          = { glyph = shared.icons.kind.text },
            typeparameter = { glyph = shared.icons.kind.type_parameter },
            unit          = { glyph = shared.icons.kind.unit },
            value         = { glyph = shared.icons.kind.value },
            variable      = { glyph = shared.icons.kind.variable },
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
